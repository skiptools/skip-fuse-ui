// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if os(macOS) && !SKIP_BRIDGE
import SwiftUI
import Observation
#else
import SkipFuse
import SkipSwiftUI
#endif

/// Drives identical state mutations from native SwiftUI and bridged Compose tests.
/// The closures are installed after mounting so they address real, persistent view state.
@MainActor public final class AnimationLifetimeDriver {
    private var animateAction: (() -> Void)?
    private var dragAction: (() -> Void)?

    /// Creates a driver whose actions become available when its fixture appears.
    public init() {}

    /// Whether the fixture has mounted and installed its actions.
    public var isReady: Bool { animateAction != nil && dragAction != nil }

    /// Advances the shared anchor by 80 points using a one-second linear animation.
    public func animateAnchor() { animateAction?() }

    /// Advances the drag position by 40 points without animation.
    public func advanceDrag() { dragAction?() }

    /// Bind to the mounted view's state, rather than a temporary view value made by a test.
    func install(animate: @escaping () -> Void, drag: @escaping () -> Void) {
        animateAction = animate
        dragAction = drag
    }

    func clear() {
        animateAction = nil
        dragAction = nil
    }
}

/// Reference-property variant of the shared animated source; drag remains separate `@State`.
@Observable final class AnimationLifetimeAnchor {
    var position = 0.0
}

/// Owns one observable source shared by separately evaluated, already-mounted consumers.
/// No parent reads the position: each child must capture the write's animation itself.
@MainActor public final class SharedAnimationLifetimeDriver {
    let anchor = AnimationLifetimeAnchor()
    let drag = AnimationLifetimeAnchor()

    /// Creates shared state before either consumer mounts.
    public init() {}

    /// A single write must animate every existing consumer, regardless of composition root.
    public func animateAnchor() {
        withAnimation(.linear(duration: 1)) { anchor.position += 80 }
    }

    /// Exercises later observation and stamp expiry independently of the animated property.
    public func advanceDrag() {
        withAnimation(nil) { drag.position += 40 }
    }
}

/// Reads shared state in its own body, rather than receiving a parent's captured offset.
public struct SharedAnimationLifetimeConsumer: View {
    let driver: SharedAnimationLifetimeDriver
    let first: Bool

    /// Identifies the consumer so tests can measure it across separate rendering roots.
    public init(driver: SharedAnimationLifetimeDriver, first: Bool) {
        self.driver = driver
        self.first = first
    }

    /// Fixed outer bounds keep root layout changes out of the measured displacement.
    public var body: some View {
        (first ? Color.red : Color.green)
            .frame(width: 60, height: 24)
            .accessibilityIdentifier(first ? "lifetime-first" : "lifetime-second")
            .offset(y: driver.anchor.position + driver.drag.position)
            .frame(width: 100, height: 340, alignment: .top)
    }
}

/// Two siblings consume the same animated anchor and independently capture their offsets.
/// Only imports differ on macOS: the reference run uses Apple's actual SwiftUI renderer.
public struct AnimationLifetimeFixture: View {
    let driver: AnimationLifetimeDriver
    let useObservable: Bool
    let deferSecondConsumer: Bool
    @State var anchor = 0.0
    @State var observableAnchor = AnimationLifetimeAnchor()
    @State var drag = 0.0

    /// Chooses native value-state or observable-property provenance for the animated source.
    public init(driver: AnimationLifetimeDriver, useObservable: Bool, deferSecondConsumer: Bool = false) {
        self.driver = driver
        self.useObservable = useObservable
        self.deferSecondConsumer = deferSecondConsumer
    }

    private var anchorPosition: Double {
        useObservable ? observableAnchor.position : anchor
    }

    /// Reading inside a layout callback probes whether a prior consumer clears the stamp too early.
    private var secondConsumer: some View {
        Color.green.frame(width: 60, height: 24)
            .accessibilityIdentifier("lifetime-second")
            .offset(y: drag + anchorPosition)
    }

    /// Render both consumers of the shared anchor and controls for manual reproduction.
    public var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 40) {
                Color.red.frame(width: 60, height: 24)
                    // Tag the moving content, not the offset modifier's stationary bounds.
                    .accessibilityIdentifier("lifetime-first")
                    .offset(y: anchorPosition + drag)
                // Reverse read order: stale-stamp behavior must not depend on operand order.
                if deferSecondConsumer {
                    GeometryReader { _ in secondConsumer }
                        .frame(width: 60, height: 24)
                } else {
                    secondConsumer
                }
            }
            .frame(width: 220, height: 340, alignment: .top)
            Button("Animate anchor") { driver.animateAnchor() }
            Button("Advance drag") { driver.advanceDrag() }
        }
        .onAppear {
            driver.install(animate: {
                withAnimation(.linear(duration: 1)) {
                    if useObservable { observableAnchor.position += 80 }
                    else { anchor += 80 }
                }
            }, drag: {
                withAnimation(nil) { drag += 40 }
            })
        }
        .onDisappear { driver.clear() }
    }
}

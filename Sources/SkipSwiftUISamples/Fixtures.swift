// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipFuse
import SkipSwiftUI

// Native sample views for the transpiled `SkipSwiftUISamplesTests` Compose UI tests.
//
// SkipSwiftUI is a native (Skip Fuse) module, but this package's sample test suite is
// transpiled, so the tests run as Kotlin/JUnit with full access to the Compose testing APIs.
// The transpiled tests construct these views through their generated bridged Kotlin facades
// (this module sets `bridging: true`, so all public API is auto-bridged), render them with
// `createComposeRule`, and interact through Compose semantics (clicks, size and text
// assertions) — exercising the complete native loop: bridged body evaluation, native
// `@State` storage, `withAnimation` provenance priming, and the SkipUI Compose rendering of
// the bridged tree.

/// Sample: two rects driven by separate `@State` slots, one toggled inside
/// `withAnimation` and one outside, plus a plain-toggle control.
public struct AnimatedSquaresTestFixture: View {
    @State var animated = false
    @State var unrelated = false

    public init() {
    }

    public var body: some View {
        VStack {
            Color.red
                .frame(width: animated ? 300.0 : 100.0, height: 50.0)
                .accessibilityIdentifier("animated-rect")
            Color.green
                .frame(width: unrelated ? 300.0 : 100.0, height: 50.0)
                .accessibilityIdentifier("unrelated-rect")
            // The two-square pattern: one state toggled inside withAnimation, one outside.
            Button("animate") {
                withAnimation(.linear(duration: 1.0)) {
                    animated.toggle()
                }
                unrelated.toggle()
            }
            .accessibilityIdentifier("animate-button")
            // Plain toggle with no withAnimation: the rect must snap.
            Button("snap") {
                animated.toggle()
            }
            .accessibilityIdentifier("snap-button")
        }
    }
}

/// Minimal static sample for smoke-testing that a bridged native view renders.
public struct LabelTestFixture: View {
    public init() {
    }

    public var body: some View {
        Text("native-hello")
            .accessibilityIdentifier("native-label")
    }
}

/// Sample: a label bound to an `Int` state incremented by a button — verifies state-driven
/// text updates flowing through the bridge on each recomposition.
public struct CounterTestFixture: View {
    @State var count = 0

    public init() {
    }

    public var body: some View {
        VStack {
            Text("count: \(count)")
                .accessibilityIdentifier("counter-label")
            Button("increment") {
                count += 1
            }
            .accessibilityIdentifier("increment-button")
        }
    }
}

/// Observable model for the `@Observable` provenance samples.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@Observable
final class ObservableSquaresModel {
    var animatedWidth = 100.0
    var unrelatedWidth = 100.0
}

/// Sample: two rects driven by properties of an `@Observable` model held in `@State`; the
/// button mutates one property inside `withAnimation` and one outside in the same handler.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ObservableSquaresTestFixture: View {
    @State var model = ObservableSquaresModel()

    public init() {
    }

    public var body: some View {
        VStack {
            Color.red
                .frame(width: model.animatedWidth, height: 50.0)
                .accessibilityIdentifier("obs-animated-rect")
            Color.green
                .frame(width: model.unrelatedWidth, height: 50.0)
                .accessibilityIdentifier("obs-unrelated-rect")
            Button("animate") {
                model.unrelatedWidth = 300.0
                withAnimation(.linear(duration: 1.0)) {
                    model.animatedWidth = 300.0
                }
            }
            .accessibilityIdentifier("obs-animate-button")
        }
    }
}

/// Sample: same two-square invariant, but the reading child receives the observable through
/// the SwiftUI environment (`.environment(model)` + `@Environment(Model.self)`).
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ObservableEnvironmentSquaresTestFixture: View {
    @State var model = ObservableSquaresModel()

    public init() {
    }

    public var body: some View {
        VStack {
            ObservableEnvironmentTile()
            Button("animate") {
                model.unrelatedWidth = 300.0
                withAnimation(.linear(duration: 1.0)) {
                    model.animatedWidth = 300.0
                }
            }
            .accessibilityIdentifier("obs-env-animate-button")
        }
        .environment(model)
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
struct ObservableEnvironmentTile: View {
    @Environment(ObservableSquaresModel.self) var model: ObservableSquaresModel

    var body: some View {
        VStack {
            Color.red
                .frame(width: model.animatedWidth, height: 50.0)
                .accessibilityIdentifier("obs-env-animated-rect")
            Color.green
                .frame(width: model.unrelatedWidth, height: 50.0)
                .accessibilityIdentifier("obs-env-unrelated-rect")
        }
    }
}

/// Sample: a button that toggles whether a label exists in the tree at all — verifies
/// structural recomposition (bridged node insertion and removal), not just value updates.
public struct ConditionalContentTestFixture: View {
    @State var shown = false

    public init() {
    }

    public var body: some View {
        VStack {
            if shown {
                Text("now you see me")
                    .accessibilityIdentifier("conditional-label")
            }
            Button("toggle") {
                shown.toggle()
            }
            .accessibilityIdentifier("toggle-button")
        }
    }
}

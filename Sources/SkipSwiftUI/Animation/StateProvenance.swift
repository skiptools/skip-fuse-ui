// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SkipAndroidBridge
import SkipUI

/// Native mirror of SkipModel's `StateTracking` provenance machinery, pairing `withAnimation`
/// scopes with the animatable modifiers whose inputs they changed.
///
/// In Skip Fuse the view body and its state live in native Swift, so the Kotlin-side read
/// cursor that drives this pairing in transpiled apps can never observe native reads. This
/// type reproduces the same per-slot design natively: `withAnimation` pushes its animation
/// for the duration of the body, `BridgedStateBox` stamps each state slot on write and
/// reports the stamp on read, and each animatable modifier captures the cursor at entry —
/// argument expressions are evaluated before the call, so the capture pairs the modifier
/// with exactly the reads made by its own arguments. The captured animation is closed over
/// in the modifier's `ModifierView` and primed into the Kotlin cursor (via
/// `SkipUI.Animation.primeBridgedProvenance`) immediately before the bridged modifier call
/// during Java view materialization, where the Kotlin impl's entry capture consumes it.
///
/// All members are main-thread confined: body evaluation and Java materialization run on the
/// main actor (the generated `Swift_composableBody` bridges through `assumeMainActorUnchecked`).
enum StateProvenance {
    nonisolated(unsafe) private static var animationStack: [Animation] = []
    nonisolated(unsafe) private static var readCursor: Animation? = nil

    /// Push the animation of an entered `withAnimation` scope.
    ///
    /// Note: no `Thread.isMainThread` assertion here — under Robolectric the main actor is
    /// the JVM test thread, not the platform main thread, so a thread check would misfire
    /// where the actor confinement is in fact sound.
    static func pushAnimation(_ animation: Animation) {
        _ = installObservationHook
        animationStack.append(animation)
    }

    /// One-time wiring of bridged `@Observable` property accesses into this provenance
    /// tracker (see `BridgedObservationProvenance`): observable property writes stamp their
    /// per-keyPath slot with the innermost active animation and reads feed the same read
    /// cursor that `@State` reads do, so the modifier-entry capture pairs them identically.
    /// Installed lazily at the first `withAnimation` — stamps can only exist after an
    /// animation-scoped write, so earlier reads have nothing to record.
    private static let installObservationHook: Void = {
        #if SKIP_BRIDGE
        BridgedObservationProvenance.currentToken = {
            return StateProvenance.currentAnimation
        }
        BridgedObservationProvenance.recordRead = { token in
            if let animation = token as? Animation {
                StateProvenance.recordRead(animation)
            }
        }
        #endif
    }()

    /// Pop the most recently entered `withAnimation` scope.
    static func popAnimation() {
        if !animationStack.isEmpty {
            animationStack.removeLast()
        }
    }

    /// The animation of the innermost active `withAnimation` scope, if any.
    static var currentAnimation: Animation? {
        return animationStack.last
    }

    /// Record that a state slot stamped with `animation` was just read. First non-nil wins,
    /// matching SwiftUI's "any animated source → animate" composition rule. Callers skip the
    /// call entirely for un-stamped slots.
    static func recordRead(_ animation: Animation) {
        if readCursor == nil {
            readCursor = animation
        }
    }

    /// Consume the cursor at an animatable modifier's entry. Clearing on read prevents the
    /// cursor from leaking to a sibling modifier.
    static func captureLastReadAndClear() -> Animation? {
        guard let animation = readCursor else {
            return nil
        }
        readCursor = nil
        return animation
    }

    /// Consume the cursor and convert to the bridged animation that the modifier's
    /// materialization closure will prime into the Kotlin cursor. The conversion constructs
    /// bridged objects, so this is only callable where the bridge is live (Android); Darwin
    /// uses real SwiftUI and never executes SkipSwiftUI modifiers.
    static func capturePrimedAnimation() -> SkipUI.Animation? {
        return captureLastReadAndClear()?.Java_animation
    }
}

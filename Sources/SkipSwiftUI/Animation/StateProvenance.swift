// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SkipAndroidBridge
import SkipUI

/// One animated write, shared by its readers until a consuming composition is applied.
/// Identity matters: a later write using an equal animation must receive a fresh stamp.
final class AnimationWriteStamp {
    let animation: Animation
    private(set) var isPending = true

    init(animation: Animation) { self.animation = animation }

    /// Expire future source reads without changing animation values already captured by views.
    func didApply() { isPending = false }
}

/// The animation choice and all stamped arguments consumed by one modifier.
/// Keep the animation immutable so acknowledging a sibling does not cancel this capture.
struct CapturedAnimationProvenance {
    let animation: Animation?
    let stamps: [AnimationWriteStamp]

    /// Called only after successful composition; repeated sibling acknowledgements are harmless.
    func didApply() {
        for stamp in stamps { stamp.didApply() }
    }
}

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
    nonisolated(unsafe) private static var readCursor: [AnimationWriteStamp] = []

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
            return StateProvenance.makeWriteStamp()
        }
        BridgedObservationProvenance.recordRead = { token in
            if let stamp = token as? AnimationWriteStamp {
                StateProvenance.recordRead(stamp)
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

    /// Allocate per write, not per animation specification or scope. This also supplies the
    /// opaque token stored by SkipAndroidBridge, so its observation ledger needs no new API.
    static func makeWriteStamp() -> AnimationWriteStamp? {
        currentAnimation.map { AnimationWriteStamp(animation: $0) }
    }

    /// The first pending stamp chooses the animation, but every stamped argument must expire.
    /// Otherwise an ignored second stamp could animate the next plain change to this expression.
    static func recordRead(_ stamp: AnimationWriteStamp) {
        guard stamp.isPending else { return }
        if !readCursor.contains(where: { $0 === stamp }) { readCursor.append(stamp) }
    }

    /// Capturing separates modifier arguments; it does not consume the underlying write yet.
    static func capture() -> CapturedAnimationProvenance {
        let stamps = readCursor.filter { $0.isPending }
        readCursor.removeAll(keepingCapacity: true)
        return CapturedAnimationProvenance(animation: stamps.first?.animation, stamps: stamps)
    }

    /// Consume the cursor at an animatable modifier's entry. Clearing on read prevents the
    /// cursor from leaking to a sibling modifier.
    static func captureLastReadAndClear() -> Animation? {
        capture().animation
    }
}

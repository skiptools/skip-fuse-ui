// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
#if !SKIP
@testable import SkipSwiftUI

/// Native (non-Android) tests for the per-slot animation-provenance runtime that pairs
/// `withAnimation` scopes with the animatable modifiers whose inputs they changed.
///
/// These drive the `StateProvenance` stack directly rather than through `withAnimation`,
/// because `withAnimation` (like all SkipSwiftUI execution paths) converts to bridged
/// `SkipUI.Animation` values, which only exists on Android — on Darwin, SkipFuseUI re-exports
/// real SwiftUI and SkipSwiftUI never executes. The stack/cursor/stamping semantics under
/// test are pure native and platform-independent.
@MainActor final class StateProvenanceTests: XCTestCase {

    override func setUp() async throws {
        // Drain anything a failed sibling test left behind.
        while StateProvenance.currentAnimation != nil {
            StateProvenance.popAnimation()
        }
        _ = StateProvenance.captureLastReadAndClear()
    }

    func testPushPopScope() {
        XCTAssertNil(StateProvenance.currentAnimation)
        StateProvenance.pushAnimation(.linear(duration: 1))
        XCTAssertNotNil(StateProvenance.currentAnimation)
        StateProvenance.pushAnimation(.easeIn(duration: 0.25))
        XCTAssertNotNil(StateProvenance.currentAnimation)
        StateProvenance.popAnimation()
        XCTAssertNotNil(StateProvenance.currentAnimation, "outer scope should be restored after inner pop")
        StateProvenance.popAnimation()
        XCTAssertNil(StateProvenance.currentAnimation)
    }

    func testStateBoxStampsAndReportsProvenance() {
        let box = BridgedStateBox(0, comparator: { $0 == $1 })

        // Plain write: no stamp, read records nothing.
        box.value = 1
        _ = box.value
        XCTAssertNil(StateProvenance.captureLastReadAndClear())

        // Write inside a scope: stamped; a subsequent read records into the cursor and
        // capture-at-entry consumes it exactly once.
        StateProvenance.pushAnimation(.linear(duration: 1))
        box.value = 2
        StateProvenance.popAnimation()
        _ = box.value
        XCTAssertNotNil(StateProvenance.captureLastReadAndClear(), "stamped slot read should populate the cursor")
        XCTAssertNil(StateProvenance.captureLastReadAndClear(), "capture should clear the cursor")

        // A later plain write clears the stale stamp.
        box.value = 3
        _ = box.value
        XCTAssertNil(StateProvenance.captureLastReadAndClear(), "plain write should reset the slot's stamp")
    }

    func testTwoSlotIndependentProvenance() {
        let animated = BridgedStateBox(false, comparator: { (a: Bool, b: Bool) in a == b })
        let unrelated = BridgedStateBox(false, comparator: { (a: Bool, b: Bool) in a == b })

        // The two-square pattern: one toggle inside the scope, one outside.
        StateProvenance.pushAnimation(.linear(duration: 1))
        animated.value = true
        StateProvenance.popAnimation()
        unrelated.value = true

        // Simulate two modifiers each reading their own slot, capture-at-entry per modifier.
        _ = unrelated.value
        XCTAssertNil(StateProvenance.captureLastReadAndClear(), "unanimated slot must capture nil (snap)")
        _ = animated.value
        XCTAssertNotNil(StateProvenance.captureLastReadAndClear(), "animated slot must capture its scope's animation")
    }

    func testFirstStampedReadWinsAcrossMultipleArguments() {
        let first = BridgedStateBox(0.0, comparator: { (a: Double, b: Double) in a == b })
        let second = BridgedStateBox(0.0, comparator: { (a: Double, b: Double) in a == b })
        StateProvenance.pushAnimation(.linear(duration: 1))
        first.value = 1.0
        StateProvenance.popAnimation()
        StateProvenance.pushAnimation(.bouncy)
        second.value = 1.0
        StateProvenance.popAnimation()

        // Both read within one modifier's arguments: the first stamped read wins, one
        // animation drives the whole modifier (one Compose Animatable per modifier).
        _ = first.value
        _ = second.value
        XCTAssertNotNil(StateProvenance.captureLastReadAndClear())
        XCTAssertNil(StateProvenance.captureLastReadAndClear())
    }
}
#endif

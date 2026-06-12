// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import XCTest
import SkipBridge
import SkipAndroidBridge
import SkipSwiftUISamples

#if SKIP
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertTextEquals
import androidx.compose.ui.test.assertWidthIsEqualTo
import androidx.compose.ui.test.assertWidthIsAtLeast
import androidx.compose.ui.test.getUnclippedBoundsInRoot
import androidx.compose.ui.test.performClick
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.width
#endif

/// Compose UI tests for the native (Skip Fuse) SkipSwiftUI module.
///
/// The module under test is compiled native Swift, but this test target is transpiled, so it
/// runs as Kotlin/JUnit with the Compose test rule available. Each test constructs the
/// generated bridged facade of a sample view from `SkipSwiftUISamples`, renders it via
/// `createComposeRule`, and drives it through Compose semantics — exercising the complete
/// native loop: bridged body evaluation, native `@State` storage, `withAnimation` provenance
/// priming, and the SkipUI Compose rendering of the bridged tree.
final class FuseComposeUITests: XCTestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createComposeRule()

    /// Whether bridged main-actor calls can run on this host (see `prepareJVMHostedTesting`).
    var mainActorRelaxed = true

    override func setUp() {
        #if SKIP
        // Replicate the Fuse app bootstrap that Main.kt performs at launch, and like the
        // app entry point it mirrors, run it all on the UI thread: loading the native
        // library there lets libdispatch detect the Android main thread when it
        // initializes, and the bridge bootstrap integrates the dispatch main queue with
        // the main looper — together making the main-actor assumptions of bridged calls
        // during composition hold on-device.
        composeRule.runOnUiThread {
            try! loadPeerLibrary(packageName: "skip-fuse-ui", moduleName: "SkipSwiftUISamples")
            let context = ProcessInfo.processInfo.androidContext
            try! AndroidBridgeBootstrap.initAndroidBridge(filesDir: context.getFilesDir().getAbsolutePath(), cacheDir: context.getCacheDir().getAbsolutePath())
        }
        // Under Robolectric the JVM test thread is never the platform main queue, so bridged
        // main-actor calls need the runtime's checkIsolated hook relaxed before the first
        // bridged view is constructed.
        mainActorRelaxed = SkipSwiftUITestSupport.prepareJVMHostedTesting()
        #endif
    }

    /// Skip (rather than crash) on host Swift runtimes where bridged main-actor calls
    /// cannot be relaxed.
    private func requireBridgedMainActor() throws {
        if !mainActorRelaxed {
            throw XCTSkip("host Swift runtime lacks swift_task_checkIsolated_hook; bridged main-actor calls would trap")
        }
    }

    /// Smoke test: a bridged native view renders into the Compose tree at all.
    func testNativeViewRenders() throws {
        #if !SKIP
        throw XCTSkip("Compose UI testing is Android-only")
        #else
        try requireBridgedMainActor()
        composeRule.setContent {
            LabelTestFixture().Compose()
        }
        composeRule.onNodeWithTag("native-label").assertIsDisplayed()
        #endif
    }

    /// State-driven text updates through the bridge: each click increments native `@State`
    /// and the recomposed label must reflect the new value.
    func testCounterIncrements() throws {
        #if !SKIP
        throw XCTSkip("Compose UI testing is Android-only")
        #else
        try requireBridgedMainActor()
        composeRule.setContent {
            CounterTestFixture().Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("counter-label").assertTextEquals("count: 0")

        composeRule.onNodeWithTag("increment-button").performClick()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("counter-label").assertTextEquals("count: 1")

        composeRule.onNodeWithTag("increment-button").performClick()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("counter-label").assertTextEquals("count: 2")
        #endif
    }

    /// Structural recomposition through the bridge: toggling native `@State` must insert
    /// and remove a node from the Compose tree, not just update values.
    func testConditionalContentTogglesExistence() throws {
        #if !SKIP
        throw XCTSkip("Compose UI testing is Android-only")
        #else
        try requireBridgedMainActor()
        composeRule.setContent {
            ConditionalContentTestFixture().Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("conditional-label").assertDoesNotExist()

        composeRule.onNodeWithTag("toggle-button").performClick()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("conditional-label").assertIsDisplayed()

        composeRule.onNodeWithTag("toggle-button").performClick()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("conditional-label").assertDoesNotExist()
        #endif
    }

    /// The two-square invariant, end-to-end through the bridge: clicking the button toggles
    /// `animated` inside `withAnimation(.linear(duration: 1))` and `unrelated` outside it.
    /// The unrelated rect must snap to its target immediately while the animated rect
    /// interpolates across the stepped test clock.
    func testWithAnimationAnimatesWhileUnrelatedSnaps() throws {
        #if !SKIP
        throw XCTSkip("Compose UI testing is Android-only")
        #else
        try requireBridgedMainActor()
        composeRule.mainClock.autoAdvance = false
        composeRule.setContent {
            AnimatedSquaresTestFixture().Compose()
        }
        composeRule.mainClock.advanceTimeByFrame()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("animated-rect").assertWidthIsEqualTo(100.0.dp)
        composeRule.onNodeWithTag("unrelated-rect").assertWidthIsEqualTo(100.0.dp)

        // Click runs the native action through the bridge: withAnimation { animated } and a
        // plain unrelated toggle in the same handler. A few paused-clock frames are needed
        // for tap dispatch plus the resulting recomposition.
        composeRule.onNodeWithTag("animate-button").performClick()
        composeRule.mainClock.advanceTimeBy(48)
        composeRule.waitForIdle()

        // The unrelated rect snapped to its target as soon as the click recomposed...
        composeRule.onNodeWithTag("unrelated-rect").assertWidthIsEqualTo(300.0.dp)
        // ...while the animated rect has barely left its starting width.
        let animatedStartWidth = composeRule.onNodeWithTag("animated-rect").getUnclippedBoundsInRoot().width.value
        XCTAssertLessThan(Double(animatedStartWidth), 200.0, "animated rect should interpolate, not snap")

        // The animated rect is interpolating: past the start a quarter into the 1s ramp...
        composeRule.mainClock.advanceTimeBy(250)
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("animated-rect").assertWidthIsAtLeast(110.0.dp)

        // ...further along at the half...
        composeRule.mainClock.advanceTimeBy(250)
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("animated-rect").assertWidthIsAtLeast(150.0.dp)

        // ...and at the target once the duration elapses.
        composeRule.mainClock.advanceTimeBy(700)
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("animated-rect").assertWidthIsEqualTo(300.0.dp)
        #endif
    }

    /// The two-square invariant for `@Observable` reference objects in Fuse: a property
    /// mutated inside `withAnimation` must interpolate while a sibling property mutated
    /// outside it in the same handler must snap.
    func testObservablePropertyAnimatesWhileUnrelatedSnaps() throws {
        #if !SKIP
        throw XCTSkip("Compose UI testing is Android-only")
        #else
        try requireBridgedMainActor()
        composeRule.mainClock.autoAdvance = false
        composeRule.setContent {
            ObservableSquaresTestFixture().Compose()
        }
        composeRule.mainClock.advanceTimeByFrame()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("obs-animated-rect").assertWidthIsEqualTo(100.0.dp)
        composeRule.onNodeWithTag("obs-unrelated-rect").assertWidthIsEqualTo(100.0.dp)

        composeRule.onNodeWithTag("obs-animate-button").performClick()
        composeRule.mainClock.advanceTimeBy(48)
        composeRule.waitForIdle()

        // Sample mid-flight at ~300ms of the 1s linear ramp: the animated property must have
        // left the start but not reached the target, while the un-animated property must
        // already be at its target (snapped, not animating).
        composeRule.mainClock.advanceTimeBy(250)
        composeRule.waitForIdle()
        let animatedMid = composeRule.onNodeWithTag("obs-animated-rect").getUnclippedBoundsInRoot().width.value
        XCTAssertGreaterThan(Double(animatedMid), 105.0, "animated property should have started interpolating")
        XCTAssertLessThan(Double(animatedMid), 290.0, "animated property should not have snapped to the target")
        composeRule.onNodeWithTag("obs-unrelated-rect").assertWidthIsEqualTo(300.0.dp)

        composeRule.mainClock.advanceTimeBy(900)
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("obs-animated-rect").assertWidthIsEqualTo(300.0.dp)
        #endif
    }

    /// Same invariant when the observable is handed to the reading child through the SwiftUI
    /// environment instead of an initializer parameter.
    func testEnvironmentObservablePropertyAnimatesWhileUnrelatedSnaps() throws {
        #if !SKIP
        throw XCTSkip("Compose UI testing is Android-only")
        #else
        try requireBridgedMainActor()
        composeRule.mainClock.autoAdvance = false
        composeRule.setContent {
            ObservableEnvironmentSquaresTestFixture().Compose()
        }
        composeRule.mainClock.advanceTimeByFrame()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("obs-env-animated-rect").assertWidthIsEqualTo(100.0.dp)
        composeRule.onNodeWithTag("obs-env-unrelated-rect").assertWidthIsEqualTo(100.0.dp)

        composeRule.onNodeWithTag("obs-env-animate-button").performClick()
        composeRule.mainClock.advanceTimeBy(48)
        composeRule.waitForIdle()

        // Sample mid-flight at ~300ms of the 1s linear ramp: the animated property must have
        // left the start but not reached the target, while the un-animated property must
        // already be at its target (snapped, not animating).
        composeRule.mainClock.advanceTimeBy(250)
        composeRule.waitForIdle()
        let animatedMid = composeRule.onNodeWithTag("obs-env-animated-rect").getUnclippedBoundsInRoot().width.value
        XCTAssertGreaterThan(Double(animatedMid), 105.0, "animated property should have started interpolating")
        XCTAssertLessThan(Double(animatedMid), 290.0, "animated property should not have snapped to the target")
        composeRule.onNodeWithTag("obs-env-unrelated-rect").assertWidthIsEqualTo(300.0.dp)

        composeRule.mainClock.advanceTimeBy(900)
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("obs-env-animated-rect").assertWidthIsEqualTo(300.0.dp)
        #endif
    }

    /// A plain toggle with no withAnimation must land at the target without interpolation.
    func testPlainToggleSnaps() throws {
        #if !SKIP
        throw XCTSkip("Compose UI testing is Android-only")
        #else
        try requireBridgedMainActor()
        composeRule.setContent {
            AnimatedSquaresTestFixture().Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("animated-rect").assertWidthIsEqualTo(100.0.dp)

        composeRule.onNodeWithTag("snap-button").performClick()
        composeRule.waitForIdle()
        composeRule.onNodeWithTag("animated-rect").assertWidthIsEqualTo(300.0.dp)
        #endif
    }
}

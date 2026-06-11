// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import XCTest
import SkipBridge
import SkipAndroidBridge
import SkipSwiftUI

#if SKIP
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.assertIsDisplayed
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
/// generated bridged facade of a fixture view from `SkipSwiftUI` itself (see `TestFixtures.swift`), renders it via
/// `createComposeRule`, and drives it through Compose semantics — exercising the complete
/// native loop: bridged body evaluation, native `@State` storage, `withAnimation` provenance
/// priming, and the SkipUI Compose rendering of the bridged tree.
final class FuseComposeUITests: XCTestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createComposeRule()

    override func setUp() {
        #if SKIP
        // Replicate the Fuse app bootstrap that Main.kt performs at launch, and like the
        // app entry point it mirrors, run it all on the UI thread: loading the native
        // library there lets libdispatch detect the Android main thread when it
        // initializes, and the bridge bootstrap integrates the dispatch main queue with
        // the main looper — together making the main-actor assumptions of bridged calls
        // during composition hold on-device.
        composeRule.runOnUiThread {
            try! loadPeerLibrary(packageName: "skip-fuse-ui", moduleName: "SkipSwiftUI")
            let context = ProcessInfo.processInfo.androidContext
            try! AndroidBridgeBootstrap.initAndroidBridge(filesDir: context.getFilesDir().getAbsolutePath(), cacheDir: context.getCacheDir().getAbsolutePath())
        }
        #endif
    }

    /// Smoke test: a bridged native view renders into the Compose tree at all.
    func testNativeViewRenders() throws {
        #if !SKIP
        throw XCTSkip("Compose UI testing is Android-only")
        #else
        composeRule.setContent {
            LabelTestFixture().Compose()
        }
        composeRule.onNodeWithTag("native-label").assertIsDisplayed()
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

    /// A plain toggle with no withAnimation must land at the target without interpolation.
    func testPlainToggleSnaps() throws {
        #if !SKIP
        throw XCTSkip("Compose UI testing is Android-only")
        #else
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

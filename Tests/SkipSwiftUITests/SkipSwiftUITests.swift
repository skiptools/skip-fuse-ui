// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest

#if SKIP
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import org.junit.Rule
import SkipBridge
#endif

@testable import SkipSwiftUI
import SkipSwiftUITestSupport

final class SkipSwiftUITests: XCTestCase {
    func testSkipUI() throws {
        XCTAssertEqual(3, 1 + 2)
    }
}

final class ObservationMountRuntimeTests: SkipUITestCase {
    // SKIP INSERT: @get:Rule val composeRule = createComposeRule()

    override func setUp() {
        super.setUp()
        #if SKIP
        loadPeerLibrary(packageName: "skip-fuse-ui", moduleName: "SkipSwiftUITestSupport")
        #endif
    }

    func testMountedViewInvalidatesWhenObservablePropertyChanges() throws {
        #if SKIP
        let probe = ObservationProbeMount()

        composeRule.setContent {
            Text(probe.renderedText()).Compose()
        }
        composeRule.waitForIdle()
        composeRule.onNodeWithText("count: 0").assertIsDisplayed()

        probe.setCount(1)
        composeRule.waitForIdle()

        composeRule.onNodeWithText("count: 1").assertIsDisplayed()
        #else
        throw XCTSkip("Runs only in the transpiled Skip Compose test runtime.")
        #endif
    }
}

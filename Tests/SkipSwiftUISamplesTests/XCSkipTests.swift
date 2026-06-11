// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import XCTest

#if os(macOS)
import SkipTest

/// This test case will run the transpiled tests for the Skip module.
@available(macOS 13, macCatalyst 16, *)
final class XCSkipTests: XCTestCase, XCGradleHarness {
    public func testSkipModule() async throws {
        // set device ID to run in Android emulator vs. robolectric
        try await runGradleTests()
    }
}
#endif

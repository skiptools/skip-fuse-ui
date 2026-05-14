// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
#if !SKIP
@testable import SkipSwiftUI
#endif

final class SkipSwiftUITests: XCTestCase {
    func testSkipUI() throws {
        XCTAssertEqual(3, 1 + 2)
    }
}

// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import XCTest
#if !SKIP
@testable import SkipSwiftUI
#endif

final class SkipSwiftUITests: XCTestCase {
    func testSkipUI() throws {
        XCTAssertEqual(3, 1 + 2)
    }
}

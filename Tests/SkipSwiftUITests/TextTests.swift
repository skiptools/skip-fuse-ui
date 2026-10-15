// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
#if !SKIP
@testable import SkipSwiftUI
#endif

final class TextTests: XCTestCase {
    #if !SKIP
    /// SwiftUI documents `Text.init<S>(_:)` as displaying "a stored string without
    /// localization", so an already-resolved string must not be looked up again (#135).
    func testStringProtocolInitIsVerbatim() throws {
        let resolved = "Welcome"
        let text = Text(resolved)
        XCTAssertEqual(text.spec.verbatim, "Welcome")
        XCTAssertNil(text.spec.key)
        XCTAssertEqual(text, Text(verbatim: resolved))
    }

    /// A `Substring` binds to the same overload and must not be localized either.
    func testSubstringInitIsVerbatim() throws {
        let resolved = "Welcome!".dropLast()
        XCTAssertEqual(Text(resolved).spec.verbatim, "Welcome")
    }

    /// A string literal still binds to the `LocalizedStringKey` overload and stays localized.
    func testStringLiteralInitRemainsLocalized() throws {
        let text = Text("Welcome")
        XCTAssertEqual(text.spec.key, LocalizedStringKey("Welcome"))
        XCTAssertNil(text.spec.verbatim)
    }
    #endif
}

// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest

#if !SKIP
import Foundation
@testable import SkipSwiftUI
@testable import SkipUI

/// The text binding a `TextField(value:format:)` hands SkipUI, which writes each edit through it.
final class TextFieldBridgingTests: XCTestCase {
    private func bridgedText(_ field: SkipSwiftUI.TextField<SkipSwiftUI.Text>) throws -> SkipUI.Binding<String> {
        return try XCTUnwrap(field.Java_view as? SkipUI.TextField).text
    }

    /// Text that parses reaches the value even when it formats like the current value.
    func testLossyFormatWritesEveryParsedValue() throws {
        var value = 1.1
        let binding = SkipSwiftUI.Binding(get: { value }, set: { value = $0 })
        let format = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(0)).locale(Locale(identifier: "en_US"))
        let text = try bridgedText(SkipSwiftUI.TextField("Amount", value: binding, format: format))
        XCTAssertEqual(text.get(), "1")

        text.set("1.2")
        XCTAssertEqual(value, 1.2)
        XCTAssertEqual(text.get(), "1")
    }

    /// Text that does not parse keeps the last value, and text that parses replaces it.
    func testUnparseableTextKeepsValue() throws {
        var value = 7
        let binding = SkipSwiftUI.Binding(get: { value }, set: { value = $0 })
        let format = IntegerFormatStyle<Int>.number.locale(Locale(identifier: "en_US"))
        let text = try bridgedText(SkipSwiftUI.TextField("Dose", value: binding, format: format))

        text.set("")
        XCTAssertEqual(value, 7)
        text.set("-")
        XCTAssertEqual(value, 7)
        text.set("12")
        XCTAssertEqual(value, 12)
    }
}
#endif

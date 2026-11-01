// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SwiftUI
import SkipSwiftUI
import Testing

@Suite("Foundation with SwiftUI")
struct SwiftUIImportTests {
    @Test("UI scalar and ordinary attributes remain unambiguous")
    func ordinaryAttributes() {
        let size: CGFloat = 13
        let qualifiedSize: SwiftUI.CGFloat = size
        var text = AttributedString("HD")
        text.font = .system(size: qualifiedSize)
        text.foregroundColor = .red
        text.baselineOffset = size * 4 / 13
        text.underlineStyle = .single
        text.strikethroughStyle = .single

        #expect(text.swiftUI.font == .system(size: size))
        #expect(text.swiftUI.foregroundColor == .red)
        #expect(text.swiftUI.baselineOffset == 4)
        #expect(text.swiftUI.underlineStyle == .single)
        #expect(text.swiftUI.strikethroughStyle == .single)
        #if os(Android)
        // The facade must expose the scalar accepted by Skip's UI APIs.
        let nativeSize: Double = qualifiedSize
        #expect(nativeSize == 13)
        #endif
    }

    @Test("Explicit Skip scope remains available with Apple SwiftUI")
    func explicitSkipScope() {
        var text = AttributedString("HD")
        text.skipUI.foregroundColor = .red
        text.skipUI.baselineOffset = 4
        #expect(text.skipUI.foregroundColor == .red)
        #expect(text.skipUI.baselineOffset == 4)
    }
}

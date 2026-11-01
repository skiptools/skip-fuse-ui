// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SkipFuse
import SkipSwiftUI

/// Exercises native parsing, range editing, value semantics, and link dispatch.
public struct AttributedTextTestFixture: View {
    @State var opened = "none"
    @State var changed = false

    public init() {}

    private var styled: AttributedString {
        var text = AttributedString("Font Color Both 👩🏽‍💻")
        if let range = text.range(of: "Font") { text[range].font = SkipSwiftUI.Font.title2.bold().italic() }
        if let range = text.range(of: "Color") { text[range].foregroundColor = changed ? SkipSwiftUI.Color.green : SkipSwiftUI.Color.red }
        if let range = text.range(of: "Both") {
            text[range].underlineStyle = SkipSwiftUI.Text.LineStyle.single
            text[range].strikethroughStyle = SkipSwiftUI.Text.LineStyle.single
        }
        if let range = text.range(of: "👩🏽‍💻") { text[range].foregroundColor = SkipSwiftUI.Color.blue }
        return text
    }

    private var baselineText: AttributedString {
        var text = AttributedString("H H H H")
        let green = text.index(text.startIndex, offsetByCharacters: 2)
        let red = text.index(text.startIndex, offsetByCharacters: 4)
        let blue = text.index(text.startIndex, offsetByCharacters: 6)
        text[green..<text.endIndex].font = SkipSwiftUI.Font.system(size: 14)
        text[green..<red].foregroundColor = SkipSwiftUI.Color(red: 0, green: 1, blue: 0)
        text[red..<blue].foregroundColor = SkipSwiftUI.Color(red: 1, green: 0, blue: 0)
        text[blue..<text.endIndex].foregroundColor = SkipSwiftUI.Color(red: 0, green: 0, blue: 1)
        text[red..<blue].skipUI.baselineOffset = changed ? 0 : 6
        text[blue..<text.endIndex].skipUI.baselineOffset = changed ? 0 : -6
        return text
    }

    public var body: some View {
        VStack {
            Text(styled).accessibilityIdentifier("attributed-styles")
            Text(baselineText).font(.system(size: 28)).accessibilityIdentifier("attributed-baselines")
            Text(baselineText).font(.system(size: 42)).accessibilityIdentifier("attributed-baselines-large")
            Text(baselineText).font(.system(size: 28, design: .serif)).accessibilityIdentifier("attributed-baselines-serif")
            Text(try! AttributedString(markdown: "**bold** *italic* `code` ~~gone~~", options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                .accessibilityIdentifier("attributed-markdown")
            Text(link).accessibilityIdentifier("attributed-link")
            Text(opened).accessibilityIdentifier("attributed-opened")
            Button("Change color") { changed.toggle() }.accessibilityIdentifier("attributed-change")
        }
        .environment(\.openURL, OpenURLAction { url in
            opened = url.absoluteString
            return .handled
        })
    }

    private var link: AttributedString {
        var text = AttributedString("Open link")
        text.link = URL(string: "https://example.com/edited")
        return text
    }

    /// Return a specific failure to the transpiled test, while all mutations run in native Swift.
    public static func validationFailure() -> String? {
        let source = "  [**👩🏽‍💻 cafe\u{301}**](https://example.com)  \n\n\nend  "
        guard var value = try? AttributedString(markdown: source, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)) else { return "parse failed" }
        guard String(value.characters) == "  👩🏽‍💻 cafe\u{301}  \n\n\nend  " else { return "whitespace changed: \(String(value.characters).debugDescription)" }
        let original = value
        let links = value.runs.filter { $0.link != nil }.map { $0.range }
        guard links.count == 1 else { return "expected one link run" }
        for range in links {
            value[range].underlineStyle = SkipSwiftUI.Text.LineStyle.single
            value[range].link = URL(string: "https://example.com/edited")
        }
        guard original.runs.first(where: { $0.link != nil })?.link?.absoluteString == "https://example.com" else { return "copy was mutated" }
        guard let edited = value.runs.first(where: { $0.link != nil }), edited.inlinePresentationIntent?.contains(.stronglyEmphasized) == true else { return "bold lost after editing" }
        guard edited[AttributeScopes.SkipUIAttributes.UnderlineStyleAttribute.self] != nil else { return "underline missing" }
        guard edited.link?.absoluteString == "https://example.com/edited" else { return "link edit lost" }
        guard Text(value) != Text(original) else { return "Text equality ignores attributes" }
        return nil
    }
}

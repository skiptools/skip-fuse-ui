// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SkipUI

extension AttributeScopes {
    /// Text attributes understood by Skip's native SwiftUI implementation.
    public var skipUI: SkipUIAttributes.Type { SkipUIAttributes.self }
    #if os(Android)
    /// The SwiftUI spelling of the supported text attribute scope on Android.
    public var swiftUI: SkipUIAttributes.Type { SkipUIAttributes.self }
    /// Matches the SwiftUI scope name on Android.
    public typealias SwiftUIAttributes = SkipUIAttributes
    #endif

    /// Attributes rendered by native `Text(AttributedString)`.
    public struct SkipUIAttributes: AttributeScope {
        /// The font for this range.
        public let font: FontAttribute
        /// The foreground color for this range.
        public let foregroundColor: ForegroundColorAttribute
        /// A single solid underline for this range.
        public let underlineStyle: UnderlineStyleAttribute
        /// A single solid strikethrough for this range.
        public let strikethroughStyle: StrikethroughStyleAttribute
        /// The distance in points to raise a range. Negative values lower it.
        public let baselineOffset: BaselineOffsetAttribute
        /// Foundation attributes, including link destinations.
        public let foundation: FoundationAttributes
        #if os(Android)
        /// Inline Markdown formatting on Android.
        public let inlinePresentationIntent: InlinePresentationIntentAttribute
        #endif

        /// The font attribute rendered by Text.
        public enum FontAttribute: AttributedStringKey {
            /// The attribute value.
            public typealias Value = Font
            /// The Foundation attribute name.
            public static let name = "SwiftUI.Font"
        }
        /// The foreground color attribute rendered by Text.
        public enum ForegroundColorAttribute: AttributedStringKey {
            /// The attribute value.
            public typealias Value = Color
            /// The Foundation attribute name.
            public static let name = "SwiftUI.ForegroundColor"
        }
        /// The underline attribute rendered by Text.
        public enum UnderlineStyleAttribute: AttributedStringKey {
            /// The attribute value.
            public typealias Value = Text.LineStyle
            /// The Foundation attribute name.
            public static let name = "SwiftUI.UnderlineStyle"
        }
        /// The strikethrough attribute rendered by Text.
        public enum StrikethroughStyleAttribute: AttributedStringKey {
            /// The attribute value.
            public typealias Value = Text.LineStyle
            /// The Foundation attribute name.
            public static let name = "SwiftUI.StrikethroughStyle"
        }
        /// The baseline offset attribute rendered by Text.
        public enum BaselineOffsetAttribute: AttributedStringKey {
            /// The offset in points, independent of the range's font size.
            public typealias Value = CGFloat
            /// The Foundation attribute name.
            public static let name = "SwiftUI.BaselineOffset"
        }
        #if os(Android)
        /// The inline presentation intent attribute supplied by the Android parser.
        public enum InlinePresentationIntentAttribute: AttributedStringKey {
            /// The attribute value.
            public typealias Value = InlinePresentationIntent
            /// The Foundation attribute name.
            public static let name = "NSInlinePresentationIntent"
        }
        #endif
    }
}

extension AttributeDynamicLookup {
    /// Enable `text[range].font`, `.foregroundColor`, and text decorations.
    /// Prefer Apple's scope when both UI implementations are imported.
    @_disfavoredOverload
    public subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<AttributeScopes.SkipUIAttributes, T>) -> T {
        self[T.self]
    }
}

#if os(Android)
/// Inline Markdown styles supported by the Android text renderer.
public struct InlinePresentationIntent: OptionSet, Sendable, Hashable {
    /// The inline style bitmask.
    public let rawValue: UInt
    /// Create a set of inline styles.
    public init(rawValue: UInt) { self.rawValue = rawValue }
    /// Italic emphasis.
    public static let emphasized = Self(rawValue: 1 << 0)
    /// Bold emphasis.
    public static let stronglyEmphasized = Self(rawValue: 1 << 1)
    /// Inline monospaced code.
    public static let code = Self(rawValue: 1 << 2)
    /// Strikethrough text.
    public static let strikethrough = Self(rawValue: 1 << 5)
}

extension AttributedString {
    /// Options for Skip's inline Markdown parser. Block formatting is not supported.
    /// Unlike Apple Foundation's `.full` default, Android defaults to
    /// `.inlineOnlyPreservingWhitespace`, which is its only supported mode.
    public struct MarkdownParsingOptions: Sendable {
        /// The supported Markdown interpretation mode.
        public enum InterpretedSyntax: Sendable {
            /// Parse inline styles while retaining whitespace and blank lines.
            case inlineOnlyPreservingWhitespace
        }
        /// The selected interpretation mode.
        public var interpretedSyntax: InterpretedSyntax
        /// Configure inline parsing.
        public init(interpretedSyntax: InterpretedSyntax = .inlineOnlyPreservingWhitespace) {
            self.interpretedSyntax = interpretedSyntax
        }
    }

    /// Create editable inline Markdown using the CommonMark engine included by SkipFoundation.
    /// Pass `.inlineOnlyPreservingWhitespace` explicitly in shared iOS/Android code.
    /// The `baseURL:`, `including:`, data, and file URL overloads are not provided.
    /// This initializer currently reports no parse errors; `throws` preserves the
    /// call shape used by Apple Foundation.
    public init(markdown: String, options: MarkdownParsingOptions = .init()) throws {
        self = Self.fromMarkdownRuns(SkipUI.AttributedTextRun.markdownRuns(markdown))
    }
}
#endif

extension AttributedString {
    /// Assemble native indices from segment text, avoiding UTF-16 offset conversion.
    static func fromMarkdownRuns(_ runs: [SkipUI.AttributedTextRun]) -> AttributedString {
        var result = AttributedString()
        for run in runs {
            var segment = AttributedString(run.text)
            var intent: InlinePresentationIntent = []
            if run.bold { intent.insert(.stronglyEmphasized) }
            if run.italic { intent.insert(.emphasized) }
            if run.code { intent.insert(.code) }
            if run.strikethrough { intent.insert(.strikethrough) }
            if !intent.isEmpty { segment.inlinePresentationIntent = intent }
            if let link = run.link { segment.link = URL(string: link) }
            result.append(segment)
        }
        return result
    }

    /// Convert the edited value at the native UI boundary; unknown attributes stay in
    /// the source value and have no rendering effect.
    var attributedTextRuns: [SkipUI.AttributedTextRun] {
        runs.map { run in
            let intent = run.inlinePresentationIntent ?? []
            return SkipUI.AttributedTextRun(
                text: String(self[run.range].characters),
                bold: intent.contains(.stronglyEmphasized),
                italic: intent.contains(.emphasized),
                code: intent.contains(.code),
                strikethrough: intent.contains(.strikethrough) || run[AttributeScopes.SkipUIAttributes.StrikethroughStyleAttribute.self] != nil,
                underline: run[AttributeScopes.SkipUIAttributes.UnderlineStyleAttribute.self] != nil,
                link: run.link?.absoluteString,
                font: run[AttributeScopes.SkipUIAttributes.FontAttribute.self]?.spec.Java_font,
                color: run[AttributeScopes.SkipUIAttributes.ForegroundColorAttribute.self].map { Color.Java_color(for: $0.spec) },
                baselineOffset: Double(run[AttributeScopes.SkipUIAttributes.BaselineOffsetAttribute.self] ?? 0)
            )
        }
    }
}

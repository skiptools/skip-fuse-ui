// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import Foundation
import SkipFuse
import SkipUI

/* @frozen */ public struct Text : Equatable, Sendable {
    let spec: TextSpec
    var modifierChain: [@Sendable (any View) -> any View] = []

    init(spec: TextSpec) {
        self.spec = spec
    }

    /* @inlinable */ public init(verbatim content: String) {
        self.init(spec: TextSpec(verbatim: content))
    }

    @_disfavoredOverload public init<S>(_ content: S) where S : StringProtocol {
        self.init(spec: TextSpec(key: LocalizedStringKey(String(content))))
    }

    public static func == (lhs: Text, rhs: Text) -> Bool {
        return lhs.spec == rhs.spec
    }
}

/// Define text content.
struct TextSpec : Equatable, @unchecked Sendable {
    var verbatim: String?
    var key: LocalizedStringKey?
    var resource: AndroidLocalizedStringResource?
    var tableName: String?
    var bundle: Bundle?
}

extension Text : View {
    public typealias Body = Never
}

extension Text : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        guard modifierChain.isEmpty else {
            var view: any View = Text(spec: self.spec) // No modifiers
            for modifier in modifierChain {
                view = modifier(view)
            }
            return view.Java_viewOrEmpty
        }

        if let verbatim = spec.verbatim {
            return SkipUI.Text(verbatim: verbatim)
        } else if let key = spec.key {
            let values = key.interpolation.values.isEmpty ? nil : key.interpolation.values
            return SkipUI.Text(keyPattern: key.interpolation.pattern, keyValues: values, tableName: spec.tableName, localeIdentifier: nil, bridgedBundle: spec.bundle)
        } else if let resource = spec.resource {
            let values = resource.defaultValue.values.isEmpty ? nil : resource.defaultValue.values
            let locale = resource.isDefaultLocale ? nil : resource.locale
            let bundle: Bundle?
            if resource.isDefaultBundle {
                bundle = nil
            } else {
                switch resource.bundle {
                case .main:
                    bundle = AndroidBundle.main
                case .atURL(let url):
                    bundle = AndroidBundle(url: url)
                }
            }
            return SkipUI.Text(keyPattern: resource.key, keyValues: values, tableName: resource.table, localeIdentifier: locale?.identifier, bridgedBundle: bundle)
        } else {
            return SkipUI.Text(verbatim: "")
        }
    }
}

extension Text {
    @available(*, unavailable)
    public func textVariant/* <V> */(_ preference: Any /* V */) -> some View /* where V : TextVariantPreference */ {
        stubView()
    }
}

extension Text {
    public init(_ key: LocalizedStringKey, tableName: String? = nil, bundle: Bundle? = nil, comment: StaticString? = nil) {
        self.init(spec: TextSpec(key: key, tableName: tableName, bundle: bundle))
    }

    @_disfavoredOverload public init(_ resource: AndroidLocalizedStringResource) {
        self.init(spec: TextSpec(resource: resource))
    }
}

extension Text {
    public struct LineStyle : Hashable, Sendable {
        public init(pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) {
        }

        public struct Pattern : Sendable {
            public static let solid = Text.LineStyle.Pattern()
            public static let dot = Text.LineStyle.Pattern()
            public static let dash = Text.LineStyle.Pattern()
            public static let dashDot = Text.LineStyle.Pattern()
            public static let dashDotDot = Text.LineStyle.Pattern()
        }

        public static let single = Text.LineStyle()
    }
}

extension Text {
    public init<Subject>(_ subject: Subject, formatter: Formatter) where Subject : AnyObject /* ReferenceConvertible // Causes a compiler crash in LocalizedStringKey */ {
        var interpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 0)
        interpolation.appendInterpolation(subject, formatter: formatter)
        self.init(LocalizedStringKey(stringInterpolation: interpolation))
    }

    public init<Subject>(_ subject: Subject, formatter: Formatter) where Subject : NSObject {
        var interpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 0)
        interpolation.appendInterpolation(subject, formatter: formatter)
        self.init(LocalizedStringKey(stringInterpolation: interpolation))
    }
}

extension Text {
    public init<F>(_ input: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String {
        var interpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 0)
        interpolation.appendInterpolation(input, format: format)
        self.init(LocalizedStringKey(stringInterpolation: interpolation))
    }
}

extension Text {
    @available(*, unavailable)
    public init<F>(_ input: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == AttributedString {
        fatalError()
    }
}

extension Text {
    @available(*, unavailable)
    public init(_ image: Image) {
        fatalError()
    }
}

extension Text {
    public struct DateStyle : Equatable, Sendable {
        public static let time: DateStyle = {
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            return DateStyle(identifier: 1) {
                return formatter.string(from: $0)
            }
        }()

        public static let date: DateStyle = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return DateStyle(identifier: 2) {
                return formatter.string(from: $0)
            }
        }()

        @available(*, unavailable)
        public static var relative: DateStyle {
            fatalError()
        }

        @available(*, unavailable)
        public static var offset: DateStyle {
            fatalError()
        }

        @available(*, unavailable)
        public static var timer: DateStyle {
            fatalError()
        }

        private let identifier: Int
        let format: @Sendable (Date) -> String

        private init(identifier: Int, format: @escaping @Sendable (Date) -> String) {
            self.identifier = identifier
            self.format = format
        }

        public static func == (lhs: DateStyle, rhs: DateStyle) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }

    public init(_ date: Date, style: Text.DateStyle) {
        self.init(verbatim: style.format(date))
    }

    public init(_ dates: ClosedRange<Date>) {
        let formatter = DateIntervalFormatter()
        self.init(verbatim: formatter.string(from: dates.lowerBound, to: dates.upperBound))
    }

    public init(_ interval: DateInterval) {
        let formatter = DateIntervalFormatter()
        self.init(verbatim: formatter.string(from: interval.start, to: interval.end))
    }
}

//extension Text.DateStyle : Codable {
//    public func encode(to encoder: any Encoder) throws
//
//    public init(from decoder: any Decoder) throws
//}

extension Text {
    @available(*, unavailable)
    public init(timerInterval: ClosedRange<Date>, pauseTime: Date? = nil, countsDown: Bool = true, showsHours: Bool = true) {
        fatalError()
    }
}

extension Text {
    @available(*, unavailable)
    public init(_ attributedContent: AttributedString) {
        fatalError()
    }
}

extension Text {
    @available(*, unavailable)
    public static func + (lhs: Text, rhs: Text) -> Text {
        fatalError()
    }
}

extension Text {
    public enum TruncationMode : Hashable, Sendable {
        case head
        case tail
        case middle
    }

    public enum Case : Int, Hashable, Sendable {
        case uppercase = 0 // For bridging
        case lowercase = 1 // For bridging
    }
}

extension Text {
    @available(*, unavailable)
    public func typesettingLanguage(_ language: Any /* Locale.Language */, isEnabled: Bool = true) -> Text {
        fatalError()
    }

//    public func typesettingLanguage(_ language: TypesettingLanguage, isEnabled: Bool = true) -> Text
}

extension Text {
    @available(*, unavailable)
    public func customAttribute/* <T> */(_ value: Any /* T */) -> Text /* where T : TextAttribute */ {
        fatalError()
    }
}

extension Text {
    nonisolated public func foregroundColor(_ color: Color?) -> Text {
        var text = self
        text.modifierChain.append {
            $0.foregroundColor(color)
        }
        return text
    }

    nonisolated public func foregroundStyle<S>(_ style: S) -> Text where S : ShapeStyle {
        var text = self
        text.modifierChain.append {
            $0.foregroundStyle(style)
        }
        return text
    }

    nonisolated public func font(_ font: Font?) -> Text {
        var text = self
        text.modifierChain.append {
            $0.font(font)
        }
        return text
    }

    nonisolated public func fontWeight(_ weight: Font.Weight?) -> Text {
        var text = self
        text.modifierChain.append {
            $0.fontWeight(weight)
        }
        return text
    }

    @available(*, unavailable)
    nonisolated public func fontWidth(_ width: Font.Width?) -> Text {
        fatalError()
    }

    nonisolated public func bold() -> Text {
        return bold(true)
    }

    nonisolated public func bold(_ isActive: Bool) -> Text {
        var text = self
        text.modifierChain.append {
            $0.bold(isActive)
        }
        return text
    }

    nonisolated public func italic() -> Text {
        return italic(true)
    }

    nonisolated public func italic(_ isActive: Bool) -> Text {
        var text = self
        text.modifierChain.append {
            $0.italic(isActive)
        }
        return text
    }

    nonisolated public func monospaced(_ isActive: Bool = true) -> Text {
        var text = self
        text.modifierChain.append {
            $0.monospaced(isActive)
        }
        return text
    }

    nonisolated public func fontDesign(_ design: Font.Design?) -> Text {
        var text = self
        text.modifierChain.append {
            $0.fontDesign(design)
        }
        return text
    }

    @available(*, unavailable)
    nonisolated public func monospacedDigit() -> Text {
        fatalError()
    }

    nonisolated public func strikethrough(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> Text {
        var text = self
        text.modifierChain.append {
            $0.strikethrough(isActive, pattern: pattern, color: color)
        }
        return text
    }

    nonisolated public func underline(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> Text {
        var text = self
        text.modifierChain.append {
            $0.underline(isActive, pattern: pattern, color: color)
        }
        return text
    }

    @available(*, unavailable)
    nonisolated public func kerning(_ kerning: CGFloat) -> Text {
        fatalError()
    }

    nonisolated public func tracking(_ tracking: CGFloat) -> Text {
        var text = self
        text.modifierChain.append {
            $0.tracking(tracking)
        }
        return text
    }

    @available(*, unavailable)
    nonisolated public func baselineOffset(_ baselineOffset: CGFloat) -> Text {
        fatalError()
    }
}

extension View {
    @_disfavoredOverload nonisolated public func font(_ font: Font?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.font(font?.spec.Java_font)
        }
    }

    @_disfavoredOverload nonisolated public func fontWeight(_ weight: Font.Weight?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.fontWeight(bridgedWeight: weight?.value)
        }
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func fontWidth(_ width: Font.Width?) -> some View {
        stubView()
    }

    @_disfavoredOverload nonisolated public func bold() -> some View {
        return bold(true)
    }

    @_disfavoredOverload nonisolated public func bold(_ isActive: Bool) -> some View {
        return fontWeight(isActive ? Font.Weight.bold : nil)
    }

    @_disfavoredOverload nonisolated public func italic() -> some View {
        return italic(true)
    }

    @_disfavoredOverload nonisolated public func italic(_ isActive: Bool) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.italic(isActive)
        }
    }

    @_disfavoredOverload nonisolated public func monospaced(_ isActive: Bool = true) -> some View {
        return fontDesign(.monospaced)
    }

    @_disfavoredOverload nonisolated public func fontDesign(_ design: Font.Design?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.fontDesign(bridgedDesign: design?.rawValue)
        }
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func monospacedDigit() -> some View {
        stubView()
    }

    @_disfavoredOverload nonisolated public func strikethrough(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.bridgedStrikethrough(isActive)
        }
    }

    @_disfavoredOverload nonisolated public func underline(_ isActive: Bool = true, pattern: Text.LineStyle.Pattern = .solid, color: Color? = nil) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.bridgedUnderline(isActive)
        }
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func kerning(_ kerning: CGFloat) -> some View {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func baselineOffset(_ baselineOffset: CGFloat) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func allowsTightening(_ flag: Bool) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func dynamicTypeSize(_ size: DynamicTypeSize) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func dynamicTypeSize(_ range: Range<DynamicTypeSize>) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func invalidatableContent(_ invalidatable: Bool = true) -> some View {
        stubView()
    }

    nonisolated public func lineLimit(_ number: Int?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.lineLimit(number)
        }
    }

    @available(*, unavailable)
    nonisolated public func lineLimit(_ limit: Range<Int>) -> some View {
        stubView()
    }

    nonisolated public func lineLimit(_ limit: Int, reservesSpace: Bool) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.lineLimit(limit, reservesSpace: reservesSpace)
        }
    }

    @available(*, unavailable)
    nonisolated public func lineSpacing(_ lineSpacing: CGFloat) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func lineHeight(_ lineHeight: Any? /* AttributedString.LineHeight? */) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func minimumScaleFactor(_ factor: CGFloat) -> some View {
        stubView()
    }

    nonisolated public func multilineTextAlignment(_ alignment: TextAlignment) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.multilineTextAlignment(bridgedAlignment: alignment.rawValue)
        }
    }

    nonisolated public func multilineTextAlignment(strategy: Text.AlignmentStrategy) -> some View {
        return self
    }

    @available(*, unavailable)
    nonisolated public func privacySensitive(_ sensitive: Bool = true) -> some View {
        stubView()
    }

    nonisolated public func redacted(reason: RedactionReasons) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.redacted(bridgedReason: reason.rawValue)
        }
    }

    @available(*, unavailable)
    nonisolated public func speechAlwaysIncludesPunctuation(_ value: Bool = true) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func speechSpellsOutCharacters(_ value: Bool = true) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func speechAdjustedPitch(_ value: Double) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func speechAnnouncementsQueued(_ value: Bool = true) -> some View {
        stubView()
    }

    nonisolated public func textCase(_ textCase: Text.Case?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.bridgedTextCase(textCase?.rawValue)
        }
    }

    @available(*, unavailable)
    nonisolated public func textScale(_ scale: Text.Scale, isEnabled: Bool = true) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func textSelection(_ selectability: TextSelectability) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func truncationMode(_ mode: Text.TruncationMode) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func unredacted() -> some View {
        stubView()
    }

    nonisolated public func writingDirection(strategy: Text.WritingDirectionStrategy) -> some View {
        return self
    }
}

extension Text {
    @available(*, unavailable)
    nonisolated public func accessibilityTextContentType(_ value: AccessibilityTextContentType) -> Text {
        fatalError()
    }

    nonisolated public func accessibilityHeading(_ level: AccessibilityHeadingLevel) -> Text {
        var text = self
        text.modifierChain.append {
            $0.accessibilityHeading(level)
        }
        return text
    }

    nonisolated public func accessibilityLabel(_ label: Text) -> Text {
        var text = self
        text.modifierChain.append {
            $0.accessibilityLabel(label)
        }
        return text
    }

    nonisolated public func accessibilityLabel(_ labelKey: LocalizedStringKey) -> Text {
        return accessibilityLabel(Text(labelKey))
    }

    @_disfavoredOverload nonisolated public func accessibilityLabel<S>(_ label: S) -> Text where S : StringProtocol {
        return accessibilityLabel(Text(label))
    }
}

extension View {
    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityTextContentType(_ value: AccessibilityTextContentType) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @_disfavoredOverload nonisolated public func accessibilityHeading(_ level: AccessibilityHeadingLevel) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.accessibilityHeading(bridgedLevel: Int(level.rawValue))
        }
    }
}

extension Text {
    public struct Scale : Sendable, Hashable {
        public static let `default` = Text.Scale()
        public static let secondary = Text.Scale()
    }
}

extension Text {
    @available(*, unavailable)
    public func textScale(_ scale: Text.Scale, isEnabled: Bool = true) -> Text {
        fatalError()
    }
}

@frozen public enum TextAlignment : Int, Hashable, CaseIterable /*, BitwiseCopyable, Sendable */ {
    case leading = 0 // For bridging
    case center = 1 // For bridging
    case trailing = 2 // For bridging
}

//extension Text {
//    @available(*, unavailable)
//    public init<V, F>(_ source: TimeDataSource<V>, format: F) where V == F.FormatInput, */ F : DiscreteFormatStyle, F.FormatOutput == AttributedString
//
//    public init<V, F>(_ source: TimeDataSource<V>, format: F) where V == F.FormatInput, F : DiscreteFormatStyle, F.FormatOutput == String
//}

extension Text {
    @available(*, unavailable)
    public struct Layout /* : RandomAccessCollection, Equatable */ {
//        /// Indicates if this text is truncated.
//        @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
//        public var isTruncated: Bool { get }
//
//        /// The position of the first element in a nonempty collection.
//        ///
//        /// If the collection is empty, `startIndex` is equal to `endIndex`.
//        public var startIndex: Int { get }
//
//        /// The collection's "past the end" position---that is, the position one
//        /// greater than the last valid subscript argument.
//        ///
//        /// When you need a range that includes the last element of a collection, use
//        /// the half-open range operator (`..<`) with `endIndex`. The `..<` operator
//        /// creates a range that doesn't include the upper bound, so it's always
//        /// safe to use with `endIndex`. For example:
//        ///
//        ///     let numbers = [10, 20, 30, 40, 50]
//        ///     if let index = numbers.firstIndex(of: 30) {
//        ///         print(numbers[index ..< numbers.endIndex])
//        ///     }
//        ///     // Prints "[30, 40, 50]"
//        ///
//        /// If the collection is empty, `endIndex` is equal to `startIndex`.
//        public var endIndex: Int { get }
//
//        /// Accesses the element at the specified position.
//        ///
//        /// The following example accesses an element of an array through its
//        /// subscript to print its value:
//        ///
//        ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
//        ///     print(streets[1])
//        ///     // Prints "Bryant"
//        ///
//        /// You can subscript a collection with any valid index other than the
//        /// collection's end index. The end index refers to the position one past
//        /// the last element of a collection, so it doesn't correspond with an
//        /// element.
//        ///
//        /// - Parameter position: The position of the element to access. `position`
//        ///   must be a valid index of the collection that is not equal to the
//        ///   `endIndex` property.
//        ///
//        /// - Complexity: O(1)
//        public subscript(index: Int) -> Text.Layout.Line { get }
//
//        /// The index of a character in the source text. An opaque
//        /// type, this is intended to be used to determine relative
//        /// locations of elements in the layout, rather than how they
//        /// map to the source strings.
//        @frozen public struct CharacterIndex : Comparable, Hashable, Strideable, Sendable {
//
//            /// Returns a Boolean value indicating whether the value of the first
//            /// argument is less than that of the second argument.
//            ///
//            /// This function is the only requirement of the `Comparable` protocol. The
//            /// remainder of the relational operator functions are implemented by the
//            /// standard library for any type that conforms to `Comparable`.
//            ///
//            /// - Parameters:
//            ///   - lhs: A value to compare.
//            ///   - rhs: Another value to compare.
//            public static func < (lhs: Text.Layout.CharacterIndex, rhs: Text.Layout.CharacterIndex) -> Bool
//
//            /// Returns a value that is offset the specified distance from this value.
//            ///
//            /// Use the `advanced(by:)` method in generic code to offset a value by a
//            /// specified distance. If you're working directly with numeric values, use
//            /// the addition operator (`+`) instead of this method.
//            ///
//            ///     func addOne<T: Strideable>(to x: T) -> T
//            ///         where T.Stride: ExpressibleByIntegerLiteral
//            ///     {
//            ///         return x.advanced(by: 1)
//            ///     }
//            ///
//            ///     let x = addOne(to: 5)
//            ///     // x == 6
//            ///     let y = addOne(to: 3.5)
//            ///     // y = 4.5
//            ///
//            /// If this type's `Stride` type conforms to `BinaryInteger`, then for a
//            /// value `x`, a distance `n`, and a value `y = x.advanced(by: n)`,
//            /// `x.distance(to: y) == n`. Using this method with types that have a
//            /// noninteger `Stride` may result in an approximation. If the result of
//            /// advancing by `n` is not representable as a value of this type, then a
//            /// runtime error may occur.
//            ///
//            /// - Parameter n: The distance to advance this value.
//            /// - Returns: A value that is offset from this value by `n`.
//            ///
//            /// - Complexity: O(1)
//            public func advanced(by n: Int) -> Text.Layout.CharacterIndex
//
//            /// Returns the distance from this value to the given value, expressed as a
//            /// stride.
//            ///
//            /// If this type's `Stride` type conforms to `BinaryInteger`, then for two
//            /// values `x` and `y`, and a distance `n = x.distance(to: y)`,
//            /// `x.advanced(by: n) == y`. Using this method with types that have a
//            /// noninteger `Stride` may result in an approximation.
//            ///
//            /// - Parameter other: The value to calculate the distance to.
//            /// - Returns: The distance from this value to `other`.
//            ///
//            /// - Complexity: O(1)
//            public func distance(to other: Text.Layout.CharacterIndex) -> Int
//
//            /// Hashes the essential components of this value by feeding them into the
//            /// given hasher.
//            ///
//            /// Implement this method to conform to the `Hashable` protocol. The
//            /// components used for hashing must be the same as the components compared
//            /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
//            /// with each of these components.
//            ///
//            /// - Important: In your implementation of `hash(into:)`,
//            ///   don't call `finalize()` on the `hasher` instance provided,
//            ///   or replace it with a different instance.
//            ///   Doing so may become a compile-time error in the future.
//            ///
//            /// - Parameter hasher: The hasher to use when combining the components
//            ///   of this instance.
//            public func hash(into hasher: inout Hasher)
//
//            /// A type that represents the distance between two values.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Stride = Int
//
//            /// The hash value.
//            ///
//            /// Hash values are not guaranteed to be equal across different executions of
//            /// your program. Do not save hash values to use during a future execution.
//            ///
//            /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
//            ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
//            ///   The compiler provides an implementation for `hashValue` for you.
//            public var hashValue: Int { get }
//        }
//
//        /// The typographic bounds of an element in a text layout.
//        @frozen public struct TypographicBounds : Equatable, Sendable {
//
//            /// The position of the left edge of the element's
//            /// baseline, relative to the text view.
//            public var origin: CGPoint
//
//            /// The width of the element.
//            public var width: CGFloat
//
//            /// The ascent of the element.
//            public var ascent: CGFloat
//
//            /// The descent of the element.
//            public var descent: CGFloat
//
//            /// The leading of the element.
//            public var leading: CGFloat
//
//            /// Initializes to an empty bounds with zero origin.
//            public init()
//
//            /// Returns a rectangle encapsulating the bounds.
//            public var rect: CGRect { get }
//
//            /// Returns a Boolean value indicating whether two values are equal.
//            ///
//            /// Equality is the inverse of inequality. For any values `a` and `b`,
//            /// `a == b` implies that `a != b` is `false`.
//            ///
//            /// - Parameters:
//            ///   - lhs: A value to compare.
//            ///   - rhs: Another value to compare.
//            public static func == (a: Text.Layout.TypographicBounds, b: Text.Layout.TypographicBounds) -> Bool
//        }
//
//        /// A single line in a text layout: a collection of runs of
//        /// placed glyphs.
//        public struct Line : RandomAccessCollection, Equatable {
//
//            /// The origin of the line.
//            public var origin: CGPoint
//
//            /// The position of the first element in a nonempty collection.
//            ///
//            /// If the collection is empty, `startIndex` is equal to `endIndex`.
//            public var startIndex: Int { get }
//
//            /// The collection's "past the end" position---that is, the position one
//            /// greater than the last valid subscript argument.
//            ///
//            /// When you need a range that includes the last element of a collection, use
//            /// the half-open range operator (`..<`) with `endIndex`. The `..<` operator
//            /// creates a range that doesn't include the upper bound, so it's always
//            /// safe to use with `endIndex`. For example:
//            ///
//            ///     let numbers = [10, 20, 30, 40, 50]
//            ///     if let index = numbers.firstIndex(of: 30) {
//            ///         print(numbers[index ..< numbers.endIndex])
//            ///     }
//            ///     // Prints "[30, 40, 50]"
//            ///
//            /// If the collection is empty, `endIndex` is equal to `startIndex`.
//            public var endIndex: Int { get }
//
//            /// Accesses the element at the specified position.
//            ///
//            /// The following example accesses an element of an array through its
//            /// subscript to print its value:
//            ///
//            ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
//            ///     print(streets[1])
//            ///     // Prints "Bryant"
//            ///
//            /// You can subscript a collection with any valid index other than the
//            /// collection's end index. The end index refers to the position one past
//            /// the last element of a collection, so it doesn't correspond with an
//            /// element.
//            ///
//            /// - Parameter position: The position of the element to access. `position`
//            ///   must be a valid index of the collection that is not equal to the
//            ///   `endIndex` property.
//            ///
//            /// - Complexity: O(1)
//            public subscript(index: Int) -> Text.Layout.Run { get }
//
//            /// The typographic bounds of the line.
//            public var typographicBounds: Text.Layout.TypographicBounds { get }
//
//            /// Returns a Boolean value indicating whether two values are equal.
//            ///
//            /// Equality is the inverse of inequality. For any values `a` and `b`,
//            /// `a == b` implies that `a != b` is `false`.
//            ///
//            /// - Parameters:
//            ///   - lhs: A value to compare.
//            ///   - rhs: Another value to compare.
//            public static func == (lhs: Text.Layout.Line, rhs: Text.Layout.Line) -> Bool
//
//            /// A type representing the sequence's elements.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Element = Text.Layout.Run
//
//            /// A type that represents a position in the collection.
//            ///
//            /// Valid indices consist of the position of every element and a
//            /// "past the end" position that's not valid for use as a subscript
//            /// argument.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Index = Int
//
//            /// A type that represents the indices that are valid for subscripting the
//            /// collection, in ascending order.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Indices = Range<Int>
//
//            /// A type that provides the collection's iteration interface and
//            /// encapsulates its iteration state.
//            ///
//            /// By default, a collection conforms to the `Sequence` protocol by
//            /// supplying `IndexingIterator` as its associated `Iterator`
//            /// type.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Iterator = IndexingIterator<Text.Layout.Line>
//
//            /// A collection representing a contiguous subrange of this collection's
//            /// elements. The subsequence shares indices with the original collection.
//            ///
//            /// The default subsequence type for collections that don't define their own
//            /// is `Slice`.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias SubSequence = Slice<Text.Layout.Line>
//        }
//
//        /// A run of placed glyphs in a text layout.
//        public struct Run : RandomAccessCollection, Equatable {
//
//            /// The position of the first element in a nonempty collection.
//            ///
//            /// If the collection is empty, `startIndex` is equal to `endIndex`.
//            public var startIndex: Int { get }
//
//            /// The collection's "past the end" position---that is, the position one
//            /// greater than the last valid subscript argument.
//            ///
//            /// When you need a range that includes the last element of a collection, use
//            /// the half-open range operator (`..<`) with `endIndex`. The `..<` operator
//            /// creates a range that doesn't include the upper bound, so it's always
//            /// safe to use with `endIndex`. For example:
//            ///
//            ///     let numbers = [10, 20, 30, 40, 50]
//            ///     if let index = numbers.firstIndex(of: 30) {
//            ///         print(numbers[index ..< numbers.endIndex])
//            ///     }
//            ///     // Prints "[30, 40, 50]"
//            ///
//            /// If the collection is empty, `endIndex` is equal to `startIndex`.
//            public var endIndex: Int { get }
//
//            /// Accesses the element at the specified position.
//            ///
//            /// The following example accesses an element of an array through its
//            /// subscript to print its value:
//            ///
//            ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
//            ///     print(streets[1])
//            ///     // Prints "Bryant"
//            ///
//            /// You can subscript a collection with any valid index other than the
//            /// collection's end index. The end index refers to the position one past
//            /// the last element of a collection, so it doesn't correspond with an
//            /// element.
//            ///
//            /// - Parameter position: The position of the element to access. `position`
//            ///   must be a valid index of the collection that is not equal to the
//            ///   `endIndex` property.
//            ///
//            /// - Complexity: O(1)
//            public subscript(index: Int) -> Text.Layout.RunSlice { get }
//
//            /// Accesses a contiguous subrange of the collection's elements.
//            ///
//            /// The accessed slice uses the same indices for the same elements as the
//            /// original collection uses. Always use the slice's `startIndex` property
//            /// instead of assuming that its indices start at a particular value.
//            ///
//            /// This example demonstrates getting a slice of an array of strings, finding
//            /// the index of one of the strings in the slice, and then using that index
//            /// in the original array.
//            ///
//            ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
//            ///     let streetsSlice = streets[2 ..< streets.endIndex]
//            ///     print(streetsSlice)
//            ///     // Prints "["Channing", "Douglas", "Evarts"]"
//            ///
//            ///     let index = streetsSlice.firstIndex(of: "Evarts")    // 4
//            ///     print(streets[index!])
//            ///     // Prints "Evarts"
//            ///
//            /// - Parameter bounds: A range of the collection's indices. The bounds of
//            ///   the range must be valid indices of the collection.
//            ///
//            /// - Complexity: O(1)
//            public subscript(bounds: Range<Int>) -> Text.Layout.RunSlice { get }
//
//            /// The custom attribute of type `T` associated with the
//            /// run of glyphs, or nil.
//            public subscript<T>(key: T.Type) -> T? where T : TextAttribute { get }
//
//            /// The layout direction of the text run.
//            public var layoutDirection: LayoutDirection { get }
//
//            /// The typographic bounds of the run of glyphs.
//            public var typographicBounds: Text.Layout.TypographicBounds { get }
//
//            /// The array of character indices corresponding to the
//            /// glyphs in `self`.
//            public var characterIndices: [Text.Layout.CharacterIndex] { get }
//
//            /// Returns a Boolean value indicating whether two values are equal.
//            ///
//            /// Equality is the inverse of inequality. For any values `a` and `b`,
//            /// `a == b` implies that `a != b` is `false`.
//            ///
//            /// - Parameters:
//            ///   - lhs: A value to compare.
//            ///   - rhs: Another value to compare.
//            public static func == (lhs: Text.Layout.Run, rhs: Text.Layout.Run) -> Bool
//
//            /// A type representing the sequence's elements.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Element = Text.Layout.RunSlice
//
//            /// A type that represents a position in the collection.
//            ///
//            /// Valid indices consist of the position of every element and a
//            /// "past the end" position that's not valid for use as a subscript
//            /// argument.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Index = Int
//
//            /// A type that represents the indices that are valid for subscripting the
//            /// collection, in ascending order.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Indices = Range<Int>
//
//            /// A type that provides the collection's iteration interface and
//            /// encapsulates its iteration state.
//            ///
//            /// By default, a collection conforms to the `Sequence` protocol by
//            /// supplying `IndexingIterator` as its associated `Iterator`
//            /// type.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Iterator = IndexingIterator<Text.Layout.Run>
//
//            /// A collection representing a contiguous subrange of this collection's
//            /// elements. The subsequence shares indices with the original collection.
//            ///
//            /// The default subsequence type for collections that don't define their own
//            /// is `Slice`.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias SubSequence = Text.Layout.RunSlice
//        }
//
//        /// A slice of a run of placed glyphs in a text layout.
//        public struct RunSlice : RandomAccessCollection, Equatable {
//
//            public var run: Text.Layout.Run
//
//            /// The indices that are valid for subscripting the collection, in ascending
//            /// order.
//            ///
//            /// A collection's `indices` property can hold a strong reference to the
//            /// collection itself, causing the collection to be nonuniquely referenced.
//            /// If you mutate the collection while iterating over its indices, a strong
//            /// reference can result in an unexpected copy of the collection. To avoid
//            /// the unexpected copy, use the `index(after:)` method starting with
//            /// `startIndex` to produce indices instead.
//            ///
//            ///     var c = MyFancyCollection([10, 20, 30, 40, 50])
//            ///     var i = c.startIndex
//            ///     while i != c.endIndex {
//            ///         c[i] /= 5
//            ///         i = c.index(after: i)
//            ///     }
//            ///     // c == MyFancyCollection([2, 4, 6, 8, 10])
//            public var indices: Range<Int>
//
//            public init(run: Text.Layout.Run, indices: Range<Int>)
//
//            /// The position of the first element in a nonempty collection.
//            ///
//            /// If the collection is empty, `startIndex` is equal to `endIndex`.
//            public var startIndex: Int { get }
//
//            /// The collection's "past the end" position---that is, the position one
//            /// greater than the last valid subscript argument.
//            ///
//            /// When you need a range that includes the last element of a collection, use
//            /// the half-open range operator (`..<`) with `endIndex`. The `..<` operator
//            /// creates a range that doesn't include the upper bound, so it's always
//            /// safe to use with `endIndex`. For example:
//            ///
//            ///     let numbers = [10, 20, 30, 40, 50]
//            ///     if let index = numbers.firstIndex(of: 30) {
//            ///         print(numbers[index ..< numbers.endIndex])
//            ///     }
//            ///     // Prints "[30, 40, 50]"
//            ///
//            /// If the collection is empty, `endIndex` is equal to `startIndex`.
//            public var endIndex: Int { get }
//
//            /// Accesses the element at the specified position.
//            ///
//            /// The following example accesses an element of an array through its
//            /// subscript to print its value:
//            ///
//            ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
//            ///     print(streets[1])
//            ///     // Prints "Bryant"
//            ///
//            /// You can subscript a collection with any valid index other than the
//            /// collection's end index. The end index refers to the position one past
//            /// the last element of a collection, so it doesn't correspond with an
//            /// element.
//            ///
//            /// - Parameter position: The position of the element to access. `position`
//            ///   must be a valid index of the collection that is not equal to the
//            ///   `endIndex` property.
//            ///
//            /// - Complexity: O(1)
//            public subscript(index: Int) -> Text.Layout.RunSlice { get }
//
//            /// Accesses a contiguous subrange of the collection's elements.
//            ///
//            /// The accessed slice uses the same indices for the same elements as the
//            /// original collection uses. Always use the slice's `startIndex` property
//            /// instead of assuming that its indices start at a particular value.
//            ///
//            /// This example demonstrates getting a slice of an array of strings, finding
//            /// the index of one of the strings in the slice, and then using that index
//            /// in the original array.
//            ///
//            ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
//            ///     let streetsSlice = streets[2 ..< streets.endIndex]
//            ///     print(streetsSlice)
//            ///     // Prints "["Channing", "Douglas", "Evarts"]"
//            ///
//            ///     let index = streetsSlice.firstIndex(of: "Evarts")    // 4
//            ///     print(streets[index!])
//            ///     // Prints "Evarts"
//            ///
//            /// - Parameter bounds: A range of the collection's indices. The bounds of
//            ///   the range must be valid indices of the collection.
//            ///
//            /// - Complexity: O(1)
//            public subscript(bounds: Range<Int>) -> Text.Layout.RunSlice { get }
//
//            /// The custom attribute of type `T` associated with the
//            /// run of glyphs, or nil.
//            public subscript<T>(key: T.Type) -> T? where T : TextAttribute { get }
//
//            /// The typographic bounds of the partial run of glyphs.
//            public var typographicBounds: Text.Layout.TypographicBounds { get }
//
//            /// The array of character indices corresponding to the
//            /// glyphs in `self`.
//            public var characterIndices: [Text.Layout.CharacterIndex] { get }
//
//            /// Returns a Boolean value indicating whether two values are equal.
//            ///
//            /// Equality is the inverse of inequality. For any values `a` and `b`,
//            /// `a == b` implies that `a != b` is `false`.
//            ///
//            /// - Parameters:
//            ///   - lhs: A value to compare.
//            ///   - rhs: Another value to compare.
//            public static func == (a: Text.Layout.RunSlice, b: Text.Layout.RunSlice) -> Bool
//
//            /// A type representing the sequence's elements.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Element = Text.Layout.RunSlice
//
//            /// A type that represents a position in the collection.
//            ///
//            /// Valid indices consist of the position of every element and a
//            /// "past the end" position that's not valid for use as a subscript
//            /// argument.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Index = Int
//
//            /// A type that represents the indices that are valid for subscripting the
//            /// collection, in ascending order.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Indices = Range<Int>
//
//            /// A type that provides the collection's iteration interface and
//            /// encapsulates its iteration state.
//            ///
//            /// By default, a collection conforms to the `Sequence` protocol by
//            /// supplying `IndexingIterator` as its associated `Iterator`
//            /// type.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias Iterator = IndexingIterator<Text.Layout.RunSlice>
//
//            /// A collection representing a contiguous subrange of this collection's
//            /// elements. The subsequence shares indices with the original collection.
//            ///
//            /// The default subsequence type for collections that don't define their own
//            /// is `Slice`.
//            @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//            public typealias SubSequence = Text.Layout.RunSlice
//        }
//
//        /// Returns a Boolean value indicating whether two values are equal.
//        ///
//        /// Equality is the inverse of inequality. For any values `a` and `b`,
//        /// `a == b` implies that `a != b` is `false`.
//        ///
//        /// - Parameters:
//        ///   - lhs: A value to compare.
//        ///   - rhs: Another value to compare.
//        public static func == (a: Text.Layout, b: Text.Layout) -> Bool
//
//        /// A type representing the sequence's elements.
//        @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//        public typealias Element = Text.Layout.Line
//
//        /// A type that represents a position in the collection.
//        ///
//        /// Valid indices consist of the position of every element and a
//        /// "past the end" position that's not valid for use as a subscript
//        /// argument.
//        @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//        public typealias Index = Int
//
//        /// A type that represents the indices that are valid for subscripting the
//        /// collection, in ascending order.
//        @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//        public typealias Indices = Range<Int>
//
//        /// A type that provides the collection's iteration interface and
//        /// encapsulates its iteration state.
//        ///
//        /// By default, a collection conforms to the `Sequence` protocol by
//        /// supplying `IndexingIterator` as its associated `Iterator`
//        /// type.
//        @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//        public typealias Iterator = IndexingIterator<Text.Layout>
//
//        /// A collection representing a contiguous subrange of this collection's
//        /// elements. The subsequence shares indices with the original collection.
//        ///
//        /// The default subsequence type for collections that don't define their own
//        /// is `Slice`.
//        @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//        public typealias SubSequence = Slice<Text.Layout>
    }
}

extension Text {
    @available(*, unavailable)
    public struct LayoutKey /* : PreferenceKey, Sendable */ {
//        public struct AnchoredLayout : Equatable {
//
//            /// The origin of the text layout.
//            public var origin: Anchor<CGPoint>
//
//            /// The text layout value.
//            public var layout: Text.Layout
//
//            /// Returns a Boolean value indicating whether two values are equal.
//            ///
//            /// Equality is the inverse of inequality. For any values `a` and `b`,
//            /// `a == b` implies that `a != b` is `false`.
//            ///
//            /// - Parameters:
//            ///   - lhs: A value to compare.
//            ///   - rhs: Another value to compare.
//            public static func == (a: Text.LayoutKey.AnchoredLayout, b: Text.LayoutKey.AnchoredLayout) -> Bool
//        }
//
//        /// The type of value produced by this preference.
//        public typealias Value = [Text.LayoutKey.AnchoredLayout]
//
//        /// The default value of the preference.
//        ///
//        /// Views that have no explicit value for the key produce this default
//        /// value. Combining child views may remove an implicit value produced by
//        /// using the default. This means that `reduce(value: &x, nextValue:
//        /// {defaultValue})` shouldn't change the meaning of `x`.
//        public static let defaultValue: Text.LayoutKey.Value
//
//        /// Combines a sequence of values by modifying the previously-accumulated
//        /// value with the result of a closure that provides the next value.
//        ///
//        /// This method receives its values in view-tree order. Conceptually, this
//        /// combines the preference value from one tree with that of its next
//        /// sibling.
//        ///
//        /// - Parameters:
//        ///   - value: The value accumulated through previous calls to this method.
//        ///     The implementation should modify this value.
//        ///   - nextValue: A closure that returns the next value in the sequence.
//        public static func reduce(value: inout Text.LayoutKey.Value, nextValue: () -> Text.LayoutKey.Value)
    }
}

//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//extension Text.Layout {
//
//    /// Option flags used when drawing `Text.Layout` lines or runs into
//    /// a graphics context.
//    @frozen public struct DrawingOptions : OptionSet {
//
//        /// The corresponding value of the raw type.
//        ///
//        /// A new instance initialized with `rawValue` will be equivalent to this
//        /// instance. For example:
//        ///
//        ///     enum PaperSize: String {
//        ///         case A4, A5, Letter, Legal
//        ///     }
//        ///
//        ///     let selectedSize = PaperSize.Letter
//        ///     print(selectedSize.rawValue)
//        ///     // Prints "Letter"
//        ///
//        ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
//        ///     // Prints "true"
//        public let rawValue: UInt32
//
//        /// Creates a new option set from the given raw value.
//        ///
//        /// This initializer always succeeds, even if the value passed as `rawValue`
//        /// exceeds the static properties declared as part of the option set. This
//        /// example creates an instance of `ShippingOptions` with a raw value beyond
//        /// the highest element, with a bit mask that effectively contains all the
//        /// declared static members.
//        ///
//        ///     let extraOptions = ShippingOptions(rawValue: 255)
//        ///     print(extraOptions.isStrictSuperset(of: .all))
//        ///     // Prints "true"
//        ///
//        /// - Parameter rawValue: The raw value of the option set to create. Each bit
//        ///   of `rawValue` potentially represents an element of the option set,
//        ///   though raw values may include bits that are not defined as distinct
//        ///   values of the `OptionSet` type.
//        public init(rawValue: UInt32)
//
//        /// If set, subpixel quantization requested by the text engine
//        /// is disabled. This can be useful for text that will be
//        /// animated to prevent it jittering.
//        public static var disablesSubpixelQuantization: Text.Layout.DrawingOptions { get }
//
//        /// The type of the elements of an array literal.
//        @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//        public typealias ArrayLiteralElement = Text.Layout.DrawingOptions
//
//        /// The element type of the option set.
//        ///
//        /// To inherit all the default implementations from the `OptionSet` protocol,
//        /// the `Element` type must be `Self`, the default.
//        @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//        public typealias Element = Text.Layout.DrawingOptions
//
//        /// The raw type that can be used to represent all values of the conforming
//        /// type.
//        ///
//        /// Every distinct value of the conforming type has a corresponding unique
//        /// value of the `RawValue` type, but there may be values of the `RawValue`
//        /// type that don't have a corresponding value of the conforming type.
//        @available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *)
//        public typealias RawValue = UInt32
//    }
//}
//
//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//extension Text.Layout.CharacterIndex : BitwiseCopyable {
//}
//
//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//extension Text.Layout.TypographicBounds : BitwiseCopyable {
//}
//
//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//extension Text.Layout.DrawingOptions : Sendable {
//}
//
//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//extension Text.Layout.DrawingOptions : BitwiseCopyable {
//}
//

extension Text {
    public struct WritingDirectionStrategy : Hashable, Sendable {
        @available(*, unavailable)
        public static let layoutBased = WritingDirectionStrategy()
        public static let contentBased = WritingDirectionStrategy()
        public static let `default` = WritingDirectionStrategy()
    }
}

extension Text {
    public struct AlignmentStrategy : Hashable, Sendable {
        @available(*, unavailable)
        public static let layoutBased = AlignmentStrategy()
        @available(*, unavailable)
        public static let writingDirectionBased = AlignmentStrategy()
        public static let `default` = AlignmentStrategy()
    }
}

public protocol TextAttribute : Hashable {
}

@available(*, unavailable)
public struct TextProxy {
    public func sizeThatFits(_ proposal: Any /* ProposedViewSize */) -> CGSize {
        fatalError()
    }
}

@available(*, unavailable)
public protocol TextRenderer : Animatable {
//    /// Draws `layout` into `ctx`.
//    func draw(layout: Text.Layout, in ctx: inout GraphicsContext)
//
//    /// Returns the size of the text in `proposal`. The provided `text`
//    /// proxy value may be used to query the sizing behavior of the
//    /// underlying text layout.
//    ///
//    /// The default implementation of this function returns
//    /// `text.size(proposal)`.
//    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
//    func sizeThatFits(proposal: ProposedViewSize, text: TextProxy) -> CGSize
//
//    /// Returns the size of the extra padding added to any drawing
//    /// layer used to rasterize the text. For example when drawing the
//    /// text with a shadow this may be used to extend the drawing
//    /// bounds to avoid clipping the shadow.
//    ///
//    /// The default implementation of this function returns an empty
//    /// set of insets.
//    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
//    var displayPadding: EdgeInsets { get }
}

//@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
//extension TextRenderer {
//
//    /// Returns the size of the text in `proposal`. The provided `text`
//    /// proxy value may be used to query the sizing behavior of the
//    /// underlying text layout.
//    ///
//    /// The default implementation of this function returns
//    /// `text.size(proposal)`.
//    public func sizeThatFits(proposal: ProposedViewSize, text: TextProxy) -> CGSize
//
//    /// Returns the size of the extra padding added to any drawing
//    /// layer used to rasterize the text. For example when drawing the
//    /// text with a shadow this may be used to extend the drawing
//    /// bounds to avoid clipping the shadow.
//    ///
//    /// The default implementation of this function returns an empty
//    /// set of insets.
//    public var displayPadding: EdgeInsets { get }
//}

public protocol TextSelectability {
    static var allowsSelection: Bool { get }
}

public struct EnabledTextSelectability : TextSelectability {
    public static let allowsSelection = true
}

extension TextSelectability where Self == EnabledTextSelectability {
    public static var enabled: EnabledTextSelectability {
        return EnabledTextSelectability()
    }
}

public struct DisabledTextSelectability : TextSelectability {
    public static let allowsSelection = false
}

extension TextSelectability where Self == DisabledTextSelectability {
    public static var disabled: DisabledTextSelectability {
        return DisabledTextSelectability()
    }
}

public protocol TextVariantPreference {
}

public struct FixedTextVariant : TextVariantPreference, Sendable {
}

extension TextVariantPreference where Self == FixedTextVariant {
    public static var fixed: FixedTextVariant {
        return FixedTextVariant()
    }
}

public struct SizeDependentTextVariant : TextVariantPreference, Sendable {
}

extension TextVariantPreference where Self == SizeDependentTextVariant {
    public static var sizeDependent: SizeDependentTextVariant {
        return SizeDependentTextVariant()
    }
}

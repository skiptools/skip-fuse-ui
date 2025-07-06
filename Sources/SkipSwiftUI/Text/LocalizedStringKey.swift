// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipFuse

@frozen public struct LocalizedStringKey : Equatable, ExpressibleByStringInterpolation {
    private(set) var interpolation: StringInterpolation

    public init(_ value: String) {
        self.init(stringLiteral: value)
    }

    public init(stringLiteral value: String) {
        var interpolation = StringInterpolation(literalCapacity: 0, interpolationCount: 0)
        interpolation.appendLiteral(value)
        self.interpolation = interpolation
    }

    public init(stringInterpolation: StringInterpolation) {
        self.interpolation = stringInterpolation
    }

    public typealias StringInterpolation = AndroidStringInterpolation

    public static func ==(a: LocalizedStringKey, b: LocalizedStringKey) -> Bool {
        guard a.interpolation.pattern == b.interpolation.pattern else {
            return false
        }
        guard a.interpolation.values.count == b.interpolation.values.count else {
            return false
        }
        for pair in zip(a.interpolation.values, b.interpolation.values) {
            guard String(describing: pair.0) == String(describing: pair.1) else {
                return false
            }
        }
        return true
    }

    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias StringLiteralType = String
    public typealias UnicodeScalarLiteralType = String
}

//extension LocalizedStringKey.StringInterpolation {
//    public mutating func appendInterpolation(_ resource: AndroidLocalizedStringResource)
//}

extension LocalizedStringKey.StringInterpolation {
    public mutating func appendInterpolation(_ text: Text) {
        if let verbatim = text.spec.verbatim {
            appendInterpolation(verbatim)
        } else if let key = text.spec.key {
            let interpolation = key.interpolation
            pattern += interpolation.pattern
            values += interpolation.values
            // TODO: spec.bundle, spec.tableName
        }
    }
}

extension LocalizedStringKey.StringInterpolation {
    @available(*, unavailable)
    public mutating func appendInterpolation(accessibilityName color: Color) {
        fatalError()
    }
}

extension LocalizedStringKey.StringInterpolation {
    public mutating func appendInterpolation(_ image: Image) {
        if case .named(_, _, let label) = image.spec.type, let label {
            appendInterpolation(label)
        }
    }
}

extension LocalizedStringKey.StringInterpolation {
    public mutating func appendInterpolation(_ date: Date, style: Text.DateStyle) {
        appendInterpolation(style.format(date))
    }

    @available(*, unavailable)
    public mutating func appendInterpolation(_ dates: ClosedRange<Date>) {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func appendInterpolation(_ interval: DateInterval) {
        fatalError()
    }
}

extension LocalizedStringKey.StringInterpolation {
    @available(*, unavailable)
    public mutating func appendInterpolation(timerInterval: ClosedRange<Date>, pauseTime: Date? = nil, countsDown: Bool = true, showsHours: Bool = true) {
        fatalError()
    }
}

//extension LocalizedStringKey.StringInterpolation {
//    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
//    public mutating func appendInterpolation<V, F>(_ source: TimeDataSource<V>, format: F) where V == F.FormatInput, F : DiscreteFormatStyle, F.FormatOutput == AttributedString

//    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
//    public mutating func appendInterpolation<V, F>(_ source: TimeDataSource<V>, format: F) where V == F.FormatInput, F : DiscreteFormatStyle, F.FormatOutput == String
//}

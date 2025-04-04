// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation

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

    public struct StringInterpolation : StringInterpolationProtocol {
        var pattern = ""
        var values: [Any] = []

        public init(literalCapacity: Int, interpolationCount: Int) {
        }

        public mutating func appendLiteral(_ literal: String) {
            // need to escape out Java-specific format marker
            pattern += literal.replacingOccurrences(of: "%", with: "%%")
        }

        public mutating func appendInterpolation(_ string: String) {
            pattern += "%@"
            values.append(string)
        }

        public mutating func appendInterpolation<Subject>(_ subject: Subject, formatter: Formatter? = nil) where Subject : AnyObject /* ReferenceConvertible // Causes compiler crash */ {
            if let formatter {
                appendInterpolation(formatter.string(for: subject) ?? "nil")
            } else {
                appendInterpolation(String(describing: subject))
            }
        }

        public mutating func appendInterpolation<Subject>(_ subject: Subject, formatter: Formatter? = nil) where Subject : NSObject {
            if let formatter {
                appendInterpolation(formatter.string(for: subject) ?? "nil")
            } else {
                appendInterpolation(subject.description)
            }
        }

        public mutating func appendInterpolation<F>(_ input: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String {
            appendInterpolation(format.format(input))
        }

        @available(*, unavailable)
        public mutating func appendInterpolation<F>(_ input: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == AttributedString {
            fatalError()
        }

        public mutating func appendInterpolation<T>(_ value: T) /* where T : _FormatSpecifiable */ {
            if T.self == Double.self {
                appendInterpolation(value, specifier: "%lf")
            } else if T.self == Float.self {
                appendInterpolation(value, specifier: "%f")
            } else if T.self == Int.self {
                appendInterpolation(value, specifier: "%lld")
            } else if T.self == Int8.self {
                appendInterpolation(value, specifier: "%d")
            } else if T.self == Int16.self {
                appendInterpolation(value, specifier: "%d")
            } else if T.self == Int32.self {
                appendInterpolation(value, specifier: "%d")
            } else if T.self == Int64.self {
                appendInterpolation(value, specifier: "%lld")
            } else if T.self == UInt.self {
                appendInterpolation(value, specifier: "%llu")
            } else if T.self == UInt8.self {
                appendInterpolation(value, specifier: "%u")
            } else if T.self == UInt16.self {
                appendInterpolation(value, specifier: "%u")
            } else if T.self == UInt32.self {
                appendInterpolation(value, specifier: "%u")
            } else if T.self == UInt64.self {
                appendInterpolation(value, specifier: "%llu")
            } else {
                appendInterpolation(String(describing: value))
            }
        }

        public mutating func appendInterpolation<T>(_ value: T, specifier: String) /* where T : _FormatSpecifiable */ {
            pattern += specifier
            values.append(value)
        }

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

        @available(*, unavailable)
        public mutating func appendInterpolation(_ attributedString: AttributedString) {
            fatalError()
        }

        public typealias StringLiteralType = String
    }

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
//    public mutating func appendInterpolation(_ resource: LocalizedStringResource)
//}

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

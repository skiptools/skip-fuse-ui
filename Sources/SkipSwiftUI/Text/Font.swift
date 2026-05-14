// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

/* @frozen */ public struct Font : Hashable, Sendable {
    let spec: FontSpec

    init(spec: FontSpec) {
        self.spec = spec
    }
}

struct FontSpec: Hashable, Sendable {
    let type: FontType
    var isItalic: Bool
    var weight: Font.Weight?
    var design: Font.Design?
    var size: CGFloat?
    var scaledBy: CGFloat?

    init(_ type: FontType, isItalic: Bool = false, weight: Font.Weight? = nil, design: Font.Design? = nil, size: CGFloat? = nil, scaledBy: CGFloat? = nil) {
        self.type = type
        self.isItalic = isItalic
        self.weight = weight
        self.design = design
        self.size = size
        self.scaledBy = scaledBy
    }

    var Java_font: SkipUI.Font {
        var font = switch type {
        case .system(let style, let design, let weight):
            SkipUI.Font.system(bridgedStyle: style.rawValue, bridgedDesign: design?.rawValue, bridgedWeight: weight?.value)
        case .systemSize(let size, let design, let weight):
            SkipUI.Font.system(size: size, bridgedDesign: design?.rawValue, bridgedWeight: weight?.value)
        case .customSize(let name, let size):
            SkipUI.Font.custom(name, size: size)
        case .customRelativeSize(let name, let size, let relativeToStyle):
            SkipUI.Font.custom(name, size: size, bridgedRelativeTo: relativeToStyle.rawValue)
        case .customFixedSize(let name, let size):
            SkipUI.Font.custom(name, fixedSize: size)
        case .java(let javaFont):
            javaFont
        }
        if isItalic {
            font = font.italic()
        }
        if let weight {
            font = font.weight(bridgedWeight: weight.value)
        }
        if let design {
            font = font.design(bridgedValue: design.rawValue)
        }
        if let size {
            font = font.pointSize(size)
        }
        if let scaledBy {
            font = font.scaledBy(scaledBy)
        }
        return font
    }
}

enum FontType : Hashable, @unchecked Sendable {
    case system(Font.TextStyle, Font.Design?, Font.Weight?)
    case systemSize(CGFloat, Font.Design?, Font.Weight?)
    case customSize(String, CGFloat)
    case customRelativeSize(String, CGFloat, Font.TextStyle)
    case customFixedSize(String, CGFloat)
    case java(SkipUI.Font)
}

extension Font {
    public static let largeTitle = Font(spec: .init(.system(.largeTitle, nil, nil)))
    public static let title = Font(spec: .init(.system(.title, nil, nil)))
    public static let title2 = Font(spec: .init(.system(.title2, nil, nil)))
    public static let title3 = Font(spec: .init(.system(.title3, nil, nil)))
    public static let headline = Font(spec: .init(.system(.headline, nil, nil)))
    public static let subheadline = Font(spec: .init(.system(.subheadline, nil, nil)))
    public static let body = Font(spec: .init(.system(.body, nil, nil)))
    public static let callout = Font(spec: .init(.system(.callout, nil, nil)))
    public static let footnote = Font(spec: .init(.system(.footnote, nil, nil)))
    public static let caption = Font(spec: .init(.system(.caption, nil, nil)))
    public static let caption2 = Font(spec: .init(.system(.caption2, nil, nil)))

    public static func system(_ style: Font.TextStyle, design: Font.Design? = nil, weight: Font.Weight? = nil) -> Font {
        return Font(spec: .init(.system(style, design, weight)))
    }

    public static func system(_ style: Font.TextStyle, design: Font.Design = .default) -> Font {
        return system(style, design: design, weight: nil)
    }

    public enum TextStyle : Int, CaseIterable, Codable, Hashable, Sendable {
        case largeTitle = 0 // For bridging
        case title = 1 // For bridging
        case title2 = 2 // For bridging
        case title3 = 3 // For bridging
        case headline = 4 // For bridging
        case subheadline = 5 // For bridging
        case body = 6 // For bridging
        case callout = 7 // For bridging
        case footnote = 8 // For bridging
        case caption = 9 // For bridging
        case caption2 = 10 // For bridging
    }
}

extension Font {
    public func italic(_ isActive: Bool = true) -> Font {
        var spec = self.spec
        spec.isItalic = isActive
        return Font(spec: spec)
    }

    @available(*, unavailable)
    public func smallCaps(_ isActive: Bool = true) -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public func lowercaseSmallCaps(_ isActive: Bool = true) -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public func uppercaseSmallCaps(_ isActive: Bool = true) -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public func monospacedDigit(_ isActive: Bool = true) -> Font {
        fatalError()
    }

    public func weight(_ weight: Font.Weight) -> Font {
        var spec = self.spec
        spec.weight = weight
        return Font(spec: spec)
    }

    @available(*, unavailable)
    public func width(_ width: Font.Width) -> Font {
        fatalError()
    }

    public func bold(_ isActive: Bool = true) -> Font {
        return weight(isActive ? .bold : .regular)
    }

    public func monospaced(_ isActive: Bool = true) -> Font {
        var spec = self.spec
        spec.design = isActive ? .monospaced : .default
        return Font(spec: spec)
    }

    @available(*, unavailable)
    public func leading(_ leading: Font.Leading) -> Font {
        fatalError()
    }

    public func pointSize(_ size: CGFloat) -> Font {
        var spec = self.spec
        spec.size = size
        return Font(spec: spec)
    }

    public func scaled(by factor: CGFloat) -> Font {
        var spec = self.spec
        spec.scaledBy = factor
        return Font(spec: spec)
    }

    @frozen public struct Weight : Hashable, BitwiseCopyable, Sendable {
        let value: Int

        public static let ultraLight = Weight(value: -3) // For bridging
        public static let thin = Weight(value: -2) // For bridging
        public static let light = Weight(value: -1) // For bridging
        public static let regular = Weight(value: 0) // For bridging
        public static let medium = Weight(value: 1) // For bridging
        public static let semibold = Weight(value: 2) // For bridging
        public static let bold = Weight(value: 3) // For bridging
        public static let heavy = Weight(value: 4) // For bridging
        public static let black = Weight(value: 5) // For bridging
    }

    public struct Width : Hashable, Sendable {
        public var value: CGFloat

        public init(_ value: CGFloat) {
            self.value = value
        }

        public static let compressed = Width(0.8)
        public static let condensed = Width(0.9)
        public static let standard = Width(1.0)
        public static let expanded = Width(1.2)
    }

    public enum Leading : Hashable, Sendable {
        case standard
        case tight
        case loose
    }
}

extension Font {
    public static func custom(_ name: String, size: CGFloat) -> Font {
        return Font(spec: .init(.customSize(name, size)))
    }

    public static func custom(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
        return Font(spec: .init(.customRelativeSize(name, size, textStyle)))
    }

    public static func custom(_ name: String, fixedSize: CGFloat) -> Font {
        return Font(spec: .init(.customFixedSize(name, fixedSize)))
    }

//    public init(_ font: CTFont)
}

extension Font {
    public static func system(size: CGFloat, weight: Font.Weight? = nil, design: Font.Design? = nil) -> Font {
        return Font(spec: .init(.systemSize(size, design, weight)))
    }

//    public static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font

    public enum Design : Int, Hashable, Sendable {
        case `default` = 0 // For bridging
        case serif = 1 // For bridging
        case rounded = 2 // For bridging
        case monospaced = 3 // For bridging
    }
}

extension Font {
    @available(*, unavailable)
    public static var `default`: Font {
        fatalError()
    }
}

extension Font {
    @available(*, unavailable)
    public func resolve(in context: Font.Context) -> Font.Resolved {
        fatalError()
    }

    public struct Context : Hashable, CustomDebugStringConvertible {
        public var debugDescription: String {
            return "Font.Context"
        }
    }

    public struct Resolved : Hashable {
        public let ctFont: Int /* CTFont */
        public let isBold: Bool
        public let isItalic: Bool
        public let pointSize: CGFloat
        public let weight: Font.Weight
        public let width: Font.Width
        public let leading: Font.Leading
        public let isMonospaced: Bool
        public let isLowercaseSmallCaps: Bool
        public let isUppercaseSmallCaps: Bool
        public let isSmallCaps: Bool
    }
}

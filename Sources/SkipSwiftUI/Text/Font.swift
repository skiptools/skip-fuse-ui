// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

/* @frozen */ public struct Font : Hashable /*, Sendable */ {
    let spec: FontSpec

    init(spec: FontSpec) {
        self.spec = spec
    }
}

struct FontSpec: Hashable {
    let type: FontType
    var isItalic: Bool
    var weight: Font.Weight?
    var design: Font.Design?

    init(_ type: FontType, isItalic: Bool = false, weight: Font.Weight? = nil, design: Font.Design? = nil) {
        self.type = type
        self.isItalic = isItalic
        self.weight = weight
        self.design = design
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
        return font
    }
}

enum FontType : Hashable {
    case system(Font.TextStyle, Font.Design?, Font.Weight?)
    case systemSize(CGFloat, Font.Design?, Font.Weight?)
    case customSize(String, CGFloat)
    case customRelativeSize(String, CGFloat, Font.TextStyle)
    case customFixedSize(String, CGFloat)
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

    public enum TextStyle : Int, CaseIterable, Hashable /*, Sendable */ {
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
    public func italic() -> Font {
        var spec = self.spec
        spec.isItalic = true
        return Font(spec: spec)
    }

    @available(*, unavailable)
    public func smallCaps() -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public func lowercaseSmallCaps() -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public func uppercaseSmallCaps() -> Font {
        fatalError()
    }

    @available(*, unavailable)
    public func monospacedDigit() -> Font {
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

    public func bold() -> Font {
        return weight(.bold)
    }

    public func monospaced() -> Font {
        var spec = self.spec
        spec.design = .monospaced
        return Font(spec: spec)
    }

    @available(*, unavailable)
    public func leading(_ leading: Font.Leading) -> Font {
        fatalError()
    }

    @frozen public struct Weight : Hashable /*, BitwiseCopyable, Sendable */ {
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

    public enum Leading : Hashable /*, Sendable */ {
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

    public enum Design : Int, Hashable /*, Sendable */ {
        case `default` = 0 // For bridging
        case serif = 1 // For bridging
        case rounded = 2 // For bridging
        case monospaced = 3 // For bridging
    }
}

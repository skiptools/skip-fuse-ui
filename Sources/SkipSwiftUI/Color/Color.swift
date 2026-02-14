// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipUI

/* @frozen */ public struct Color : Hashable, CustomStringConvertible, Sendable {
    let spec: ColorSpec

    init(spec: ColorSpec) {
        self.spec = spec
    }

//    public init<T>(_ color: T) where T : Hashable, T : ShapeStyle, T.Resolved == Color.Resolved

    @available(*, unavailable)
    public func resolve(in environment: EnvironmentValues) -> Color.Resolved {
        fatalError()
    }

    @available(*, unavailable)
    public var cgColor: Any? /* CGColor? */ {
        fatalError()
    }

    public var description: String {
        return "SkipSwiftUI.Color: \(String(describing: spec))"
    }
}

struct ColorSpec : Hashable, Sendable {
    let type: ColorType
    var opacity = 1.0

    init(_ type: ColorType, opacity: Double = 1.0) {
        self.type = type
        self.opacity = opacity
    }
}

enum ColorType : Hashable {
    case accent
    case primary
    case secondary

    case red
    case orange
    case yellow
    case green
    case mint
    case teal
    case cyan
    case blue
    case indigo
    case purple
    case pink
    case brown
    case white
    case gray
    case black
    case clear

    case rgb(Double, Double, Double, Double)
    case w(Double, Double)
    case hsb(Double, Double, Double, Double)
    case named(String, Bundle?)
    indirect case saturate(ColorSpec, Double)
}

extension Color : View {
    public typealias Body = Never
}

extension Color : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return Self.Java_color(for: spec)
    }

    static func Java_color(for spec: ColorSpec) -> SkipUI.Color {
        let color = switch spec.type {
        case .accent:
            SkipUI.Color.accentColor
        case .primary:
            SkipUI.Color._primary
        case .secondary:
            SkipUI.Color._secondary
        case .red:
            SkipUI.Color._red
        case .orange:
            SkipUI.Color._orange
        case .yellow:
            SkipUI.Color._yellow
        case .green:
            SkipUI.Color._green
        case .mint:
            SkipUI.Color._mint
        case .teal:
            SkipUI.Color._teal
        case .cyan:
            SkipUI.Color._cyan
        case .blue:
            SkipUI.Color._blue
        case .indigo:
            SkipUI.Color._indigo
        case .purple:
            SkipUI.Color._purple
        case .pink:
            SkipUI.Color._pink
        case .brown:
            SkipUI.Color._brown
        case .white:
            SkipUI.Color._white
        case .gray:
            SkipUI.Color._gray
        case .black:
            SkipUI.Color._black
        case .clear:
            SkipUI.Color._clear
        case .rgb(let red, let green, let blue, let opacity):
            SkipUI.Color(red: red, green: green, blue: blue, opacity: opacity)
        case .w(let white, let opacity):
            SkipUI.Color(white: white, opacity: opacity)
        case .hsb(let hue, let saturation, let brightness, let opacity):
            SkipUI.Color(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
        case .named(let name, let bundle):
            SkipUI.Color(name: name, bridgedBundle: bundle)
        case .saturate(let spec, let multiplier):
            Java_color(for: spec).saturate(by: multiplier)
        }
        guard spec.opacity != 1.0 else {
            return color
        }
        return color.opacity(spec.opacity)
    }
}

extension Color : ShapeStyle {
}

extension Color {
    public static let accentColor = Color(spec: .init(.accent))
}

extension Color {
    @frozen public struct Resolved : Hashable, BitwiseCopyable {
        public var linearRed: Float
        public var linearGreen: Float
        public var linearBlue: Float
        public var opacity: Float
    }

    public init(_ resolved: Color.Resolved) {
        self.init(.sRGB, red: Double(resolved.linearRed) , green: Double(resolved.linearGreen), blue: Double(resolved.linearBlue))
    }
}

extension Color {
    public enum RGBColorSpace : Hashable, Sendable {
        case sRGB
        case sRGBLinear
        case displayP3
    }

    public init(_ colorSpace: Color.RGBColorSpace = .sRGB, red: Double, green: Double, blue: Double, opacity: Double = 1) {
        self.init(spec: .init(.rgb(red, green, blue, opacity)))
    }

    public init(_ colorSpace: Color.RGBColorSpace = .sRGB, white: Double, opacity: Double = 1) {
        self.init(spec: .init(.w(white, opacity)))
    }

    public init(hue: Double, saturation: Double, brightness: Double, opacity: Double = 1) {
        self.init(spec: .init(.hsb(hue, saturation, brightness, opacity)))
    }
}

extension Color {
    public var gradient: AnyGradient {
        let startColor = Color(spec: .init(.saturate(self.spec, 0.75)))
        let endColor = Color(spec: .init(.saturate(self.spec, 1.33)))
        let gradient = Gradient(colors: [startColor, endColor])
        return AnyGradient(gradient)
    }
}

extension Color {
    public static let red = Color(spec: .init(.red))
    public static let orange = Color(spec: .init(.orange))
    public static let yellow = Color(spec: .init(.yellow))
    public static let green = Color(spec: .init(.green))
    public static let mint = Color(spec: .init(.mint))
    public static let teal = Color(spec: .init(.teal))
    public static let cyan = Color(spec: .init(.cyan))
    public static let blue = Color(spec: .init(.blue))
    public static let indigo = Color(spec: .init(.indigo))
    public static let purple = Color(spec: .init(.purple))
    public static let pink = Color(spec: .init(.pink))
    public static let brown = Color(spec: .init(.brown))
    public static let white = Color(spec: .init(.white))
    public static let gray = Color(spec: .init(.gray))
    public static let black = Color(spec: .init(.black))
    public static let clear = Color(spec: .init(.clear))
    public static let primary = Color(spec: .init(.primary))
    public static let secondary = Color(spec: .init(.secondary))
}

//extension Color {
//    public init(_ cgColor: CGColor)
//}

extension Color {
    public init(cgColor: Any /* CGColor */) {
        fatalError()
    }
}

extension Color {
    public init(_ name: String, bundle: Bundle? = nil) {
        self.spec = .init(.named(name, bundle))
    }
}

//extension Color {
//    public init(_ resource: ColorResource)
//}

extension Color {
    public func opacity(_ opacity: Double) -> Color {
        var spec = self.spec
        spec.opacity *= opacity
        return Color(spec: spec)
    }

    @available(*, unavailable)
    public func mix(with rhs: Color, by fraction: Double, in colorSpace: Gradient.ColorSpace = .perceptual) -> Color {
        fatalError()
    }
}

extension Color {
    public func headroom(_ headroom: Double?) -> Color {
        return self
    }

    @available(*, unavailable)
    public func exposureAdjust(_ stops: Double) -> Color {
        fatalError()
    }
}

extension Color.Resolved : ShapeStyle {
    public func opacity(_ opacity: Double) -> Color.Resolved {
        var color = self
        color.opacity *= Float(opacity)
        return color
    }

    public var Java_view: any SkipUI.View {
        return Color(self).Java_view
    }

//    public typealias Resolved = Never
}

extension Color.Resolved : CustomStringConvertible {
    public var description: String {
        return "r\(linearRed), g\(linearGreen), b\(linearBlue), o\(opacity)"
    }
}

extension Color.Resolved : Animatable {
//    public typealias AnimatableData = AnimatablePair<Float, AnimatablePair<Float, AnimatablePair<Float, Float>>>
//    public var animatableData: Color.Resolved.AnimatableData
}

extension Color.Resolved {
    public init(colorSpace: Color.RGBColorSpace = .sRGB, red: Float, green: Float, blue: Float, opacity: Float = 1) {
        self.linearRed = red
        self.linearGreen = green
        self.linearBlue = blue
        self.opacity = opacity
    }

    public var red: Float {
        return linearRed
    }

    public var green: Float {
        return linearGreen
    }

    public var blue: Float {
        return linearBlue
    }
}

extension Color.Resolved : Codable {
}

extension Color.Resolved {
    @available(*, unavailable)
    public var cgColor: Any /* CGColor */ {
        fatalError()
    }
}

extension ShapeStyle where Self == Color {
    public static var red: Color { Color.red }
    public static var orange: Color { Color.orange }
    public static var yellow: Color { Color.yellow }
    public static var green: Color { Color.green }
    public static var mint: Color { Color.mint }
    public static var teal: Color { Color .teal }
    public static var cyan: Color { Color.cyan }
    public static var blue: Color { Color.blue }
    public static var indigo: Color { Color.indigo }
    public static var purple: Color { Color.purple }
    public static var pink: Color { Color.pink }
    public static var brown: Color { Color.brown }
    public static var white: Color { Color.white }
    public static var gray: Color { Color.gray }
    public static var black: Color { Color.black }
    public static var clear: Color { Color.clear }
}

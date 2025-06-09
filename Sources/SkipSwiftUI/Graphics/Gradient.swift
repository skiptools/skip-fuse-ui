// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

@frozen public struct Gradient : Hashable {
    @frozen public struct Stop : Hashable, Sendable {
        public var color: Color
        public var location: CGFloat
    }

    public var stops: [Gradient.Stop]

    public init(stops: [Gradient.Stop]) {
        self.stops = stops
    }

    public init(colors: [Color]) {
        if colors.isEmpty {
            self.stops = []
        } else {
            let step = colors.count == 1 ? 0.0 : 1.0 / Double(colors.count - 1)
            self.stops = colors.enumerated().map { Gradient.Stop(color: $0.1, location: step * Double($0.0)) }
        }
    }

//    public typealias Resolved = Never
}

extension Gradient {
    public struct ColorSpace : Hashable, Sendable {
        public static let device = ColorSpace()
        public static let perceptual = ColorSpace()
    }

    public func colorSpace(_ space: Gradient.ColorSpace) -> AnyGradient {
        return AnyGradient(self)
    }
}

@frozen public struct AnyGradient : Hashable, ShapeStyle, Sendable {
    let gradient: Gradient

    public init(_ gradient: Gradient) {
        self.gradient = gradient
    }

    public var Java_view: any SkipUI.View {
        return LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom).Java_view
    }

//    public typealias Resolved = Never
}

extension AnyGradient {
    public func colorSpace(_ space: Gradient.ColorSpace) -> AnyGradient {
        return self
    }
}

@MainActor @frozen @preconcurrency public struct LinearGradient : ShapeStyle, View, Sendable {
    let gradient: Gradient
    let startPoint: UnitPoint
    let endPoint: UnitPoint

    nonisolated public init(gradient: Gradient, startPoint: UnitPoint, endPoint: UnitPoint) {
        self.gradient = gradient
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    nonisolated public init(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) {
        self.init(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }

    nonisolated public init(stops: [Gradient.Stop], startPoint: UnitPoint, endPoint: UnitPoint) {
        self.init(gradient: Gradient(stops: stops), startPoint: startPoint, endPoint: endPoint)
    }

    public typealias Body = Never
//    public typealias Resolved = Never
}

extension LinearGradient : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let colors = gradient.stops.map { Color.Java_color(for: $0.color.spec) }
        let locations = gradient.stops.map(\.location)
        return SkipUI.LinearGradient(colors: colors, locations: locations, startX: startPoint.x, startY: startPoint.y, endX: endPoint.x, endY: endPoint.y)
    }
}

extension ShapeStyle where Self == LinearGradient {
    public static func linearGradient(_ gradient: Gradient, startPoint: UnitPoint, endPoint: UnitPoint) -> LinearGradient {
        return LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
    }

    public static func linearGradient(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) -> LinearGradient {
        return LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
    }

    public static func linearGradient(stops: [Gradient.Stop], startPoint: UnitPoint, endPoint: UnitPoint) -> LinearGradient {
        return LinearGradient(stops: stops, startPoint: startPoint, endPoint: endPoint)
    }
}

extension ShapeStyle where Self == LinearGradient {
    public static func linearGradient(_ gradient: AnyGradient, startPoint: UnitPoint, endPoint: UnitPoint) -> some ShapeStyle {
        return linearGradient(gradient.gradient, startPoint: startPoint, endPoint: endPoint)
    }
}

@MainActor @frozen @preconcurrency public struct RadialGradient : ShapeStyle, View, Sendable {
    let gradient: Gradient
    let center: UnitPoint
    let startRadius: CGFloat
    let endRadius: CGFloat

    nonisolated public init(gradient: Gradient, center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
        self.gradient = gradient
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
    }

    nonisolated public init(colors: [Color], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
        self.init(gradient: Gradient(colors: colors), center: center, startRadius: startRadius, endRadius: endRadius)
    }

    nonisolated public init(stops: [Gradient.Stop], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) {
        self.init(gradient: Gradient(stops: stops), center: center, startRadius: startRadius, endRadius: endRadius)
    }

    public typealias Body = Never
//    public typealias Resolved = Never
}

extension RadialGradient : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let colors = gradient.stops.map { Color.Java_color(for: $0.color.spec) }
        let locations = gradient.stops.map(\.location)
        return SkipUI.RadialGradient(colors: colors, locations: locations, centerX: center.x, centerY: center.y, startRadius: startRadius, endRadius: endRadius)
    }
}

extension ShapeStyle where Self == RadialGradient {
    public static func radialGradient(_ gradient: Gradient, center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) -> RadialGradient {
        return RadialGradient(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius)
    }

    public static func radialGradient(colors: [Color], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) -> RadialGradient {
        return RadialGradient(colors: colors, center: center, startRadius: startRadius, endRadius: endRadius)
    }

    public static func radialGradient(stops: [Gradient.Stop], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat) -> RadialGradient {
        return RadialGradient(stops: stops, center: center, startRadius: startRadius, endRadius: endRadius)
    }
}

extension ShapeStyle where Self == RadialGradient {
    public static func radialGradient(_ gradient: AnyGradient, center: UnitPoint = .center, startRadius: CGFloat = 0, endRadius: CGFloat) -> some ShapeStyle {
        return RadialGradient(gradient: gradient.gradient, center: center, startRadius: startRadius, endRadius: endRadius)
    }
}

@MainActor @frozen @preconcurrency public struct EllipticalGradient : ShapeStyle, View, Sendable {
    let gradient: Gradient
    let center: UnitPoint
    let startFraction: CGFloat
    let endFraction: CGFloat

    nonisolated public init(gradient: Gradient, center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) {
        self.gradient = gradient
        self.center = center
        self.startFraction = startRadiusFraction
        self.endFraction = endRadiusFraction
    }

    nonisolated public init(colors: [Color], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) {
        self.init(gradient: Gradient(colors: colors), center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }

    nonisolated public init(stops: [Gradient.Stop], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) {
        self.init(gradient: Gradient(stops: stops), center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }

    public typealias Body = Never
//    public typealias Resolved = Never
}

extension EllipticalGradient : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let colors = gradient.stops.map { Color.Java_color(for: $0.color.spec) }
        let locations = gradient.stops.map(\.location)
        return SkipUI.EllipticalGradient(colors: colors, locations: locations, centerX: center.x, centerY: center.y, startFraction: startFraction, endFraction: endFraction)
    }
}

extension ShapeStyle where Self == EllipticalGradient {
    public static func ellipticalGradient(_ gradient: Gradient, center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) -> EllipticalGradient {
        return EllipticalGradient(gradient: gradient, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }

    public static func ellipticalGradient(colors: [Color], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) -> EllipticalGradient {
        return EllipticalGradient(colors: colors, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }

    public static func ellipticalGradient(stops: [Gradient.Stop], center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) -> EllipticalGradient {
        return EllipticalGradient(stops: stops, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
}

extension ShapeStyle where Self == EllipticalGradient {
    public static func ellipticalGradient(_ gradient: AnyGradient, center: UnitPoint = .center, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5) -> some ShapeStyle {
        return EllipticalGradient(gradient: gradient.gradient, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
}

@MainActor @frozen @preconcurrency public struct AngularGradient : ShapeStyle, View, Sendable {
    @available(*, unavailable)
    nonisolated public init(gradient: Gradient, center: UnitPoint, startAngle: Angle = .zero, endAngle: Angle = .zero) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(colors: [Color], center: UnitPoint, startAngle: Angle, endAngle: Angle) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(stops: [Gradient.Stop], center: UnitPoint, startAngle: Angle, endAngle: Angle) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(gradient: Gradient, center: UnitPoint, angle: Angle = .zero) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(colors: [Color], center: UnitPoint, angle: Angle = .zero) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(stops: [Gradient.Stop], center: UnitPoint, angle: Angle = .zero) {
        fatalError()
    }

    public typealias Body = Never
//    public typealias Resolved = Never
}

extension AngularGradient : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        fatalError()
    }
}

@available(*, unavailable)
extension ShapeStyle where Self == AngularGradient {
    @available(*, unavailable)
    public static func angularGradient(_ gradient: Gradient, center: UnitPoint, startAngle: Angle, endAngle: Angle) -> AngularGradient {
        fatalError()
    }

    @available(*, unavailable)
    public static func angularGradient(colors: [Color], center: UnitPoint, startAngle: Angle, endAngle: Angle) -> AngularGradient {
        fatalError()
    }

    @available(*, unavailable)
    public static func angularGradient(stops: [Gradient.Stop], center: UnitPoint, startAngle: Angle, endAngle: Angle) -> AngularGradient {
        fatalError()
    }
}

@available(*, unavailable)
extension ShapeStyle where Self == AngularGradient {
    @available(*, unavailable)
    public static func conicGradient(_ gradient: Gradient, center: UnitPoint, angle: Angle = .zero) -> AngularGradient {
        fatalError()
    }

    @available(*, unavailable)
    public static func conicGradient(colors: [Color], center: UnitPoint, angle: Angle = .zero) -> AngularGradient {
        fatalError()
    }

    @available(*, unavailable)
    public static func conicGradient(stops: [Gradient.Stop], center: UnitPoint, angle: Angle = .zero) -> AngularGradient {
        fatalError()
    }
}

@available(*, unavailable)
extension ShapeStyle where Self == AngularGradient {
    @available(*, unavailable)
    public static func angularGradient(_ gradient: AnyGradient, center: UnitPoint = .center, startAngle: Angle, endAngle: Angle) -> some ShapeStyle {
        stubShapeStyle()
    }

    @available(*, unavailable)
    public static func conicGradient(_ gradient: AnyGradient, center: UnitPoint = .center, angle: Angle = .zero) -> some ShapeStyle {
        stubShapeStyle()
    }
}

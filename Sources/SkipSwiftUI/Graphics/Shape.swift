// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

public protocol Shape : Sendable, Animatable, View, SkipUIBridging /*, _RemoveGlobalActorIsolation */ where Body == Never {
    nonisolated func path(in rect: CGRect) -> Path

    nonisolated static var role: ShapeRole { get }

    nonisolated var layoutDirectionBehavior: LayoutDirectionBehavior { get }

    nonisolated func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize
}

extension Shape {
    nonisolated public var Java_view: any SkipUI.View {
        // Default implementation designed for user's custom views, which will implement a `path(in:)`
        let pathBlock: (CGFloat, CGFloat, CGFloat, CGFloat) -> SkipUI.Path = { x, y, width, height in
            let p = self.path(in: CGRect(x: x, y: y, width: width, height: height))
            return p.Java_path
        }
        return SkipUI.BridgedCustomShape(pathBlock)
    }

    nonisolated public var Java_shape: any SkipUI.Shape {
        return Java_view as? any SkipUI.Shape ?? SkipUI.Rectangle()
    }
}

func stubShape() -> Rectangle {
    return Rectangle()
}

extension Shape {
    nonisolated public static var role: ShapeRole {
        return .fill
    }

    nonisolated public var layoutDirectionBehavior: LayoutDirectionBehavior {
        return .mirrors
    }

    nonisolated public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }
}

extension Shape {
    @inlinable nonisolated public func stroke(style: StrokeStyle) -> some Shape {
        return _StrokeShape(shape: self, style: style)
    }

    @inlinable nonisolated public func stroke(lineWidth: CGFloat = 1) -> some Shape {
        return stroke(style: .init(lineWidth: lineWidth))
    }
}

@frozen public struct Rectangle : Shape {
    nonisolated public func path(in rect: CGRect) -> Path {
        return Path(rect)
    }

    @inlinable nonisolated public init() {
    }

//    public typealias AnimatableData = EmptyAnimatableData
}

extension Rectangle {
    nonisolated public var Java_view: any SkipUI.View {
        return SkipUI.Rectangle()
    }
}

extension Rectangle : InsettableShape {
    /* @inlinable */ nonisolated public func inset(by amount: CGFloat) -> some InsettableShape {
        return _InsetShape(shape: self, inset: amount)
    }
}

extension Shape where Self == Rectangle {
    nonisolated public static var rect: Rectangle {
        return Rectangle()
    }
}

@frozen public struct RoundedRectangle : Shape {
    public var cornerSize: CGSize
    public var style: RoundedCornerStyle

    @inlinable nonisolated public init(cornerSize: CGSize, style: RoundedCornerStyle = .continuous) {
        self.cornerSize = cornerSize
        self.style = style
    }

    @inlinable nonisolated public init(cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) {
        self.cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        self.style = style
    }

    nonisolated public func path(in rect: CGRect) -> Path {
        return Path(roundedRect: rect, cornerSize: cornerSize, style: style)
    }

//    public var animatableData: CGSize.AnimatableData
//    public typealias AnimatableData = CGSize.AnimatableData
}

extension RoundedRectangle {
    nonisolated public var Java_view: any SkipUI.View {
        return SkipUI.RoundedRectangle(cornerWidth: cornerSize.width, cornerHeight: cornerSize.height, bridgedStyle: style.rawValue)
    }
}

extension RoundedRectangle : InsettableShape {
    /* @inlinable */ nonisolated public func inset(by amount: CGFloat) -> some InsettableShape {
        return _InsetShape(shape: self, inset: amount)
    }
}

extension Shape where Self == RoundedRectangle {
    nonisolated public static func rect(cornerSize: CGSize, style: RoundedCornerStyle = .continuous) -> Self {
        return RoundedRectangle(cornerSize: cornerSize, style: style)
    }

    nonisolated public static func rect(cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) -> Self {
        return RoundedRectangle(cornerRadius: cornerRadius, style: style)
    }
}

@frozen public struct UnevenRoundedRectangle : Shape {
    public var cornerRadii: RectangleCornerRadii
    public var style: RoundedCornerStyle

    @inlinable nonisolated public init(cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous) {
        self.cornerRadii = cornerRadii
        self.style = style
    }

    nonisolated public init(topLeadingRadius: CGFloat = 0, bottomLeadingRadius: CGFloat = 0, bottomTrailingRadius: CGFloat = 0, topTrailingRadius: CGFloat = 0, style: RoundedCornerStyle = .continuous) {
        self.init(cornerRadii: RectangleCornerRadii(topLeading: topLeadingRadius, bottomLeading: bottomLeadingRadius, bottomTrailing: bottomTrailingRadius, topTrailing: topTrailingRadius), style: style)
    }

    nonisolated public func path(in rect: CGRect) -> Path {
        return Path(roundedRect: rect, cornerRadii: cornerRadii, style: style)
    }

//    public var animatableData: RectangleCornerRadii.AnimatableData
//    public typealias AnimatableData = RectangleCornerRadii.AnimatableData
}

extension UnevenRoundedRectangle {
    nonisolated public var Java_view: any SkipUI.View {
        return SkipUI.UnevenRoundedRectangle(topLeadingRadius: cornerRadii.topLeading, bottomLeadingRadius: cornerRadii.bottomLeading, bottomTrailingRadius: cornerRadii.bottomTrailing, topTrailingRadius: cornerRadii.topTrailing, bridgedStyle: style.rawValue)
    }
}

extension UnevenRoundedRectangle : InsettableShape {
    /* @inlinable */ nonisolated public func inset(by amount: CGFloat) -> some InsettableShape {
        return _InsetShape(shape: self, inset: amount)
    }
}

extension Shape where Self == UnevenRoundedRectangle {
    nonisolated public static func rect(cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous) -> Self {
        return UnevenRoundedRectangle(cornerRadii: cornerRadii, style: style)
    }

    nonisolated public static func rect(topLeadingRadius: CGFloat = 0, bottomLeadingRadius: CGFloat = 0, bottomTrailingRadius: CGFloat = 0, topTrailingRadius: CGFloat = 0, style: RoundedCornerStyle = .continuous) -> Self {
        return UnevenRoundedRectangle(topLeadingRadius: topLeadingRadius, bottomLeadingRadius: bottomLeadingRadius, bottomTrailingRadius: bottomTrailingRadius, topTrailingRadius: topTrailingRadius, style: style)
    }
}

@frozen public struct Capsule : Shape {
    public var style: RoundedCornerStyle

    @inlinable nonisolated public init(style: RoundedCornerStyle = .continuous) {
        self.style = style
    }

    nonisolated public func path(in rect: CGRect) -> Path {
        var path = Path()
        if rect.width >= rect.height {
            path.move(to: CGPoint(x: rect.minX + rect.height / 2.0, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - rect.height / 2.0, y: rect.minY))
            path.addRelativeArc(center: CGPoint(x: rect.maxX - rect.height / 2.0, y: rect.midY), radius: rect.height / 2.0, startAngle: Angle(degrees: -90.0), delta: Angle(degrees: 180.0))
            path.addLine(to: CGPoint(x: rect.minX + rect.height / 2.0, y: rect.maxY))
            path.addRelativeArc(center: CGPoint(x: rect.minX + rect.height / 2.0, y: rect.midY), radius: rect.height / 2.0, startAngle: Angle(degrees: 90.0), delta: Angle(degrees: 180.0))
        } else {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY + rect.width / 2.0))
            path.addRelativeArc(center: CGPoint(x: rect.midX, y: rect.minY + rect.width / 2.0), radius: rect.width / 2.0, startAngle: Angle(degrees: -180.0), delta: Angle(degrees: 180.0))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - rect.width / 2.0))
            path.addRelativeArc(center: CGPoint(x: rect.midX, y: rect.maxY - rect.width / 2.0), radius: rect.width / 2.0, startAngle: Angle(degrees: 0.0), delta: Angle(degrees: 180.0))
        }
        return path
    }

//    public typealias AnimatableData = EmptyAnimatableData
}

extension Capsule {
    nonisolated public var Java_view: any SkipUI.View {
        return SkipUI.Capsule(bridgedStyle: style.rawValue)
    }
}

extension Capsule : InsettableShape {
    /* @inlinable */ nonisolated public func inset(by amount: CGFloat) -> some InsettableShape {
        return _InsetShape(shape: self, inset: amount)
    }
}

extension Shape where Self == Capsule {
    nonisolated public static var capsule: Capsule {
        return Capsule()
    }

    nonisolated public static func capsule(style: RoundedCornerStyle) -> Self {
        return Capsule(style: style)
    }
}

@frozen public struct Ellipse : Shape, BitwiseCopyable {
    nonisolated public func path(in rect: CGRect) -> Path {
        return Path(ellipseIn: rect)
    }

    @inlinable nonisolated public init() {
    }

//    public typealias AnimatableData = EmptyAnimatableData
}

extension Ellipse {
    nonisolated public var Java_view: any SkipUI.View {
        return SkipUI.Ellipse()
    }
}

extension Ellipse : InsettableShape {
    /* @inlinable */ nonisolated public func inset(by amount: CGFloat) -> some InsettableShape {
        return _InsetShape(shape: self, inset: amount)
    }
}

extension Shape where Self == Ellipse {
    nonisolated public static var ellipse: Ellipse {
        return Ellipse()
    }
}

@frozen public struct Circle : Shape, BitwiseCopyable {
    nonisolated public func path(in rect: CGRect) -> Path {
        let dim = min(rect.width, rect.height)
        let x = rect.minX + (rect.width - dim) / 2.0
        let y = rect.minY + (rect.height - dim) / 2.0
        return Path(ellipseIn: CGRect(x: x, y: y, width: dim, height: dim))
    }

    @inlinable nonisolated public init() {
    }

//    public typealias AnimatableData = EmptyAnimatableData
}

//extension Circle {
//    nonisolated public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize
//}

extension Circle {
    nonisolated public var Java_view: any SkipUI.View {
        return SkipUI.Circle()
    }
}

extension Circle : InsettableShape {
    /* @inlinable */ nonisolated public func inset(by amount: CGFloat) -> some InsettableShape {
        return _InsetShape(shape: self, inset: amount)
    }
}

extension Shape where Self == Circle {
    nonisolated public static var circle: Circle {
        return Circle()
    }
}

@frozen public struct ContainerRelativeShape : Shape, BitwiseCopyable {
    nonisolated public func path(in rect: CGRect) -> Path {
        return Path(rect)
    }

    @available(*, unavailable)
    @inlinable nonisolated public init() {
        fatalError()
    }

//    public typealias AnimatableData = EmptyAnimatableData
}

extension ContainerRelativeShape {
    nonisolated public var Java_view: any SkipUI.View {
        return SkipUI.Rectangle()
    }
}

extension ContainerRelativeShape : InsettableShape {
    /* @inlinable */ nonisolated public func inset(by amount: CGFloat) -> some InsettableShape {
        _InsetShape(shape: self, inset: amount)
    }
}

extension Shape where Self == ContainerRelativeShape {
    @available(*, unavailable)
    nonisolated public static var containerRelative: ContainerRelativeShape {
        fatalError()
    }
}

@frozen public struct AnyShape : Shape, @unchecked Sendable {
    private let shape: any Shape

    nonisolated public init<S>(_ shape: S) where S : Shape {
        self.shape = shape
    }

    nonisolated public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect)
    }

    nonisolated public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        return shape.sizeThatFits(proposal)
    }

//    public typealias AnimatableData
//    public var animatableData: AnyShape.AnimatableData
}

extension AnyShape {
    nonisolated public var Java_view: any SkipUI.View {
        return shape.Java_view
    }
}

extension Shape {
    /* @inlinable */ nonisolated public func trim(from startFraction: CGFloat = 0, to endFraction: CGFloat = 1) -> TrimmedShape<Self> {
        return TrimmedShape(shape: self, startFraction: startFraction, endFraction: endFraction)
    }
}

extension Shape {
    @available(*, unavailable)
    nonisolated public func intersection<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape {
        stubShape()
    }

    @available(*, unavailable)
    nonisolated public func union<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape {
        stubShape()
    }

    @available(*, unavailable)
    nonisolated public func subtracting<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape {
        stubShape()
    }

    @available(*, unavailable)
    nonisolated public func symmetricDifference<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape {
        stubShape()
    }

    @available(*, unavailable)
    nonisolated public func lineIntersection<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape {
        stubShape()
    }

    @available(*, unavailable)
    nonisolated public func lineSubtraction<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape {
        stubShape()
    }
}

extension Shape {
    @available(*, unavailable)
    /* @inlinable */ nonisolated public func size(_ size: CGSize) -> some Shape {
        stubShape()
    }


    /* @inlinable */ nonisolated public func size(width: CGFloat, height: CGFloat) -> some Shape {
        stubShape()
    }
}

extension Shape {
    @available(*, unavailable)
    nonisolated public func size(_ size: CGSize, anchor: UnitPoint) -> some Shape {
        stubShape()
    }

    @available(*, unavailable)
    nonisolated public func size(width: CGFloat, height: CGFloat, anchor: UnitPoint) -> some Shape {
        stubShape()
    }
}

extension Shape {
    /* @inlinable */ public func offset(_ offset: CGSize) -> OffsetShape<Self> {
        return OffsetShape(shape: self, offset: offset)
    }

    @inlinable public func offset(_ offset: CGPoint) -> OffsetShape<Self> {
        return self.offset(CGSize(width: offset.x, height: offset.y))
    }

    @inlinable public func offset(x: CGFloat = 0, y: CGFloat = 0) -> OffsetShape<Self> {
        return offset(CGSize(width: x, height: y))
    }

    @inlinable public func scale(x: CGFloat = 1, y: CGFloat = 1, anchor: UnitPoint = .center) -> ScaledShape<Self> {
        return ScaledShape(shape: self, scale: CGSize(width: x, height: y))
    }

    @inlinable public func scale(_ scale: CGFloat, anchor: UnitPoint = .center) -> ScaledShape<Self> {
        return self.scale(x: scale, y: scale, anchor: anchor)
    }

    @inlinable public func rotation(_ angle: Angle, anchor: UnitPoint = .center) -> RotatedShape<Self> {
        return RotatedShape(shape: self, angle: angle, anchor: anchor)
    }

    @available(*, unavailable)
    @inlinable public func transform(_ transform: CGAffineTransform) -> TransformedShape<Self> {
        fatalError()
    }
}

// These overloads cause ambiguous call errors on Android
//extension Shape {
//    @inlinable nonisolated public func fill<S>(_ content: S, style: FillStyle = FillStyle()) -> some View where S : ShapeStyle
//    @inlinable nonisolated public func fill(style: FillStyle = FillStyle()) -> some View
//    @inlinable nonisolated public func stroke<S>(_ content: S, style: StrokeStyle) -> some View where S : ShapeStyle
//    @inlinable nonisolated public func stroke<S>(_ content: S, lineWidth: CGFloat = 1) -> some View where S : ShapeStyle
//}

//extension Shape {
//    public var body: _ShapeView<Self, ForegroundStyle> { get }
//}

extension Shape {
    nonisolated public func fill<S>(_ content: S = .foreground, style: FillStyle = FillStyle()) -> _ShapeView<Self, S> where S : ShapeStyle {
        return _ShapeView(shape: self, style: content, fillStyle: style)
    }

    nonisolated public func stroke<S>(_ content: S, style: StrokeStyle, antialiased: Bool = true) -> StrokeShapeView<Self, S, EmptyView> where S : ShapeStyle {
        return StrokeShapeView(shape: self, style: content, strokeStyle: style, isAntialiased: antialiased, background: EmptyView())
    }

    nonisolated public func stroke<S>(_ content: S, lineWidth: CGFloat = 1, antialiased: Bool = true) -> StrokeShapeView<Self, S, EmptyView> where S : ShapeStyle {
        return stroke(content, style: .init(lineWidth: lineWidth), antialiased: antialiased)
    }
}

public enum ShapeRole : Hashable, Sendable {
    case fill
    case stroke
    case separator
}

public protocol InsettableShape : Shape {
    associatedtype InsetShape : InsettableShape

    nonisolated func inset(by amount: CGFloat) -> Self.InsetShape
}

extension InsettableShape {
    @inlinable public func strokeBorder<S>(_ content: S, style: StrokeStyle, antialiased: Bool = true) -> some View where S : ShapeStyle {
        return StrokeBorderShapeView(shape: self, style: content, strokeStyle: style, isAntialiased: antialiased, background: EmptyView())
    }

    @inlinable public func strokeBorder(style: StrokeStyle, antialiased: Bool = true) -> some View {
        return strokeBorder(.foreground, style: style, antialiased: antialiased)
    }

    @inlinable public func strokeBorder<S>(_ content: S, lineWidth: CGFloat = 1, antialiased: Bool = true) -> some View where S : ShapeStyle {
        return strokeBorder(content, style: .init(lineWidth: lineWidth), antialiased: antialiased)
    }

    @inlinable public func strokeBorder(lineWidth: CGFloat = 1, antialiased: Bool = true) -> some View {
        return strokeBorder(.foreground, style: .init(lineWidth: lineWidth), antialiased: antialiased)
    }
}

extension InsettableShape {
    nonisolated public func strokeBorder<S>(_ content: S = .foreground, style: StrokeStyle, antialiased: Bool = true) -> StrokeBorderShapeView<Self, S, EmptyView> where S : ShapeStyle {
        return StrokeBorderShapeView(shape: self, style: content, strokeStyle: style, isAntialiased: antialiased, background: EmptyView())
    }

    nonisolated public func strokeBorder<S>(_ content: S = .foreground, lineWidth: CGFloat = 1, antialiased: Bool = true) -> StrokeBorderShapeView<Self, S, EmptyView> where S : ShapeStyle {
        return strokeBorder(content, style: .init(lineWidth: lineWidth), antialiased: antialiased)
    }
}

@frozen public struct OffsetShape<Content> : Shape where Content : Shape {
    public var shape: Content
    public var offset: CGSize

    @inlinable nonisolated public init(shape: Content, offset: CGSize) {
        self.shape = shape
        self.offset = offset
    }

    nonisolated public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect).offsetBy(dx: offset.width, dy: offset.height)
    }

    nonisolated public static var role: ShapeRole {
        return Content.role
    }

    nonisolated public var layoutDirectionBehavior: LayoutDirectionBehavior {
        return shape.layoutDirectionBehavior
    }

//    public typealias AnimatableData = AnimatablePair<Content.AnimatableData, CGSize.AnimatableData>
//    public var animatableData: OffsetShape<Content>.AnimatableData
}

extension OffsetShape : InsettableShape where Content : InsettableShape {
    @inlinable nonisolated public func inset(by amount: CGFloat) -> OffsetShape<Content.InsetShape> {
        return OffsetShape<Content.InsetShape>(shape: shape.inset(by: amount), offset: offset)
    }
}

extension OffsetShape {
    nonisolated public var Java_view: any SkipUI.View {
        return shape.Java_shape.offset(x: offset.width, y: offset.height)
    }
}

@frozen public struct ScaledShape<Content> : Shape where Content : Shape {
    public var shape: Content
    public var scale: CGSize
    public var anchor: UnitPoint

    @inlinable nonisolated public init(shape: Content, scale: CGSize, anchor: UnitPoint = .center) {
        self.shape = shape
        self.scale = scale
        self.anchor = anchor
    }

    nonisolated public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect).applying(.init(scaleX: scale.width, y: scale.height))
    }

    nonisolated public static var role: ShapeRole {
        return Content.role
    }

    nonisolated public var layoutDirectionBehavior: LayoutDirectionBehavior {
        return shape.layoutDirectionBehavior
    }

//    public typealias AnimatableData = AnimatablePair<Content.AnimatableData, AnimatablePair<CGSize.AnimatableData, UnitPoint.AnimatableData>>
//    public var animatableData: ScaledShape<Content>.AnimatableData
}

extension ScaledShape {
    nonisolated public var Java_view: any SkipUI.View {
        return shape.Java_shape.scale(width: scale.width, height: scale.height, anchorX: anchor.x, anchorY: anchor.y)
    }
}

@frozen public struct RotatedShape<Content> : Shape where Content : Shape {
    public var shape: Content
    public var angle: Angle
    public var anchor: UnitPoint

    @inlinable nonisolated public init(shape: Content, angle: Angle, anchor: UnitPoint = .center) {
        self.shape = shape
        self.angle = angle
        self.anchor = anchor
    }

    nonisolated public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect).applying(.init(rotationAngle: CGFloat(angle.radians)))
    }

    nonisolated public static var role: ShapeRole {
        return Content.role
    }

    nonisolated public var layoutDirectionBehavior: LayoutDirectionBehavior {
        return shape.layoutDirectionBehavior
    }

//    public typealias AnimatableData = AnimatablePair<Content.AnimatableData, AnimatablePair<Angle.AnimatableData, UnitPoint.AnimatableData>>
//    public var animatableData: RotatedShape<Content>.AnimatableData
}

extension RotatedShape : InsettableShape where Content : InsettableShape {
    @inlinable nonisolated public func inset(by amount: CGFloat) -> RotatedShape<Content.InsetShape> {
        return RotatedShape<Content.InsetShape>(shape: shape.inset(by: amount), angle: angle, anchor: anchor)
    }
}

extension RotatedShape {
    nonisolated public var Java_view: any SkipUI.View {
        return shape.Java_shape.rotation(bridgedAngle: angle.radians, anchorX: anchor.x, anchorY: anchor.y)
    }
}

@frozen public struct TransformedShape<Content> : Shape where Content : Shape {
    public var shape: Content
    public var transform: CGAffineTransform

    @available(*, unavailable)
    @inlinable nonisolated public init(shape: Content, transform: CGAffineTransform) {
        self.shape = shape
        self.transform = transform
    }

    nonisolated public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect).applying(transform)
    }

    nonisolated public static var role: ShapeRole {
        return Content.role
    }

    nonisolated public var layoutDirectionBehavior: LayoutDirectionBehavior {
        return shape.layoutDirectionBehavior
    }

//    public typealias AnimatableData = Content.AnimatableData
//    public var animatableData: TransformedShape<Content>.AnimatableData
}

extension TransformedShape {
    nonisolated public var Java_view: any SkipUI.View {
        return shape.Java_view
    }
}

@frozen public struct TrimmedShape<Content> : Shape where Content : Shape {
    public var shape: Content
    public var startFraction: CGFloat
    public var endFraction: CGFloat

    @inlinable nonisolated public init(shape: Content, startFraction: CGFloat, endFraction: CGFloat) {
        self.shape = shape
        self.startFraction = startFraction
        self.endFraction = endFraction
    }

    nonisolated public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect)
    }

    nonisolated public static var role: ShapeRole {
        return Content.role
    }

    nonisolated public var layoutDirectionBehavior: LayoutDirectionBehavior {
        return shape.layoutDirectionBehavior
    }
}

extension TrimmedShape {
    nonisolated public var Java_view: any SkipUI.View {
        return shape.Java_shape.trim(from: startFraction, to: endFraction)
    }
}

public struct _InsetShape<Content> : InsettableShape where Content : InsettableShape {
    public let shape: Content
    public let inset: CGFloat

    nonisolated public init(shape: Content, inset: CGFloat) {
        self.shape = shape
        self.inset = inset
    }

    public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect)
    }

    nonisolated public static var role: ShapeRole {
        return Content.role
    }

    nonisolated public var layoutDirectionBehavior: LayoutDirectionBehavior {
        return shape.layoutDirectionBehavior
    }

//    public typealias AnimatableData = AnimatablePair<Content.AnimatableData, AnimatablePair<Angle.AnimatableData, UnitPoint.AnimatableData>>
//    public var animatableData: RotatedShape<Content>.AnimatableData
}

extension _InsetShape {
    @inlinable nonisolated public func inset(by amount: CGFloat) -> _InsetShape<Content> {
        return _InsetShape<Content>(shape: shape, inset: inset + amount)
    }
}

extension _InsetShape {
    nonisolated public var Java_view: any SkipUI.View {
        return shape.Java_shape.inset(by: inset)
    }
}

public struct _StrokeShape<Content> : Shape where Content : Shape {
    public let shape: Content
    public let style: StrokeStyle

    nonisolated public init(shape: Content, style: StrokeStyle) {
        self.shape = shape
        self.style = style
    }

    nonisolated public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect)
    }

    nonisolated public static var role: ShapeRole {
        return Content.role
    }

    nonisolated public var layoutDirectionBehavior: LayoutDirectionBehavior {
        return shape.layoutDirectionBehavior
    }

//    public typealias AnimatableData = AnimatablePair<Content.AnimatableData, AnimatablePair<Angle.AnimatableData, UnitPoint.AnimatableData>>
//    public var animatableData: RotatedShape<Content>.AnimatableData
}

extension _StrokeShape : InsettableShape where Content : InsettableShape {
    @inlinable nonisolated public func inset(by amount: CGFloat) -> _StrokeShape<Content.InsetShape> {
        return _StrokeShape<Content.InsetShape>(shape: shape.inset(by: amount), style: style)
    }
}

extension _StrokeShape {
    nonisolated public var Java_view: any SkipUI.View {
        return shape.Java_shape.stroke(ForegroundStyle().Java_view as? any SkipUI.ShapeStyle ?? SkipUI.ForegroundStyle(), lineWidth: style.lineWidth, bridgedLineCap: Int(style.lineCap.rawValue), bridgedLineJoin: Int(style.lineJoin.rawValue), miterLmit: style.miterLimit, dash: style.dash, dashPhase: style.dashPhase, antialiased: true)
    }
}

public protocol ShapeView<Content> : View {
    associatedtype Content : Shape

    nonisolated /* Added nonisolated */ var shape: Self.Content { get }
}

extension ShapeView {
    nonisolated public func fill<S>(_ content: S = .foreground, style: FillStyle = FillStyle()) -> FillShapeView<Self.Content, S, Self> where S : ShapeStyle {
        return FillShapeView(shape: shape, style: content, fillStyle: style, background: self)
    }

    nonisolated public func stroke<S>(_ content: S, style: StrokeStyle, antialiased: Bool = true) -> StrokeShapeView<Self.Content, S, Self> where S : ShapeStyle {
        return StrokeShapeView(shape: shape, style: content, strokeStyle: style, isAntialiased: antialiased, background: self)
    }

    nonisolated public func stroke<S>(_ content: S, lineWidth: CGFloat = 1, antialiased: Bool = true) -> StrokeShapeView<Self.Content, S, Self> where S : ShapeStyle {
        return stroke(content, style: .init(lineWidth: lineWidth), antialiased: antialiased)
    }

    nonisolated public var Java_shape: any SkipUI.Shape {
        return (self as? SkipUIBridging)?.Java_view as? any SkipUI.Shape ?? SkipUI.Rectangle()
    }
}

extension ShapeView where Self.Content : InsettableShape {
    nonisolated public func strokeBorder<S>(_ content: S = .foreground, style: StrokeStyle, antialiased: Bool = true) -> StrokeBorderShapeView<Self.Content, S, Self> where S : ShapeStyle {
        return StrokeBorderShapeView(shape: shape, style: content, strokeStyle: style, isAntialiased: antialiased, background: self)
    }

    nonisolated public func strokeBorder<S>(_ content: S = .foreground, lineWidth: CGFloat = 1, antialiased: Bool = true) -> StrokeBorderShapeView<Self.Content, S, Self> where S : ShapeStyle {
        return strokeBorder(content, style: .init(lineWidth: lineWidth), antialiased: antialiased)
    }
}

public struct _ShapeView<Content, Style> : ShapeView where Content : Shape, Style : ShapeStyle {
    public var shape: Content
    public var style: Style
    public var fillStyle: FillStyle

    nonisolated public init(shape: Content, style: Style, fillStyle: FillStyle) {
        self.shape = shape
        self.style = style
        self.fillStyle = fillStyle
    }

    public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect)
    }

    public static var role: ShapeRole {
        return Content.role
    }

    public var layoutDirectionBehavior: LayoutDirectionBehavior {
        return shape.layoutDirectionBehavior
    }

    nonisolated public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        return shape.sizeThatFits(proposal)
    }
}

extension _ShapeView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return shape.Java_shape.fill(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.ForegroundStyle(), eoFill: fillStyle.isEOFilled, antialiased: fillStyle.isAntialiased)
    }
}

@frozen public struct FillShapeView<Content, Style, Background> where Content : Shape, Style : ShapeStyle, Background : View {
    public var shape: Content
    public var style: Style
    public var fillStyle: FillStyle
    public var background: Background

    public init(shape: Content, style: Style, fillStyle: FillStyle, background: Background) {
        self.shape = shape
        self.style = style
        self.fillStyle = fillStyle
        self.background = background
    }

    public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect)
    }

    public static var role: ShapeRole {
        return Content.role
    }

    public var layoutDirectionBehavior: LayoutDirectionBehavior {
        return shape.layoutDirectionBehavior
    }

    public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        return shape.sizeThatFits(proposal)
    }
}

extension FillShapeView : ShapeView {
}

extension FillShapeView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        // If this view is produced by another shape view, it will be captured in `background`. Maybe the official SwiftUI
        // implementation applies it as a background, but we instead need to build on its shape in order to support e.g.
        // fill + stroke or multiple strokes
        return ((background as? any ShapeView)?.Java_shape ?? shape.Java_shape).fill(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.ForegroundStyle(), eoFill: fillStyle.isEOFilled, antialiased: fillStyle.isAntialiased)
    }
}

@frozen public struct StrokeShapeView<Content, Style, Background> where Content : Shape, Style : ShapeStyle, Background : View {
    public var shape: Content
    public var style: Style
    public var strokeStyle: StrokeStyle
    public var isAntialiased: Bool
    public var background: Background

    public init(shape: Content, style: Style, strokeStyle: StrokeStyle, isAntialiased: Bool, background: Background) {
        self.shape = shape
        self.style = style
        self.strokeStyle = strokeStyle
        self.isAntialiased = isAntialiased
        self.background = background
    }

    public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect)
    }

    public static var role: ShapeRole {
        return Content.role
    }

    public var layoutDirectionBehavior: LayoutDirectionBehavior {
        return shape.layoutDirectionBehavior
    }

    public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        return shape.sizeThatFits(proposal)
    }
}

extension StrokeShapeView : ShapeView {
}

extension StrokeShapeView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        // If this view is produced by another shape view, it will be captured in `background`. Maybe the official SwiftUI
        // implementation applies it as a background, but we instead need to build on its shape in order to support e.g.
        // fill + stroke or multiple strokes
        return ((background as? any ShapeView)?.Java_shape ?? shape.Java_shape).stroke(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.ForegroundStyle(), lineWidth: strokeStyle.lineWidth, bridgedLineCap: Int(strokeStyle.lineCap.rawValue), bridgedLineJoin: Int(strokeStyle.lineJoin.rawValue), miterLmit: strokeStyle.miterLimit, dash: strokeStyle.dash, dashPhase: strokeStyle.dashPhase, antialiased: isAntialiased)
    }
}

@frozen public struct StrokeBorderShapeView<Content, Style, Background> where Content : InsettableShape, Style : ShapeStyle, Background : View {
    public var shape: Content
    public var style: Style
    public var strokeStyle: StrokeStyle
    public var isAntialiased: Bool
    public var background: Background

    public init(shape: Content, style: Style, strokeStyle: StrokeStyle, isAntialiased: Bool, background: Background) {
        self.shape = shape
        self.style = style
        self.strokeStyle = strokeStyle
        self.isAntialiased = isAntialiased
        self.background = background
    }
}

extension StrokeBorderShapeView : View {
}

extension StrokeBorderShapeView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        // If this view is produced by another shape view, it will be captured in `background`. Maybe the official SwiftUI
        // implementation applies it as a background, but we instead need to build on its shape in order to support e.g.
        // fill + stroke or multiple strokes
        return ((background as? any ShapeView)?.Java_shape ?? shape.Java_shape).strokeBorder(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.ForegroundStyle(), lineWidth: strokeStyle.lineWidth, bridgedLineCap: Int(strokeStyle.lineCap.rawValue), bridgedLineJoin: Int(strokeStyle.lineJoin.rawValue), miterLmit: strokeStyle.miterLimit, dash: strokeStyle.dash, dashPhase: strokeStyle.dashPhase, antialiased: isAntialiased)
    }
}

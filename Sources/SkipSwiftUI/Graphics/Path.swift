// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

/* @frozen */ public struct Path : Equatable /*, LosslessStringConvertible, @unchecked Sendable */ {
    private var steps: [PathStep] = []

    public init() {
    }

//    public init(_ path: CGPath)
//
//    public init(_ path: CGMutablePath)

    public init(_ rect: CGRect) {
        addRect(rect)
    }

    public init(roundedRect rect: CGRect, cornerSize: CGSize, style: RoundedCornerStyle = .continuous) {
        addRoundedRect(in: rect, cornerSize: cornerSize, style: style)
    }

    public init(roundedRect rect: CGRect, cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) {
        addRoundedRect(in: rect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius), style: style)
    }

    public init(roundedRect rect: CGRect, cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous) {
        addRoundedRect(in: rect, cornerRadii: cornerRadii, style: style)
    }

    public init(ellipseIn rect: CGRect) {
        addEllipse(in: rect)
    }

    public init(_ callback: (inout Path) -> ()) {
        callback(&self)
    }

    @available(*, unavailable)
    public init?(_ string: String) {
        fatalError()
    }

    public var description: String {
        return "Path"
    }

    @available(*, unavailable)
    public var cgPath: Any /* CGPath */ {
        fatalError()
    }

    public var isEmpty: Bool {
        return steps.isEmpty
    }

    public var boundingRect: CGRect {
        let (x, y, width, height) = Java_path.bridgedBoundingRect
        return CGRect(x: x, y: y, width: width, height: height)
    }

    public func contains(_ p: CGPoint, eoFill: Bool = false) -> Bool {
        return Java_path.contains(x: p.x, y: p.y, eoFill: eoFill)
    }

    @frozen public enum Element : Equatable {
        case move(to: CGPoint)
        case line(to: CGPoint)
        case quadCurve(to: CGPoint, control: CGPoint)
        case curve(to: CGPoint, control1: CGPoint, control2: CGPoint)
        case closeSubpath
    }

    @available(*, unavailable)
    public func forEach(_ body: (Path.Element) -> Void) {
        fatalError()
    }

    @available(*, unavailable)
    public func strokedPath(_ style: StrokeStyle) -> Path {
        fatalError()
    }

    @available(*, unavailable)
    public func trimmedPath(from: CGFloat, to: CGFloat) -> Path {
        fatalError()
    }
}

extension Path : Shape {
    /* nonisolated */ public func path(in _: CGRect) -> Path {
        return self
    }

//    public typealias AnimatableData = EmptyAnimatableData

    public var Java_view: any SkipUI.View {
        return Java_path
    }

    var Java_path: SkipUI.Path {
        var path = SkipUI.Path()
        steps.forEach { $0.apply(to: &path) }
        return path
    }
}

enum PathStep : Equatable {
    case move(CGPoint)
    case line(CGPoint)
    case quadCurve(CGPoint, CGPoint)
    case curve(CGPoint, CGPoint, CGPoint)
    case closeSubpath
    case rect(CGRect, CGAffineTransform)
    case roundedRect(CGRect, CGSize, RoundedCornerStyle, CGAffineTransform)
    case unevenRoundedRect(CGRect, RectangleCornerRadii, RoundedCornerStyle, CGAffineTransform)
    case ellipse(CGRect, CGAffineTransform)
    case relativeArc(CGPoint, CGFloat, Angle, Angle, CGAffineTransform)
    case arc(CGPoint, CGFloat, Angle, Angle, Bool, CGAffineTransform)
    case path(Path, CGAffineTransform)
    case intersection(Path, Bool)
    case union(Path, Bool)
    case subtracting(Path, Bool)
    case symmetricDifference(Path, Bool)
    case applying(CGAffineTransform)
    case offsetBy(CGFloat, CGFloat)

    func apply(to Java_path: inout SkipUI.Path) {
        switch self {
        case .move(let end):
            Java_path.move(toX: end.x, y: end.y)
        case .line(let end):
            Java_path.addLine(toX: end.x, y: end.y)
        case .quadCurve(let end, let control):
            Java_path.addQuadCurve(toX: end.x, y: end.y, controlX: control.x, controlY: control.y)
        case .curve(let end, let control1, let control2):
            Java_path.addCurve(toX: end.x, y: end.y, control1X: control1.x, control1Y: control1.y, control2X: control2.x, control2Y: control2.y)
        case .closeSubpath:
            Java_path.closeSubpath()
        case .rect(let rect, let transform):
            Java_path.addRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height, a: transform.a, b: transform.b, c: transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
        case .roundedRect(let rect, let cornerSize, let style, let transform):
            Java_path.addRoundedRect(inX: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height, cornerWidth: cornerSize.width, cornerHeight: cornerSize.height, bridgedCornerStyle: style.rawValue, a: transform.a, b: transform.b, c: transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
        case .unevenRoundedRect(let rect, let cornerRadii, let style, let transform):
            Java_path.addRoundedRect(inX: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height, topLeading: cornerRadii.topLeading, bottomLeading: cornerRadii.bottomLeading, bottomTrailing: cornerRadii.bottomTrailing, topTrailing: cornerRadii.topTrailing, bridgedCornerStyle: style.rawValue, a: transform.a, b: transform.b, c: transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
        case .ellipse(let rect, let transform):
            Java_path.addEllipse(inX: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height, a: transform.a, b: transform.b, c: transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
        case .relativeArc(let center, let radius, let startAngle, let delta, let transform):
            Java_path.addRelativeArc(centerX: center.x, y: center.y, radius: radius, startAngle: startAngle.radians, delta: delta.radians, a: transform.a, b: transform.b, c: transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
        case .arc(let center, let radius, let startAngle, let endAngle, let clockwise, let transform):
            Java_path.addArc(centerX: center.x, y: center.y, radius: radius, startAngle: startAngle.radians, endAngle: endAngle.radians, clockwise: clockwise, a: transform.a, b: transform.b, c: transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
        case .path(let path, let transform):
            Java_path.addPath(path.Java_path, a: transform.a, b: transform.b, c: transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
        case .intersection(let other, let eoFill):
            Java_path = Java_path.intersection(other.Java_path, eoFill: eoFill)
        case .union(let other, let eoFill):
            Java_path = Java_path.union(other.Java_path, eoFill: eoFill)
        case .subtracting(let other, let eoFill):
            Java_path = Java_path.subtracting(other.Java_path, eoFill: eoFill)
        case .symmetricDifference(let other, let eoFill):
            Java_path = Java_path.symmetricDifference(other.Java_path, eoFill: eoFill)
        case .applying(let transform):
            Java_path = Java_path.applying(a: transform.a, b: transform.b, c: transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
        case .offsetBy(let dx, let dy):
            Java_path = Java_path.offsetBy(dx: dx, dy: dy)
        }
    }
}

extension Path /* : BitwiseCopyable, Sendable */ {
    public mutating func move(to end: CGPoint) {
        steps.append(.move(end))
    }

    public mutating func addLine(to end: CGPoint) {
        steps.append(.line(end))
    }

    public mutating func addQuadCurve(to end: CGPoint, control: CGPoint) {
        steps.append(.quadCurve(end, control))
    }

    public mutating func addCurve(to end: CGPoint, control1: CGPoint, control2: CGPoint) {
        steps.append(.curve(end, control1, control2))
    }

    public mutating func closeSubpath() {
        steps.append(.closeSubpath)
    }

    public mutating func addRect(_ rect: CGRect, transform: CGAffineTransform = .identity) {
        steps.append(.rect(rect, transform))
    }

    public mutating func addRoundedRect(in rect: CGRect, cornerSize: CGSize, style: RoundedCornerStyle = .continuous, transform: CGAffineTransform = .identity) {
        steps.append(.roundedRect(rect, cornerSize, style, transform))
    }

    public mutating func addRoundedRect(in rect: CGRect, cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous, transform: CGAffineTransform = .identity) {
        steps.append(.unevenRoundedRect(rect, cornerRadii, style, transform))
    }

    public mutating func addEllipse(in rect: CGRect, transform: CGAffineTransform = .identity) {
        steps.append(.ellipse(rect, transform))
    }

    public mutating func addRects(_ rects: [CGRect], transform: CGAffineTransform = .identity) {
        rects.forEach { addRect($0) }
    }

    public mutating func addLines(_ lines: [CGPoint]) {
        if let first = lines.first {
            move(to: first)
        }
        for i in 1..<lines.count {
            addLine(to: lines[i])
        }
    }

    public mutating func addRelativeArc(center: CGPoint, radius: CGFloat, startAngle: Angle, delta: Angle, transform: CGAffineTransform = .identity) {
        steps.append(.relativeArc(center, radius, startAngle, delta, transform))
    }

    public mutating func addArc(center: CGPoint, radius: CGFloat, startAngle: Angle, endAngle: Angle, clockwise: Bool, transform: CGAffineTransform = .identity) {
        steps.append(.arc(center, radius, startAngle, endAngle, clockwise, transform))
    }

    @available(*, unavailable)
    public mutating func addArc(tangent1End: CGPoint, tangent2End: CGPoint, radius: CGFloat, transform: CGAffineTransform = .identity) {
        fatalError()
    }

    public mutating func addPath(_ path: Path, transform: CGAffineTransform = .identity) {
        steps.append(.path(path, transform))
    }

    @available(*, unavailable)
    public var currentPoint: CGPoint? {
        fatalError()
    }

    @available(*, unavailable)
    public func normalized(eoFill: Bool = true) -> Path {
        fatalError()
    }

    public func intersection(_ other: Path, eoFill: Bool = false) -> Path {
        var path = self
        path.steps.append(.intersection(other, eoFill))
        return path
    }

    public func union(_ other: Path, eoFill: Bool = false) -> Path {
        var path = self
        path.steps.append(.union(other, eoFill))
        return path
    }

    public func subtracting(_ other: Path, eoFill: Bool = false) -> Path {
        var path = self
        path.steps.append(.subtracting(other, eoFill))
        return path
    }

    public func symmetricDifference(_ other: Path, eoFill: Bool = false) -> Path {
        var path = self
        path.steps.append(.symmetricDifference(other, eoFill))
        return path
    }

    @available(*, unavailable)
    public func lineIntersection(_ other: Path, eoFill: Bool = false) -> Path {
        fatalError()
    }

    @available(*, unavailable)
    public func lineSubtraction(_ other: Path, eoFill: Bool = false) -> Path {
        fatalError()
    }

    public func applying(_ transform: CGAffineTransform) -> Path {
        var path = self
        path.steps.append(.applying(transform))
        return path
    }

    public func offsetBy(dx: CGFloat, dy: CGFloat) -> Path {
        var path = self
        path.steps.append(.offsetBy(dx, dy))
        return path
    }
}

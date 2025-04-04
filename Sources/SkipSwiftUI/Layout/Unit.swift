// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif

public struct UnitCurve : Hashable /*, Sendable */ {
    let startControlPoint: UnitPoint
    let endControlPoint: UnitPoint

    public static func bezier(startControlPoint: UnitPoint, endControlPoint: UnitPoint) -> UnitCurve {
        return UnitCurve(startControlPoint: startControlPoint, endControlPoint: endControlPoint)
    }

    @available(*, unavailable)
    public func value(at progress: Double) -> Double {
        fatalError()
    }

    @available(*, unavailable)
    public func velocity(at progress: Double) -> Double {
        fatalError()
    }

    public var inverse: UnitCurve {
        return UnitCurve(startControlPoint: UnitPoint(x: startControlPoint.y, y: startControlPoint.x), endControlPoint: UnitPoint(x: endControlPoint.y, y: endControlPoint.x))
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(startControlPoint)
        hasher.combine(endControlPoint)
    }

    public static func ==(lhs: UnitCurve, rhs: UnitCurve) -> Bool {
        return lhs.startControlPoint == rhs.startControlPoint && lhs.endControlPoint == rhs.endControlPoint
    }
}

extension UnitCurve {
    public static let easeInEaseOut = UnitCurve(startControlPoint: UnitPoint(x: 0.42, y: 0), endControlPoint: UnitPoint(x: 0.58, y: 1))

    public static let easeInOut = UnitCurve(startControlPoint: UnitPoint(x: 0.42, y: 0), endControlPoint: UnitPoint(x: 0.58, y: 1))

    public static let easeIn = UnitCurve(startControlPoint: UnitPoint(x: 0.42, y: 0), endControlPoint: UnitPoint(x: 1, y: 1))

    public static let easeOut = UnitCurve(startControlPoint: UnitPoint(x: 0, y: 0), endControlPoint: UnitPoint(x: 0.58, y: 1))

    @available(*, unavailable)
    public static let circularEaseIn = UnitCurve(startControlPoint: UnitPoint(x: 0, y: 0), endControlPoint: UnitPoint(x: 0, y: 0))

    @available(*, unavailable)
    public static let circularEaseOut = UnitCurve(startControlPoint: UnitPoint(x: 0, y: 0), endControlPoint: UnitPoint(x: 0, y: 0))

    @available(*, unavailable)
    public static let circularEaseInOut = UnitCurve(startControlPoint: UnitPoint(x: 0, y: 0), endControlPoint: UnitPoint(x: 0, y: 0))

    public static let linear = UnitCurve(startControlPoint: UnitPoint(x: 0, y: 0), endControlPoint: UnitPoint(x: 1, y: 1))
}

@frozen public struct UnitPoint : Hashable /*, BitwiseCopyable, Sendable */ {
    public var x: CGFloat
    public var y: CGFloat

    @inlinable public init() {
        self.init(x: 0, y: 0)
    }

    @inlinable public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }

    public static let zero = UnitPoint(x: 0.0, y: 0.0)
    public static let center = UnitPoint(x: 0.5, y: 0.5)
    public static let leading = UnitPoint(x: 0.0, y: 0.5)
    public static let trailing = UnitPoint(x: 1.0, y: 0.5)
    public static let top = UnitPoint(x: 0.5, y: 0.0)
    public static let bottom = UnitPoint(x: 0.5, y: 1.0)
    public static let topLeading = UnitPoint(x: 0.0, y: 0.0)
    public static let topTrailing = UnitPoint(x: 1.0, y: 0.0)
    public static let bottomLeading = UnitPoint(x: 0.0, y: 1.0)
    public static let bottomTrailing = UnitPoint(x: 1.0, y: 1.0)
}

extension UnitPoint : Animatable {
//    public typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>
//    public var animatableData: UnitPoint.AnimatableData
}

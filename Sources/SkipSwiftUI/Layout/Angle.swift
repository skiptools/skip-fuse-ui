// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@frozen public struct Angle /* : BitwiseCopyable, Sendable */ {
    @inlinable public static var zero: Angle {
        return Angle()
    }

    public var radians: Double

    /* @inlinable */ public var degrees: Double {
        get {
            return Self.radiansToDegrees(radians)
        }
        set {
            radians = Self.degreesToRadians(newValue)
        }
    }

    @inlinable public init() {
        self.radians = 0.0
    }

    @inlinable public init(radians: Double) {
        self.radians = radians
    }

    public init(degrees: Double) {
        self.radians = Self.degreesToRadians(degrees)
    }

    @inlinable public static func radians(_ radians: Double) -> Angle {
        return Angle(radians: radians)
    }

    @inlinable public static func degrees(_ degrees: Double) -> Angle {
        return Angle(degrees: degrees)
    }

    private static func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180 / Double.pi
    }

    private static func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }
}

extension Angle : Hashable, Comparable {
    @inlinable public static func < (lhs: Angle, rhs: Angle) -> Bool {
        return lhs.radians < rhs.radians
    }
}

extension Angle : Animatable {
//    public var animatableData: Double
//    public typealias AnimatableData = Double
}

// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipUI

public struct Spring : Hashable /*, Sendable */ {
    private let spec: SpringSpec
}

enum SpringSpec : Hashable {
    case duration(TimeInterval, Double)
    case response(Double, Double)
    case mass(Double, Double, Double, Bool)
    case settlingDuration(TimeInterval, Double, Double)
    case smooth
    case smoothDuration(TimeInterval, Double)
    case snappy
    case snappyDuration(TimeInterval, Double)
    case bouncy
    case bouncyDuration(TimeInterval, Double)
}

extension Spring {
    var Java_spring: SkipUI.Spring {
        switch spec {
        case .duration(let duration, let bounce):
            return SkipUI.Spring(duration: duration, bounce: bounce)
        case .response(let response, let dampingRatio):
            return SkipUI.Spring(response: response, dampingRatio: dampingRatio)
        case .mass(let mass, let stiffness, let damping, let allowOverDamping):
            return SkipUI.Spring(mass: mass, stiffness: stiffness, damping: damping, allowOverDamping: allowOverDamping)
        case .settlingDuration(let settlingDuration, let dampingRatio, let epsilon):
            return SkipUI.Spring(settlingDuration: settlingDuration, dampingRatio: dampingRatio, epsilon: epsilon)
        case .smooth:
            return SkipUI.Spring.smooth
        case .smoothDuration(let duration, let extraBounce):
            return SkipUI.Spring.smooth(duration: duration, extraBounce: extraBounce)
        case .snappy:
            return SkipUI.Spring.snappy
        case .snappyDuration(let duration, let extraBounce):
            return SkipUI.Spring.snappy(duration: duration, extraBounce: extraBounce)
        case .bouncy:
            return SkipUI.Spring.bouncy
        case .bouncyDuration(let duration, let extraBounce):
            return SkipUI.Spring.bouncy(duration: duration, extraBounce: extraBounce)
        }
    }
}

extension Spring {
    public init(duration: TimeInterval = 0.5, bounce: Double = 0.0) {
        self.spec = .duration(duration, bounce)
    }

    @available(*, unavailable)
    public var duration: TimeInterval {
        fatalError()
    }

    @available(*, unavailable)
    public var bounce: Double {
        fatalError()
    }
}

extension Spring {
    public init(response: Double, dampingRatio: Double) {
        self.spec = .response(response, dampingRatio)
    }

    @available(*, unavailable)
    public var response: Double {
        fatalError()
    }

    @available(*, unavailable)
    public var dampingRatio: Double {
        fatalError()
    }
}

extension Spring {
    public init(mass: Double = 1.0, stiffness: Double, damping: Double, allowOverDamping: Bool = false) {
        self.spec = .mass(mass, stiffness, damping, allowOverDamping)
    }

    @available(*, unavailable)
    public var mass: Double {
        fatalError()
    }

    @available(*, unavailable)
    public var stiffness: Double {
        fatalError()
    }

    @available(*, unavailable)
    public var damping: Double {
        fatalError()
    }
}

extension Spring {
    public init(settlingDuration: TimeInterval, dampingRatio: Double, epsilon: Double = 0.001) {
        self.spec = .settlingDuration(settlingDuration, dampingRatio, epsilon)
    }
}

extension Spring {
    @available(*, unavailable)
    public var settlingDuration: TimeInterval {
        fatalError()
    }

    @available(*, unavailable)
    public func settlingDuration<V>(target: V, initialVelocity: V = .zero, epsilon: Double) -> TimeInterval where V : VectorArithmetic {
        fatalError()
    }

    @available(*, unavailable)
    public func value<V>(target: V, initialVelocity: V = .zero, time: TimeInterval) -> V where V : VectorArithmetic {
        fatalError()
    }

    @available(*, unavailable)
    public func velocity<V>(target: V, initialVelocity: V = .zero, time: TimeInterval) -> V where V : VectorArithmetic {
        fatalError()
    }

    @available(*, unavailable)
    public func update<V>(value: inout V, velocity: inout V, target: V, deltaTime: TimeInterval) where V : VectorArithmetic {
        fatalError()
    }

    @available(*, unavailable)
    public func force<V>(target: V, position: V, velocity: V) -> V where V : VectorArithmetic {
        fatalError()
    }
}

extension Spring {
    @available(*, unavailable)
    public func settlingDuration<V>(fromValue: V, toValue: V, initialVelocity: V, epsilon: Double) -> TimeInterval where V : Animatable {
        fatalError()
    }

    @available(*, unavailable)
    public func value<V>(fromValue: V, toValue: V, initialVelocity: V, time: TimeInterval) -> V where V : Animatable {
        fatalError()
    }

    @available(*, unavailable)
    public func velocity<V>(fromValue: V, toValue: V, initialVelocity: V, time: TimeInterval) -> V where V : Animatable {
        fatalError()
    }

    @available(*, unavailable)
    public func force<V>(fromValue: V, toValue: V, position: V, velocity: V) -> V where V : Animatable {
        fatalError()
    }
}

extension Spring {
    public static var smooth: Spring {
        return Spring(spec: .smooth)
    }

    public static func smooth(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Spring {
        return Spring(spec: .smoothDuration(duration, extraBounce))
    }

    public static var snappy: Spring {
        return Spring(spec: .snappy)
    }

    public static func snappy(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Spring {
        return Spring(spec: .snappyDuration(duration, extraBounce))
    }

    public static var bouncy: Spring {
        return Spring(spec: .bouncy)
    }

    public static func bouncy(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Spring {
        return Spring(spec: .bouncyDuration(duration, extraBounce))
    }
}


// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipBridge
import SkipUI

/* @frozen */ public struct Animation : Hashable /*, Sendable */ {
    private let spec: AnimationSpec

    init(spec: AnimationSpec) {
        self.spec = spec
    }

    @available(*, unavailable)
    public init<A>(_ base: A) where A : CustomAnimation {
        fatalError()
    }
}

struct AnimationSpec : Hashable {
    let type: AnimationType
    var speed: Double?
    var logicallyComplete: TimeInterval?
    var delay: TimeInterval?
    var repeatCount: Int?
    var autoreverses = false

    init(_ type: AnimationType) {
        self.type = type
    }
}

enum AnimationType : Hashable {
    case `default`
    case spring
    case springBlend(Spring, TimeInterval)
    case springBounce(TimeInterval, Double, Double)
    case springResponse(Double, Double, TimeInterval)
    case interpolatingSpring
    case interpolatingDurationSpring(TimeInterval, Double, Double)
    case interpolatingMassSpring(Double, Double, Double, Double)
    case interpolatingVelocitySpring(Spring, Double)
    case interactiveSpring
    case interactiveSpringDuration(TimeInterval, Double, TimeInterval)
    case interactiveSpringResponse(Double, Double, TimeInterval)
    case smooth
    case smoothDuration(TimeInterval, Double)
    case snappy
    case snappyDuration(TimeInterval, Double)
    case bouncy
    case bouncyDuration(TimeInterval, Double)
    case easeInOut
    case easeInOutDuration(TimeInterval)
    case easeIn
    case easeInDuration(TimeInterval)
    case easeOut
    case easeOutDuration(TimeInterval)
    case linear
    case linearDuration(TimeInterval)
    case timingCurve(Double, Double, Double, Double, TimeInterval)
}

extension Animation {
    var Java_animation: SkipUI.Animation {
        var animation = Self.Java_animation(for: spec.type)
        if let speed = spec.speed {
            animation = animation.speed(speed)
        }
        if let logicallyComplete = spec.logicallyComplete {
            animation = animation.logicallyComplete(after: logicallyComplete)
        }
        if let delay = spec.delay {
            animation = animation.delay(delay)
        }
        if let repeatCount = spec.repeatCount {
            if repeatCount == Int.max {
                animation = animation.repeatForever(autoreverses: spec.autoreverses)
            } else {
                animation = animation.repeatCount(repeatCount, autoreverses: spec.autoreverses)
            }
        }
        return animation
    }

    private static func Java_animation(for type: AnimationType) -> SkipUI.Animation {
        switch type {
        case .default:
            return SkipUI.Animation.default
        case .spring:
            return SkipUI.Animation.spring
        case .springBlend(let spring, let blendDuration):
            return SkipUI.Animation.spring(spring.Java_spring, blendDuration: blendDuration)
        case .springBounce(let duration, let bounce, let blendDuration):
            return SkipUI.Animation.spring(duration: duration, bounce: bounce, blendDuration: blendDuration)
        case .springResponse(let response, let dampingFraction, let blendDuration):
            return SkipUI.Animation.spring(response: response, dampingFraction: dampingFraction, blendDuration: blendDuration)
        case .interpolatingSpring:
            return SkipUI.Animation.interpolatingSpring
        case .interpolatingDurationSpring(let duration, let bounce, let initialVelocity):
            return SkipUI.Animation.interpolatingSpring(duration: duration, bounce: bounce, initialVelocity: initialVelocity)
        case .interpolatingMassSpring(let mass, let stiffness, let damping, let initialVelocity):
            return SkipUI.Animation.interpolatingSpring(mass: mass, stiffness: stiffness, damping: damping, initialVelocity: initialVelocity)
        case .interpolatingVelocitySpring(let spring, let initialVelocity):
            return SkipUI.Animation.interpolatingSpring(spring.Java_spring, initialVelocity: initialVelocity)
        case .interactiveSpring:
            return SkipUI.Animation.interactiveSpring
        case .interactiveSpringDuration(let duration, let extraBounce, let blendDuration):
            return SkipUI.Animation.interactiveSpring(duration: duration, extraBounce: extraBounce, blendDuration: blendDuration)
        case .interactiveSpringResponse(let response, let dampingFraction, let blendDuration):
            return SkipUI.Animation.interactiveSpring(response: response, dampingFraction: dampingFraction, blendDuration: blendDuration)
        case .smooth:
            return SkipUI.Animation.smooth
        case .smoothDuration(let duration, let extraBounce):
            return SkipUI.Animation.smooth(duration: duration, extraBounce: extraBounce)
        case .snappy:
            return SkipUI.Animation.snappy
        case .snappyDuration(let duration, let extraBounce):
            return SkipUI.Animation.snappy(duration: duration, extraBounce: extraBounce)
        case .bouncy:
            return SkipUI.Animation.bouncy
        case .bouncyDuration(let duration, let extraBounce):
            return SkipUI.Animation.bouncy(duration: duration, extraBounce: extraBounce)
        case .easeInOut:
            return SkipUI.Animation.easeInOut
        case .easeInOutDuration(let duration):
            return SkipUI.Animation.easeInOut(duration: duration)
        case .easeIn:
            return SkipUI.Animation.easeIn
        case .easeInDuration(let duration):
            return SkipUI.Animation.easeIn(duration: duration)
        case .easeOut:
            return SkipUI.Animation.easeOut
        case .easeOutDuration(let duration):
            return SkipUI.Animation.easeOut(duration: duration)
        case .linear:
            return SkipUI.Animation.linear
        case .linearDuration(let duration):
            return SkipUI.Animation.linear(duration: duration)
        case .timingCurve(let p1x, let p1y, let p2x, let p2y, let duration):
            return SkipUI.Animation.timingCurve(p1x, p1y, p2x, p2y, duration: duration)
        }
    }
}

extension Animation {
    public static let `default` = Animation(spec: .init(.default))

    public func speed(_ speed: Double) -> Animation {
        var spec = self.spec
        spec.speed = speed
        return Animation(spec: spec)
    }

    public static func spring(_ spring: Spring, blendDuration: TimeInterval = 0.0) -> Animation {
        return Animation(spec: .init(.springBlend(spring, blendDuration)))
    }

    public static func interpolatingSpring(_ spring: Spring, initialVelocity: Double = 0.0) -> Animation {
        return Animation(spec: .init(.interpolatingVelocitySpring(spring, initialVelocity)))
    }

    public func logicallyComplete(after duration: TimeInterval) -> Animation {
        var spec = self.spec
        spec.logicallyComplete = duration
        return Animation(spec: spec)
    }

    public static func interpolatingSpring(mass: Double = 1.0, stiffness: Double, damping: Double, initialVelocity: Double = 0.0) -> Animation {
        return Animation(spec: .init(.interpolatingMassSpring(mass, stiffness, damping, initialVelocity)))
    }

    public static func interpolatingSpring(duration: TimeInterval = 0.5, bounce: Double = 0.0, initialVelocity: Double = 0.0) -> Animation {
        return Animation(spec: .init(.interpolatingDurationSpring(duration, bounce, initialVelocity)))
    }

    public static var interpolatingSpring: Animation {
        return Animation(spec: .init(.interpolatingSpring))
    }

    public func delay(_ delay: TimeInterval) -> Animation {
        var spec = self.spec
        spec.delay = delay
        return Animation(spec: spec)
    }

    public static func spring(duration: TimeInterval = 0.5, bounce: Double = 0.0, blendDuration: Double = 0) -> Animation {
        return Animation(spec: .init(.springBounce(duration, bounce, blendDuration)))
    }

    public static func spring(response: Double = 0.5, dampingFraction: Double = 0.825, blendDuration: TimeInterval = 0) -> Animation {
        return Animation(spec: .init(.springResponse(response, dampingFraction, blendDuration)))
    }

    public static var spring: Animation {
        return Animation(spec: .init(.spring))
    }

    public static func interactiveSpring(response: Double = 0.15, dampingFraction: Double = 0.86, blendDuration: TimeInterval = 0.25) -> Animation {
        return Animation(spec: .init(.interactiveSpringResponse(response, dampingFraction, blendDuration)))
    }

    public static var interactiveSpring: Animation {
        return Animation(spec: .init(.interactiveSpring))
    }

    public static func interactiveSpring(duration: TimeInterval = 0.15, extraBounce: Double = 0.0, blendDuration: TimeInterval = 0.25) -> Animation {
        return Animation(spec: .init(.interactiveSpringDuration(duration, extraBounce, blendDuration)))
    }

    public static var smooth: Animation {
        return Animation(spec: .init(.smooth))
    }

    public static func smooth(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Animation {
        return Animation(spec: .init(.smoothDuration(duration, extraBounce)))
    }

    public static var snappy: Animation {
        return Animation(spec: .init(.snappy))
    }

    public static func snappy(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Animation {
        return Animation(spec: .init(.snappyDuration(duration, extraBounce)))
    }

    public static var bouncy: Animation {
        return Animation(spec: .init(.bouncy))
    }

    public static func bouncy(duration: TimeInterval = 0.5, extraBounce: Double = 0.0) -> Animation {
        return Animation(spec: .init(.bouncyDuration(duration, extraBounce)))
    }

    public static func easeInOut(duration: TimeInterval) -> Animation {
        return Animation(spec: .init(.easeInOutDuration(duration)))
    }

    public static var easeInOut: Animation {
        return Animation(spec: .init(.easeInOut))
    }

    public static func easeIn(duration: TimeInterval) -> Animation {
        return Animation(spec: .init(.easeInDuration(duration)))
    }

    public static var easeIn: Animation {
        return Animation(spec: .init(.easeIn))
    }

    public static func easeOut(duration: TimeInterval) -> Animation {
        return Animation(spec: .init(.easeOutDuration(duration)))
    }

    public static var easeOut: Animation {
        return Animation(spec: .init(.easeOut))
    }

    public static func linear(duration: TimeInterval) -> Animation {
        return Animation(spec: .init(.linearDuration(duration)))
    }

    public static var linear: Animation {
        return Animation(spec: .init(.linear))
    }

    public static func timingCurve(_ p1x: Double, _ p1y: Double, _ p2x: Double, _ p2y: Double, duration: TimeInterval = 0.35) -> Animation {
        return Animation(spec: .init(.timingCurve(p1x, p1y, p2x, p2y, duration)))
    }

    public static func timingCurve(_ curve: UnitCurve, duration: TimeInterval) -> Animation {
        return timingCurve(curve.startControlPoint.x, curve.startControlPoint.y, curve.endControlPoint.x, curve.endControlPoint.y, duration: duration)
    }
}

extension Animation {
    public func repeatCount(_ repeatCount: Int, autoreverses: Bool = true) -> Animation {
        var spec = self.spec
        spec.repeatCount = repeatCount
        spec.autoreverses = autoreverses
        return Animation(spec: spec)
    }

    public func repeatForever(autoreverses: Bool = true) -> Animation {
        var spec = self.spec
        spec.repeatCount = Int.max
        spec.autoreverses = autoreverses
        return Animation(spec: spec)
    }
}

extension Animation {
    public func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
        return nil
    }

    public func velocity<V>(value: V, time: TimeInterval, context: AnimationContext<V>) -> V? where V : VectorArithmetic {
        return nil
    }

    public func shouldMerge<V>(previous: Animation, value: V, time: TimeInterval, context: inout AnimationContext<V>) -> Bool where V : VectorArithmetic {
        return false
    }

    @available(*, unavailable)
    public var base: any CustomAnimation {
        fatalError()
    }
}

extension Animation : CustomStringConvertible, CustomDebugStringConvertible, CustomReflectable {
    public var description: String {
        return "SkipSwiftUI.Animation: \(spec)"
    }

    public var debugDescription: String {
        return "SkipSwiftUI.Animation: \(spec)"
    }

    public var customMirror: Mirror {
        return Mirror(reflecting: spec)
    }
}

public struct AnimationContext<Value> where Value : VectorArithmetic {
    public var state: AnimationState<Value>
    public var isLogicallyComplete: Bool

    @available(*, unavailable)
    public var environment: EnvironmentValues {
        fatalError()
    }

    @available(*, unavailable)
    public func withState<T>(_ state: AnimationState<T>) -> AnimationContext<T> where T : VectorArithmetic {
        fatalError()
    }
}

public struct AnimationState<Value> where Value : VectorArithmetic {
    public init() {
    }

    @available(*, unavailable)
    public subscript<K>(key: K.Type) -> K.Value where K : AnimationStateKey {
        fatalError()
    }
}

public protocol AnimationStateKey {
    associatedtype Value

    static var defaultValue: Self.Value { get }
}

public protocol CustomAnimation : Hashable {
    func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic

    func velocity<V>(value: V, time: TimeInterval, context: AnimationContext<V>) -> V? where V : VectorArithmetic

    func shouldMerge<V>(previous: Animation, value: V, time: TimeInterval, context: inout AnimationContext<V>) -> Bool where V : VectorArithmetic
}

extension CustomAnimation {
    public func velocity<V>(value: V, time: TimeInterval, context: AnimationContext<V>) -> V? where V : VectorArithmetic {
        return nil
    }

    public func shouldMerge<V>(previous: Animation, value: V, time: TimeInterval, context: inout AnimationContext<V>) -> Bool where V : VectorArithmetic {
        return false
    }
}

public protocol Animatable {
//    associatedtype AnimatableData : VectorArithmetic
//    var animatableData: Self.AnimatableData { get set }
}

//extension Animatable where Self : VectorArithmetic {
//    public var animatableData: Self
//}
//
//extension Animatable where Self.AnimatableData == EmptyAnimatableData {
//    public var animatableData: EmptyAnimatableData
//}

@frozen public struct EmptyAnimatableData : VectorArithmetic /*, BitwiseCopyable, Sendable */ {
    @inlinable public init() {
    }

    @inlinable public static var zero: EmptyAnimatableData {
        return EmptyAnimatableData()
    }

    @inlinable public static func += (lhs: inout EmptyAnimatableData, rhs: EmptyAnimatableData) {
    }

    @inlinable public static func -= (lhs: inout EmptyAnimatableData, rhs: EmptyAnimatableData) {
    }

    @inlinable public static func + (lhs: EmptyAnimatableData, rhs: EmptyAnimatableData) -> EmptyAnimatableData {
        return lhs
    }

    @inlinable public static func - (lhs: EmptyAnimatableData, rhs: EmptyAnimatableData) -> EmptyAnimatableData {
        return lhs
    }

    @inlinable public mutating func scale(by rhs: Double) {
    }

    @inlinable public var magnitudeSquared: Double {
        return 0.0
    }

    public static func == (a: EmptyAnimatableData, b: EmptyAnimatableData) -> Bool {
        return true
    }
}

@frozen public struct AnimatablePair<First, Second> : VectorArithmetic where First : VectorArithmetic, Second : VectorArithmetic {
    public var first: First
    public var second: Second

    @inlinable public init(_ first: First, _ second: Second) {
        self.first = first
        self.second = second
    }

    public static var zero: AnimatablePair<First, Second> {
        return AnimatablePair(.zero, .zero)
    }

    public static func += (lhs: inout AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>) {
        lhs.first += rhs.first
        lhs.second += rhs.second
    }

    public static func -= (lhs: inout AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>) {
        lhs.first -= rhs.first
        lhs.second -= lhs.second
    }

    public static func + (lhs: AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>) -> AnimatablePair<First, Second> {
        return AnimatablePair(lhs.first + rhs.first, lhs.second + rhs.second)
    }

    public static func - (lhs: AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>) -> AnimatablePair<First, Second> {
        return AnimatablePair(lhs.first - rhs.first, lhs.second - rhs.second)
    }

    public mutating func scale(by rhs: Double) {
        first.scale(by: rhs)
        second.scale(by: rhs)
    }

    public var magnitudeSquared: Double {
        return first.magnitudeSquared * second.magnitudeSquared
    }

    public static func == (lhs: AnimatablePair<First, Second>, rhs: AnimatablePair<First, Second>) -> Bool {
        return lhs.first == rhs.first && lhs.second == rhs.second
    }
}

//extension AnimatablePair : Sendable where First : Sendable, Second : Sendable {
//}

public protocol AnimatableModifier : Animatable, ViewModifier {
}

public struct AnimationCompletionCriteria : Hashable /*, Sendable */ {
    public static let logicallyComplete = AnimationCompletionCriteria()

    public static let removed = AnimationCompletionCriteria()
}

public func withAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    let isNested = SkipUI.Animation.preBodyWithAnimation(animation?.Java_animation)
    defer {
        if !isNested {
            SkipUI.Animation.postBodyWithAnimation()
        }
    }
    return try body()
}

@available(*, unavailable)
public func withAnimation<Result>(_ animation: Animation? = .default, completionCriteria: AnimationCompletionCriteria = .logicallyComplete, _ body: () throws -> Result, completion: @escaping () -> Void) rethrows -> Result {
    fatalError()
}

extension View {
    /* @inlinable nonisolated */ public func animation<V>(_ animation: Animation?, value: V) -> some View where V : Equatable {
        let bridgedValue = SwiftEquatable(value)
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.animation(animation?.Java_animation, value: bridgedValue)
        }
    }
}

extension View where Self : Equatable {
    @inlinable /* nonisolated */ public func animation(_ animation: Animation?) -> some View {
        return self.animation(animation, value: self)
    }
}

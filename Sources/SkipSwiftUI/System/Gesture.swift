// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

@MainActor @preconcurrency public protocol Gesture<Value> {
    associatedtype Value
    associatedtype Body : Gesture

    @MainActor @preconcurrency var body: Self.Body { get }

    nonisolated var Java_gesture: any SkipUI.BridgedGesture { get }
}

extension Never : Gesture {
    public typealias Value = Never
    public var Java_gesture: any SkipUI.BridgedGesture { fatalError("Never") }
}

extension Optional : Gesture where Wrapped : Gesture {
    public typealias Value = Wrapped.Value
    public var body: Never { fatalError("Never") }
    public var Java_gesture: any SkipUI.BridgedGesture { fatalError("Never") }
}

extension Gesture {
    nonisolated public func onEnded(_ action: @escaping (Self.Value) -> Void) -> _EndedGesture<Self> {
        return _EndedGesture(self, action: action)
    }
}

extension Gesture /* where Self.Value : Equatable */ {
    nonisolated public func onChanged(_ action: @escaping (Self.Value) -> Void) -> _ChangedGesture<Self> {
        return _ChangedGesture(self, action: action)
    }
}

extension Gesture {
    @available(*, unavailable)
    @MainActor /* @inlinable */ @preconcurrency public func exclusively<Other>(before other: Other) -> ExclusiveGesture<Self, Other> where Other : Gesture {
        fatalError()
    }
}

extension Gesture {
    @available(*, unavailable)
    @MainActor @preconcurrency public func map<T>(_ body: @escaping (Self.Value) -> T) -> _MapGesture<Self, T> {
        fatalError()
    }
}

extension Gesture {
    @available(*, unavailable)
    @MainActor /* @inlinable */ @preconcurrency public func sequenced<Other>(before other: Other) -> SequenceGesture<Self, Other> where Other : Gesture {
        fatalError()
    }
}

extension Gesture {
    @available(*, unavailable)
    @MainActor /* @inlinable */ @preconcurrency public func simultaneously<Other>(with other: Other) -> SimultaneousGesture<Self, Other> where Other : Gesture {
        fatalError()
    }
}

extension Gesture {
    @MainActor /* @inlinable */ @preconcurrency public func updating<State>(_ state: GestureState<State>, body: @escaping (Self.Value, inout State, inout Transaction) -> Void) -> GestureStateGesture<Self, State> {
        return GestureStateGesture(base: self, state: state, body: body)
    }
}

/* @frozen */ public struct _ChangedGesture<T> where T : Gesture {
    private let gesture: T
    private let action: (T.Value) -> Void

    /* @MainActor @preconcurrency */public init(_ gesture: T, action: @escaping (T.Value) -> Void) {
        self.gesture = gesture
        self.action = action
    }
}

extension _ChangedGesture : Gesture {
    public typealias Value = T.Value
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        let javaGesture = gesture.Java_gesture
        if Self.Value.self == DragGesture.Value.self {
            return javaGesture.onChangedDragGestureValue(bridgedAction: { action(DragGesture.Value($0) as! Value) })
        } else if Self.Value.self == MagnifyGesture.Value.self {
            return javaGesture.onChangedMagnifyGestureValue(bridgedAction: { action(MagnifyGesture.Value($0) as! Value) })
        } else if Self.Value.self == RotateGesture.Value.self {
            return javaGesture.onChangedRotateGestureValue(bridgedAction: { action(RotateGesture.Value($0) as! Value) })
        } else if Self.Value.self == Bool.self {
            return javaGesture.onChangedBool(bridgedAction: { action($0 as! Value) })
        } else if Self.Value.self == CGFloat.self {
            return javaGesture.onChangedCGFloat(bridgedAction: { action($0 as! Value) })
        } else if Self.Value.self == Void.self {
            return javaGesture.onChangedVoid(bridgedAction: { action(() as! Value) })
        } else {
            return javaGesture
        }
    }
}

/* @frozen */ public struct _EndedGesture<T> where T : Gesture {
    private let gesture: T
    private let action: (T.Value) -> Void

    /* @MainActor @preconcurrency */public init(_ gesture: T, action: @escaping (T.Value) -> Void) {
        self.gesture = gesture
        self.action = action
    }
}

extension _EndedGesture : Gesture {
    public typealias Value = T.Value
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        let javaGesture = gesture.Java_gesture
        if Self.Value.self == DragGesture.Value.self {
            return javaGesture.onEndedDragGestureValue(bridgedAction: { action(DragGesture.Value($0) as! Value) })
        } else if Self.Value.self == MagnifyGesture.Value.self {
            return javaGesture.onEndedMagnifyGestureValue(bridgedAction: { action(MagnifyGesture.Value($0) as! Value) })
        } else if Self.Value.self == RotateGesture.Value.self {
            return javaGesture.onEndedRotateGestureValue(bridgedAction: { action(RotateGesture.Value($0) as! Value) })
        } else if Self.Value.self == Bool.self {
            return javaGesture.onEndedBool(bridgedAction: { action($0 as! Value) })
        } else if Self.Value.self == CGFloat.self {
            return javaGesture.onEndedCGFloat(bridgedAction: { action($0 as! Value) })
        } else if Self.Value.self == Void.self {
            return javaGesture.onEndedVoid(bridgedAction: { action(() as! Value) })
        } else {
            return javaGesture
        }
    }
}

/* @frozen */public struct _MapGesture<T, V> where T : Gesture {
    private let gesture: T
    private let transform: (T.Value) -> V

    public init(_ gesture: T, transform: @escaping (T.Value) -> V) {
        self.gesture = gesture
        self.transform = transform
    }
}

extension _MapGesture : Gesture {
    public typealias Value = V
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture { fatalError("Never") }
}

/* @frozen */public struct AnyGesture<Value> {
    private let gesture: any Gesture

    public init<T>(_ gesture: T) where Value == T.Value, T : Gesture {
        self.gesture = gesture
    }
}

extension AnyGesture : Gesture {
    public typealias Value = Value
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        return gesture.Java_gesture
    }
}

public struct DragGesture {
    public struct Value : Equatable, Sendable {
        public var time: Date
        public var location: CGPoint
        public var startLocation: CGPoint
        public var velocity: CGSize
        public var predictedEndLocation: CGPoint

        public var translation: CGSize {
            return CGSize(width: location.x - startLocation.x, height: location.y - startLocation.y)
        }

        public var predictedEndTranslation: CGSize {
            return CGSize(width: predictedEndLocation.x - startLocation.x, height: predictedEndLocation.y - startLocation.y)
        }

        init(_ value: SkipUI.DragGestureValue) {
            self.time = Date(timeIntervalSinceReferenceDate: value.time)
            self.location = CGPoint(x: value.locationX, y: value.locationY)
            self.startLocation = CGPoint(x: value.startLocationX, y: value.startLocationY)
            self.velocity = CGSize(width: value.velocityWidth, height: value.velocityHeight)
            self.predictedEndLocation = CGPoint(x: value.predictedEndLocationX, y: value.predictedEndLocationY)
        }
    }

    public var minimumDistance: CGFloat
    public var coordinateSpace: CoordinateSpace

    public init(minimumDistance: CGFloat = 10, coordinateSpace: some CoordinateSpaceProtocol = .local) {
        self.minimumDistance = minimumDistance
        self.coordinateSpace = coordinateSpace.coordinateSpace
    }

    @_disfavoredOverload public init(minimumDistance: CGFloat = 10, coordinateSpace: CoordinateSpace = .local) {
        self.minimumDistance = minimumDistance
        self.coordinateSpace = coordinateSpace
    }
}

extension DragGesture : Gesture {
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        var name: SwiftHashable? = nil
        if case .named(let n) = coordinateSpace {
            name = Java_swiftHashable(for: n)
        }
        return SkipUI.DragGesture(minimumDistance: minimumDistance, bridgedCoordinateSpace: coordinateSpace.identifier, name: name)
    }
}

/* @frozen */public struct ExclusiveGesture<First, Second> where First : Gesture, Second : Gesture {
    @frozen public enum Value {
        case first(First.Value)
        case second(Second.Value)
    }

    public var first: First
    public var second: Second

    @available(*, unavailable)
    public init(first: First, second: Second) {
        self.first = first
        self.second = second
    }
}

extension ExclusiveGesture : Gesture {
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture { fatalError("Never") }
}

//extension ExclusiveGesture.Value : Sendable where First.Value : Sendable, Second.Value : Sendable {
//}

extension ExclusiveGesture.Value : Equatable where First.Value : Equatable, Second.Value : Equatable {
}

/* @frozen */public struct GestureStateGesture<Base, State> where Base : Gesture {
    public typealias Value = Base.Value

    public var base: Base
    public var state: GestureState<State>

    private var action: (Value, inout State, inout Transaction) -> Void

    @MainActor /* @inlinable */ @preconcurrency public init(base: Base, state: GestureState<State>, body: @escaping (GestureStateGesture<Base, State>.Value, inout State, inout Transaction) -> Void) {
        self.base = base
        self.state = state
        self.action = body
    }
}

extension GestureStateGesture : Gesture {
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        base.onChanged { value in
            var state = self.state.wrappedValue
            var transaction = Transaction()
            action(value, &state, &transaction)
            self.state.wrappedValue = state
        }.onEnded { value in
            self.state.reset()
        }.Java_gesture
    }
}

public struct LongPressGesture {
    public var minimumDuration: Double
    public var maximumDistance: CGFloat

    nonisolated public init(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10) {
        self.minimumDuration = minimumDuration
        self.maximumDistance = maximumDistance
    }
}

extension LongPressGesture : Gesture {
    public typealias Value = Bool
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        return SkipUI.LongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
    }
}

public struct MagnificationGesture {
    public var minimumScaleDelta: CGFloat

    @available(*, unavailable)
    public init(minimumScaleDelta: CGFloat = 0.01) {
        self.minimumScaleDelta = minimumScaleDelta
    }
}

extension MagnificationGesture : Gesture {
    public typealias Value = CGFloat
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any BridgedGesture { fatalError("Never") }
}

public struct MagnifyGesture {
    public struct Value : Equatable, Sendable {
        public var time: Date
        public var magnification: CGFloat
        public var velocity: CGFloat
        public var startAnchor: UnitPoint
        public var startLocation: CGPoint

        init(_ value: SkipUI.MagnifyGestureValue) {
            self.time = Date(timeIntervalSinceReferenceDate: value.time)
            self.magnification = value.magnification
            self.velocity = value.velocity
            self.startAnchor = UnitPoint(x: value.startAnchorX, y: value.startAnchorY)
            self.startLocation = CGPoint(x: value.startLocationX, y: value.startLocationY)
        }
    }

    public var minimumScaleDelta: CGFloat

    public init(minimumScaleDelta: CGFloat = 0.01) {
        self.minimumScaleDelta = minimumScaleDelta
    }
}

extension MagnifyGesture : Gesture {
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        return SkipUI.MagnifyGesture(minimumScaleDelta: minimumScaleDelta)
    }
}

public struct RotateGesture {
    public struct Value : Equatable, Sendable {
        public var time: Date
        public var rotation: Angle
        public var velocity: Angle
        public var startAnchor: UnitPoint
        public var startLocation: CGPoint

        init(_ value: SkipUI.RotateGestureValue) {
            self.time = Date(timeIntervalSinceReferenceDate: value.time)
            self.rotation = Angle(degrees: value.rotationDegrees)
            self.velocity = Angle(degrees: value.velocityDegrees)
            self.startAnchor = UnitPoint(x: value.startAnchorX, y: value.startAnchorY)
            self.startLocation = CGPoint(x: value.startLocationX, y: value.startLocationY)
        }
    }

    public var minimumAngleDelta: Angle

    public init(minimumAngleDelta: Angle = .degrees(1)) {
        self.minimumAngleDelta = minimumAngleDelta
    }
}

extension RotateGesture : Gesture {
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        return SkipUI.RotateGesture(minimumAngleDegreesDelta: minimumAngleDelta.degrees)
    }
}

public struct RotationGesture {
    public var minimumAngleDelta: Angle

    @available(*, unavailable)
    public init(minimumAngleDelta: Angle = .degrees(1)) {
        self.minimumAngleDelta = minimumAngleDelta
    }
}

extension RotationGesture : Gesture {
    public typealias Value = Angle
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture { fatalError("Never") }
}

/* @frozen */public struct SequenceGesture<First, Second> where First : Gesture, Second : Gesture {
    @frozen public enum Value {
        case first(First.Value)
        case second(First.Value, Second.Value?)
    }

    public var first: First
    public var second: Second

    @available(*, unavailable)
    /* @inlinable */public init(_ first: First, _ second: Second) {
        self.first = first
        self.second = second
    }
}

extension SequenceGesture : Gesture {
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture { fatalError("Never") }
}

//extension SequenceGesture.Value : Sendable where First.Value : Sendable, Second.Value : Sendable {
//}

extension SequenceGesture.Value : Equatable where First.Value : Equatable, Second.Value : Equatable {
}

/* @frozen */public struct SimultaneousGesture<First, Second> where First : Gesture, Second : Gesture {
    @frozen public struct Value {
        public var first: First.Value?
        public var second: Second.Value?
    }

    public var first: First
    public var second: Second

    @available(*, unavailable)
    /* @inlinable */public init(_ first: First, _ second: Second) {
        self.first = first
        self.second = second
    }
}

extension SimultaneousGesture : Gesture {
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture { fatalError("Never") }
}

//extension SimultaneousGesture.Value : Sendable where First.Value : Sendable, Second.Value : Sendable {
//}

extension SimultaneousGesture.Value : Equatable where First.Value : Equatable, Second.Value : Equatable {
}

extension SimultaneousGesture.Value : Hashable where First.Value : Hashable, Second.Value : Hashable {
}

public struct TapGesture {
    public var count: Int

    public init(count: Int = 1) {
        self.count = count
    }
}

extension TapGesture : Gesture {
    public typealias Value = Void
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        return SkipUI.TapGesture(count: count, bridgedCoordinateSpace: CoordinateSpace.local.identifier, name: nil)
    }
}

@frozen public struct GestureMask : OptionSet, Sendable, BitwiseCopyable {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    @available(*, unavailable)
    public static let none = GestureMask(rawValue: 1) // For bridging

    @available(*, unavailable)
    public static let gesture = GestureMask(rawValue: 2) // For bridging

    @available(*, unavailable)
    public static let subviews = GestureMask(rawValue: 4) // For bridging

    public static let all = GestureMask(rawValue: 7) // For bridging
}

extension View {
    nonisolated public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10, perform action: @escaping () -> Void, onPressingChanged: ((Bool) -> Void)? = nil) -> some View {
        return ModifierView(target: self) {
            if let onPressingChanged {
                $0.Java_viewOrEmpty.onLongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance, perform: action, onPressingChanged: onPressingChanged)
            } else {
                $0.Java_viewOrEmpty.onLongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance, perform: action)
            }
        }
    }

    @_disfavoredOverload nonisolated public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10, pressing: ((Bool) -> Void)? = nil, perform action: @escaping () -> Void) -> some View {
        return onLongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance, perform: action, onPressingChanged: pressing)
    }

    nonisolated public func onTapGesture(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        return onTapGesture(count: count, coordinateSpace: .local, perform: { _ in action() })
    }

    @_disfavoredOverload nonisolated public func onTapGesture(count: Int = 1, coordinateSpace: CoordinateSpace = .local, perform action: @escaping (CGPoint) -> Void) -> some View {
        var name: SwiftHashable? = nil
        if case .named(let n) = coordinateSpace {
            name = Java_swiftHashable(for: n)
        }
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onTapGesture(count: count, bridgedCoordinateSpace: coordinateSpace.identifier, name: name, perform: { action(CGPoint(x: $0, y: $1)) })
        }
    }

    nonisolated public func onTapGesture(count: Int = 1, coordinateSpace: some CoordinateSpaceProtocol = .local, perform action: @escaping (CGPoint) -> Void) -> some View {
        var name: SwiftHashable? = nil
        if case .named(let n) = coordinateSpace.coordinateSpace {
            name = Java_swiftHashable(for: n)
        }
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onTapGesture(count: count, bridgedCoordinateSpace: coordinateSpace.coordinateSpace.identifier, name: name, perform: { action(CGPoint(x: $0, y: $1)) })
        }
    }
}

extension View {
    nonisolated public func gesture<T>(_ gesture: T, including mask: GestureMask = .all) -> some View where T : Gesture {
        // We only support masks of `.all` or `.none`
        return self.gesture(gesture, isEnabled: !mask.isEmpty)
    }

    @available(*, unavailable)
    nonisolated public func highPriorityGesture<T>(_ gesture: T, including mask: GestureMask = .all) -> some View where T : Gesture {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func simultaneousGesture<T>(_ gesture: T, including mask: GestureMask = .all) -> some View where T : Gesture {
        stubView()
    }

    nonisolated public func gesture<T>(_ gesture: T, isEnabled: Bool) -> some View where T : Gesture {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.bridgedGesture(gesture.Java_gesture, isEnabled: isEnabled)
        }
    }

    @available(*, unavailable)
    nonisolated public func highPriorityGesture<T>(_ gesture: T, isEnabled: Bool) -> some View where T : Gesture {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func simultaneousGesture<T>(_ gesture: T, isEnabled: Bool) -> some View where T : Gesture {
        stubView()
    }
}

extension View {
    nonisolated public func gesture<T>(_ gesture: T, name: String, isEnabled: Bool = true) -> some View where T : Gesture {
        return self.gesture(gesture, isEnabled: isEnabled)
    }

    @available(*, unavailable)
    nonisolated public func highPriorityGesture<T>(_ gesture: T, name: String, isEnabled: Bool = true) -> some View where T : Gesture {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func simultaneousGesture<T>(_ gesture: T, name: String, isEnabled: Bool = true) -> some View where T : Gesture {
        stubView()
    }
}

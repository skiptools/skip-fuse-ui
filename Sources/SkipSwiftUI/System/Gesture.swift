// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipBridge
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

@MainActor /* @frozen */ @preconcurrency public struct _ChangedGesture<T> : Gesture where T : Gesture {
    private let gesture: UncheckedSendableBox<T>
    private let action: UncheckedSendableBox<(T.Value) -> Void>

    /* @MainActor @preconcurrency */nonisolated public init(_ gesture: T, action: @escaping (T.Value) -> Void) {
        self.gesture = UncheckedSendableBox(gesture)
        self.action = UncheckedSendableBox(action)
    }

    public typealias Value = T.Value
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        let javaGesture = gesture.wrappedValue.Java_gesture
        if Self.Value.self == DragGesture.Value.self {
            return javaGesture.onChangedDragGestureValue(bridgedAction: { action.wrappedValue(DragGesture.Value($0) as! Value) })
        } else if Self.Value.self == MagnifyGesture.Value.self {
            return javaGesture
        } else if Self.Value.self == RotateGesture.Value.self {
            return javaGesture
        } else if Self.Value.self == Bool.self {
            return javaGesture.onChangedBool(bridgedAction: { action.wrappedValue($0 as! Value) })
        } else if Self.Value.self == CGFloat.self {
            return javaGesture.onChangedCGFloat(bridgedAction: { action.wrappedValue($0 as! Value) })
        } else if Self.Value.self == Void.self {
            return javaGesture.onChangedVoid(bridgedAction: { action.wrappedValue(() as! Value) })
        } else {
            return javaGesture
        }
    }
}

@MainActor /* @frozen */ @preconcurrency public struct _EndedGesture<T> : Gesture where T : Gesture {
    private let gesture: UncheckedSendableBox<T>
    private let action: UncheckedSendableBox<(T.Value) -> Void>

    /* @MainActor @preconcurrency */nonisolated public init(_ gesture: T, action: @escaping (T.Value) -> Void) {
        self.gesture = UncheckedSendableBox(gesture)
        self.action = UncheckedSendableBox(action)
    }

    public typealias Value = T.Value
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        let javaGesture = gesture.wrappedValue.Java_gesture
        if Self.Value.self == DragGesture.Value.self {
            return javaGesture.onEndedDragGestureValue(bridgedAction: { action.wrappedValue(DragGesture.Value($0) as! Value) })
        } else if Self.Value.self == MagnifyGesture.Value.self {
            return javaGesture
        } else if Self.Value.self == RotateGesture.Value.self {
            return javaGesture
        } else if Self.Value.self == Bool.self {
            return javaGesture.onEndedBool(bridgedAction: { action.wrappedValue($0 as! Value) })
        } else if Self.Value.self == CGFloat.self {
            return javaGesture.onEndedCGFloat(bridgedAction: { action.wrappedValue($0 as! Value) })
        } else if Self.Value.self == Void.self {
            return javaGesture.onEndedVoid(bridgedAction: { action.wrappedValue(() as! Value) })
        } else {
            return javaGesture
        }
    }
}

@MainActor /* @frozen */ @preconcurrency public struct _MapGesture<T, V> : Gesture where T : Gesture {
    private let gesture: UncheckedSendableBox<T>
    private let transform: UncheckedSendableBox<(T.Value) -> V>

    @MainActor @preconcurrency public init(_ gesture: T, transform: @escaping (T.Value) -> V) {
        self.gesture = UncheckedSendableBox(gesture)
        self.transform = UncheckedSendableBox(transform)
    }

    public typealias Value = V
    public var body: Never { fatalError("Never") }
    public var Java_gesture: any SkipUI.BridgedGesture { fatalError("Never") }
}

@MainActor /* @frozen */ @preconcurrency public struct AnyGesture<Value> : Gesture {
    private let gesture: UncheckedSendableBox<any Gesture>

    @MainActor @preconcurrency public init<T>(_ gesture: T) where Value == T.Value, T : Gesture {
        self.gesture = UncheckedSendableBox(gesture)
    }

    public typealias Value = Value
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        return gesture.wrappedValue.Java_gesture
    }
}

@MainActor @preconcurrency public struct DragGesture : Gesture {
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

    @MainActor @preconcurrency public var minimumDistance: CGFloat
    @MainActor @preconcurrency public var coordinateSpace: CoordinateSpace {
        get {
            return _coordinateSpace.wrappedValue
        }
        set {
            _coordinateSpace = UncheckedSendableBox(newValue)
        }
    }
    private var _coordinateSpace: UncheckedSendableBox<CoordinateSpace>

    @MainActor @preconcurrency public init(minimumDistance: CGFloat = 10, coordinateSpace: some CoordinateSpaceProtocol = .local) {
        self.minimumDistance = minimumDistance
        _coordinateSpace = UncheckedSendableBox(coordinateSpace.coordinateSpace)
    }

    @_disfavoredOverload @MainActor @preconcurrency public init(minimumDistance: CGFloat = 10, coordinateSpace: CoordinateSpace = .local) {
        self.minimumDistance = minimumDistance
        _coordinateSpace = UncheckedSendableBox(coordinateSpace)
    }

    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        var name: SwiftHashable? = nil
        if case .named(let n) = _coordinateSpace.wrappedValue {
            name = Java_swiftHashable(for: n)
        }
        return SkipUI.DragGesture(minimumDistance: minimumDistance, bridgedCoordinateSpace: _coordinateSpace.wrappedValue.identifier, name: name)
    }
}

@MainActor /* @frozen */ @preconcurrency public struct ExclusiveGesture<First, Second> : Gesture where First : Gesture, Second : Gesture {
    @frozen public enum Value {
        case first(First.Value)
        case second(Second.Value)
    }

    @MainActor @preconcurrency public var first: First
    @MainActor @preconcurrency public var second: Second

    @available(*, unavailable)
    public init(first: First, second: Second) {
        self.first = first
        self.second = second
    }

    public var body: Never { fatalError("Never") }
    public var Java_gesture: any SkipUI.BridgedGesture { fatalError("Never") }
}

//extension ExclusiveGesture.Value : Sendable where First.Value : Sendable, Second.Value : Sendable {
//}

extension ExclusiveGesture.Value : Equatable where First.Value : Equatable, Second.Value : Equatable {
}

@MainActor /* @frozen */ @preconcurrency public struct GestureStateGesture<Base, State> : Gesture where Base : Gesture {
    public typealias Value = Base.Value

    @MainActor @preconcurrency public var base: Base {
        get {
            return _base.wrappedValue
        }
        set {
            _base = UncheckedSendableBox(newValue)
        }
    }
    private var _base: UncheckedSendableBox<Base>

    @MainActor @preconcurrency public var state: GestureState<State> {
        get {
            return _state.wrappedValue
        }
        set {
            _state = UncheckedSendableBox(newValue)
        }
    }
    private var _state: UncheckedSendableBox<GestureState<State>>

    private var action: UncheckedSendableBox<(Value, inout State, inout Transaction) -> Void>

    @MainActor /* @inlinable */ @preconcurrency public init(base: Base, state: GestureState<State>, body: @escaping (GestureStateGesture<Base, State>.Value, inout State, inout Transaction) -> Void) {
        _base = UncheckedSendableBox(base)
        _state = UncheckedSendableBox(state)
        self.action = UncheckedSendableBox(body)
    }

    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        _base.wrappedValue.onChanged { value in
            var state = _state.wrappedValue.wrappedValue
            var transaction = Transaction()
            action.wrappedValue(value, &state, &transaction)
            _state.wrappedValue.wrappedValue = state
        }.onEnded { value in
            _state.wrappedValue.reset()
        }.Java_gesture
    }
}

@MainActor @preconcurrency public struct LongPressGesture : Gesture {
    @MainActor @preconcurrency public var minimumDuration: Double
    @MainActor @preconcurrency public var maximumDistance: CGFloat

    nonisolated public init(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10) {
        self.minimumDuration = minimumDuration
        self.maximumDistance = maximumDistance
    }

    public typealias Value = Bool
    public var body: Never { fatalError("Never") }

    public var Java_gesture: any SkipUI.BridgedGesture {
        return SkipUI.LongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
    }
}

@MainActor @preconcurrency public struct MagnificationGesture : Gesture {
    @MainActor @preconcurrency public var minimumScaleDelta: CGFloat

    @available(*, unavailable)
    @MainActor @preconcurrency public init(minimumScaleDelta: CGFloat = 0.01) {
        self.minimumScaleDelta = minimumScaleDelta
    }

    public typealias Value = CGFloat
    public var body: Never { fatalError("Never") }
    public var Java_gesture: any BridgedGesture { fatalError("Never") }
}

@MainActor @preconcurrency public struct MagnifyGesture : Gesture {
    public struct Value : Equatable, Sendable {
        public var time: Date
        public var magnification: CGFloat
        public var velocity: CGFloat
        public var startAnchor: UnitPoint
        public var startLocation: CGPoint
    }

    @MainActor @preconcurrency public var minimumScaleDelta: CGFloat

    @available(*, unavailable)
    @MainActor @preconcurrency public init(minimumScaleDelta: CGFloat = 0.01) {
        self.minimumScaleDelta = minimumScaleDelta
    }

    public var body: Never { fatalError("Never") }
    public var Java_gesture: any BridgedGesture { fatalError("Never") }
}

@MainActor @preconcurrency public struct RotateGesture : Gesture {
    public struct Value : Equatable, Sendable {
        public var time: Date
        public var rotation: Angle
        public var velocity: Angle
        public var startAnchor: UnitPoint
        public var startLocation: CGPoint
    }

    @MainActor @preconcurrency public var minimumAngleDelta: Angle

    @available(*, unavailable)
    @MainActor @preconcurrency public init(minimumAngleDelta: Angle = .degrees(1)) {
        self.minimumAngleDelta = minimumAngleDelta
    }

    public var body: Never { fatalError("Never") }
    public var Java_gesture: any BridgedGesture { fatalError("Never") }
}

@MainActor @preconcurrency public struct RotationGesture : Gesture {
    @MainActor @preconcurrency public var minimumAngleDelta: Angle

    @available(*, unavailable)
    @MainActor @preconcurrency public init(minimumAngleDelta: Angle = .degrees(1)) {
        self.minimumAngleDelta = minimumAngleDelta
    }

    public typealias Value = Angle
    public var body: Never { fatalError("Never") }
    public var Java_gesture: any BridgedGesture { fatalError("Never") }
}

@MainActor /* @frozen */ @preconcurrency public struct SequenceGesture<First, Second> : Gesture where First : Gesture, Second : Gesture {
    @frozen public enum Value {
        case first(First.Value)
        case second(First.Value, Second.Value?)
    }

    @MainActor @preconcurrency public var first: First
    @MainActor @preconcurrency public var second: Second

    @available(*, unavailable)
    @MainActor /* @inlinable */ @preconcurrency public init(_ first: First, _ second: Second) {
        self.first = first
        self.second = second
    }

    public var body: Never { fatalError("Never") }
    public var Java_gesture: any SkipUI.BridgedGesture { fatalError("Never") }
}

//extension SequenceGesture.Value : Sendable where First.Value : Sendable, Second.Value : Sendable {
//}

extension SequenceGesture.Value : Equatable where First.Value : Equatable, Second.Value : Equatable {
}

@MainActor /* @frozen */ @preconcurrency public struct SimultaneousGesture<First, Second> : Gesture where First : Gesture, Second : Gesture {
    @frozen public struct Value {
        public var first: First.Value?
        public var second: Second.Value?
    }

    @MainActor @preconcurrency public var first: First
    @MainActor @preconcurrency public var second: Second

    @available(*, unavailable)
    @MainActor /* @inlinable */ @preconcurrency public init(_ first: First, _ second: Second) {
        self.first = first
        self.second = second
    }

    public var body: Never { fatalError("Never") }
    public var Java_gesture: any SkipUI.BridgedGesture { fatalError("Never") }
}

//extension SimultaneousGesture.Value : Sendable where First.Value : Sendable, Second.Value : Sendable {
//}

extension SimultaneousGesture.Value : Equatable where First.Value : Equatable, Second.Value : Equatable {
}

extension SimultaneousGesture.Value : Hashable where First.Value : Hashable, Second.Value : Hashable {
}

@MainActor @preconcurrency public struct TapGesture : Gesture {
    @MainActor @preconcurrency public var count: Int

    nonisolated public init(count: Int = 1) {
        self.count = count
    }

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

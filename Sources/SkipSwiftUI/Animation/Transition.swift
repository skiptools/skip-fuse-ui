// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

@MainActor @preconcurrency public protocol Transition {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func body(content: Any /* Self.Content */, phase: TransitionPhase) -> Self.Body

    @MainActor @preconcurrency static var properties: TransitionProperties { get }

//    typealias Content = PlaceholderContentView<Self>

    nonisolated var Java_transition: any SkipUI.Transition { get }
}

extension Transition where Self == OffsetTransition {
    @MainActor @preconcurrency public static func offset(_ offset: CGSize) -> Self {
        return OffsetTransition(offset)
    }

    @MainActor @preconcurrency public static func offset(x: CGFloat = 0, y: CGFloat = 0) -> Self {
        return self.offset(CGSize(width: x, height: y))
    }
}

extension Transition where Self == MoveTransition {
    @MainActor @preconcurrency public static func move(edge: Edge) -> Self {
        return MoveTransition(edge: edge)
    }
}

extension Transition where Self == OpacityTransition {
    @MainActor @preconcurrency public static var opacity: OpacityTransition {
        return OpacityTransition()
    }
}

extension Transition where Self == SlideTransition {
    @MainActor @preconcurrency public static var slide: SlideTransition {
        return SlideTransition()
    }
}

extension Transition where Self == PushTransition {
    @MainActor @preconcurrency public static func push(from edge: Edge) -> Self {
        return PushTransition(edge: edge)
    }
}

extension Transition {
    @available(*, unavailable)
    @MainActor @preconcurrency public func animation(_ animation: Animation?) -> some Transition {
        return self
    }
}

extension Transition {
    @MainActor @preconcurrency public func combined<T>(with other: T) -> some Transition where T : Transition {
        return CombinedTransition(self, other)
    }
}

extension Transition {
    @MainActor @preconcurrency public static var properties: TransitionProperties {
        return TransitionProperties()
    }

    @available(*, unavailable)
    @MainActor @preconcurrency public func apply<V>(content: V, phase: TransitionPhase) -> some View where V : View {
        stubView()
    }
}

extension Transition where Self == IdentityTransition {
    @MainActor @preconcurrency public static var identity: IdentityTransition {
        return IdentityTransition()
    }
}

extension Transition where Self == BlurReplaceTransition {
    @available(*, unavailable)
    @MainActor @preconcurrency public static func blurReplace(_ config: BlurReplaceTransition.Configuration = .downUp) -> BlurReplaceTransition {
        fatalError()
    }

    @available(*, unavailable)
    @MainActor @preconcurrency public static var blurReplace: BlurReplaceTransition {
        fatalError()
    }
}

extension Transition where Self == ScaleTransition {
    @MainActor @preconcurrency public static var scale: ScaleTransition {
        return ScaleTransition(0.5)
    }

    @MainActor @preconcurrency public static func scale(_ scale: Double, anchor: UnitPoint = .center) -> Self {
        return ScaleTransition(scale, anchor: anchor)
    }
}

@frozen public enum TransitionPhase : Hashable, BitwiseCopyable, Sendable {
    case willAppear
    case identity
    case didDisappear

    public var isIdentity: Bool {
        switch self {
        case .identity:
            return true
        default:
            return false
        }
    }
}

extension TransitionPhase {
    public var value: Double {
        switch self {
        case .identity:
            return 0
        case .willAppear:
            return -1
        case .didDisappear:
            return 1
        }
    }
}

public struct TransitionProperties : Sendable {
    public init(hasMotion: Bool = true) {
        self.hasMotion = hasMotion
    }

    public var hasMotion: Bool
}

@frozen public struct AnyTransition {
    let transition: any Transition

    public init<T>(_ transition: T) where T : Transition {
        self.transition = transition
    }
}

extension AnyTransition {
    @available(*, unavailable)
    public static func modifier<E>(active: E, identity: E) -> AnyTransition where E : ViewModifier {
        fatalError()
    }
}

extension AnyTransition {
    public static func offset(_ offset: CGSize) -> AnyTransition {
        return AnyTransition(OffsetTransition(offset))
    }

    public static func offset(x: CGFloat = 0, y: CGFloat = 0) -> AnyTransition {
        return AnyTransition(OffsetTransition(CGSize(width: x, height: y)))
    }
}

extension AnyTransition {
    public static func move(edge: Edge) -> AnyTransition {
        return AnyTransition(MoveTransition(edge: edge))
    }
}

extension AnyTransition {
    nonisolated(unsafe) public static let opacity = AnyTransition(OpacityTransition())
}

extension AnyTransition {
    public static func asymmetric(insertion: AnyTransition, removal: AnyTransition) -> AnyTransition {
        return AnyTransition(AsymmetricTransition(insertion: insertion.transition, removal: removal.transition))
    }
}

extension AnyTransition {
    public static var slide: AnyTransition {
        return AnyTransition(SlideTransition())
    }
}

extension AnyTransition {
    public static func push(from edge: Edge) -> AnyTransition {
        return AnyTransition(PushTransition(edge: edge))
    }
}

extension AnyTransition {
    @available(*, unavailable)
    public func animation(_ animation: Animation?) -> AnyTransition {
        fatalError()
    }
}

extension AnyTransition {
    public func combined(with other: AnyTransition) -> AnyTransition {
        return AnyTransition(CombinedTransition(self.transition, other.transition))
    }
}

extension AnyTransition {
    public static var identity: AnyTransition {
        return AnyTransition(IdentityTransition())
    }
}

extension AnyTransition {
    public static var scale: AnyTransition {
        return AnyTransition(ScaleTransition(0.5))
    }

    public static func scale(scale: CGFloat, anchor: UnitPoint = .center) -> AnyTransition {
        return AnyTransition(ScaleTransition(scale, anchor: anchor))
    }
}

public struct AsymmetricTransition /* <Insertion, Removal> where Insertion : Transition, Removal : Transition */ {
    /* @MainActor @preconcurrency */public var insertion: any Transition /* Insertion */
    /* @MainActor @preconcurrency */public var removal: any Transition /* Removal */

    /* @MainActor @preconcurrency */public init(insertion: any Transition /* Insertion */, removal: any Transition /* Removal */) {
        self.insertion = insertion
        self.removal = removal
    }

    public var Java_transition: any SkipUI.Transition {
        return SkipUI.AsymmetricTransition(insertion: insertion.Java_transition, removal: removal.Java_transition)
    }
}

extension AsymmetricTransition : Transition {
    @MainActor @preconcurrency public func body(content: Any /* AsymmetricTransition<Insertion, Removal>.Content */, phase: TransitionPhase) -> some View {
        stubView()
    }

    //    @MainActor @preconcurrency public static var properties: TransitionProperties
}

@MainActor @preconcurrency public struct BlurReplaceTransition : Transition {
    public struct Configuration : Equatable, Sendable {
        public static let downUp = BlurReplaceTransition.Configuration()
        public static let upUp = BlurReplaceTransition.Configuration()
    }

    @MainActor @preconcurrency public var configuration: BlurReplaceTransition.Configuration

    @available(*, unavailable)
    /* @MainActor @preconcurrency */nonisolated public init(configuration: BlurReplaceTransition.Configuration) {
        self.configuration = configuration
    }

    @MainActor @preconcurrency public func body(content: Any /* BlurReplaceTransition.Content */, phase: TransitionPhase) -> some View {
        stubView()
    }

    public var Java_transition: any SkipUI.Transition {
        fatalError()
    }
}

struct CombinedTransition {
    private let first: any Transition
    private let second: any Transition

    nonisolated init(_ first: any Transition, _ second: any Transition) {
        self.first = first
        self.second = second
    }
}

extension CombinedTransition : Transition {
    @MainActor @preconcurrency public func body(content: Any /* CombinedTransition.Content */, phase: TransitionPhase) -> some View {
        stubView()
    }

    public var Java_transition: any SkipUI.Transition {
        return SkipUI.CombinedTransition(first.Java_transition, second.Java_transition)
    }
}

public struct ContentTransition : Equatable, Sendable {
    public static let identity = ContentTransition()

    public static let opacity = ContentTransition()

    public static let interpolate = ContentTransition()

    public static func numericText(countsDown: Bool = false) -> ContentTransition {
        return ContentTransition()
    }

    public static func numericText(value: Double) -> ContentTransition {
        return ContentTransition()
    }
}

public struct IdentityTransition : Transition {
    /* @MainActor @preconcurrency */nonisolated public init() {
    }

    @MainActor @preconcurrency public func body(content: Any /* IdentityTransition.Content */, phase: TransitionPhase) -> some View /* IdentityTransition.Content */ {
        stubView()
    }

//    @MainActor @preconcurrency public static let properties: TransitionProperties

    public var Java_transition: any SkipUI.Transition {
        return SkipUI.IdentityTransition()
    }
}

public struct MoveTransition : Transition {
    public var edge: Edge

    /* @MainActor @preconcurrency */nonisolated public init(edge: Edge) {
        self.edge = edge
    }

    @MainActor @preconcurrency public func body(content: Any /* MoveTransition.Content */, phase: TransitionPhase) -> some View {
        stubView()
    }

    public var Java_transition: any SkipUI.Transition {
        return SkipUI.MoveTransition(bridgedEdge: Int(edge.rawValue))
    }
}

public struct OffsetTransition : Transition {
    public var offset: CGSize

    /* @MainActor @preconcurrency */nonisolated public init(_ offset: CGSize) {
        self.offset = offset
    }

    @MainActor @preconcurrency public func body(content: Any /* OffsetTransition.Content */, phase: TransitionPhase) -> some View {
        stubView()
    }

    public var Java_transition: any SkipUI.Transition {
        return SkipUI.OffsetTransition(offsetWidth: offset.width, height: offset.height)
    }
}

public struct OpacityTransition : Transition {
    /* @MainActor @preconcurrency */nonisolated public init() {
    }

    @MainActor @preconcurrency public func body(content: Any /* OpacityTransition.Content */, phase: TransitionPhase) -> some View {
        stubView()
    }

//    @MainActor @preconcurrency public static let properties: TransitionProperties

    public var Java_transition: any SkipUI.Transition {
        return SkipUI.OpacityTransition()
    }
}

public struct PushTransition : Transition {
    public var edge: Edge

    /* @MainActor @preconcurrency */nonisolated public init(edge: Edge) {
        self.edge = edge
    }

    @MainActor @preconcurrency public func body(content: Any /* PushTransition.Content */, phase: TransitionPhase) -> some View {
        stubView()
    }

    public var Java_transition: any SkipUI.Transition {
        return SkipUI.PushTransition(bridgedEdge: Int(edge.rawValue))
    }
}

public struct ScaleTransition : Transition {
    public var scale: Double
    public var anchor: UnitPoint

    /* @MainActor @preconcurrency */nonisolated public init(_ scale: Double, anchor: UnitPoint = .center) {
        self.scale = scale
        self.anchor = anchor
    }

    @MainActor @preconcurrency public func body(content: Any /* ScaleTransition.Content */, phase: TransitionPhase) -> some View {
        stubView()
    }

    public var Java_transition: any SkipUI.Transition {
        return SkipUI.ScaleTransition(scale: scale, anchorX: anchor.x, anchorY: anchor.y)
    }
}

public struct SlideTransition : Transition {
    /* @MainActor @preconcurrency */nonisolated public init() {
    }

    @MainActor @preconcurrency public func body(content: Any /* SlideTransition.Content */, phase: TransitionPhase) -> some View {
        stubView()
    }

    public var Java_transition: any SkipUI.Transition {
        return SkipUI.SlideTransition()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func contentTransition(_ transition: ContentTransition) -> some View {
        stubView()
    }
}

extension View {
    /* @inlinable */ nonisolated public func transition(_ t: AnyTransition) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.transition(SkipUI.AnyTransition(t.transition.Java_transition))
        }
    }

    nonisolated public func transition<T>(_ transition: T) -> some View where T : Transition {
        return self.transition(AnyTransition(transition))
    }
}

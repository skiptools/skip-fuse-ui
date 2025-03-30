// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipBridge
import SkipUI

/* @MainActor @preconcurrency */ public struct ScrollView<Content> : View where Content : View {
    /* @MainActor @preconcurrency */ public var content: Content
    /* @MainActor @preconcurrency */ public var axes: Axis.Set
    /* @MainActor @preconcurrency */ public var showsIndicators = true

    /* nonisolated */ public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    public typealias Body = Never
}

extension ScrollView {
    /* nonisolated */ public init(_ axes: Axis.Set = .vertical, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.content = content()
    }
}

extension ScrollView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ScrollView(bridgedAxes: Int(axes.rawValue), showsIndicators: showsIndicators, bridgedContent: content.Java_viewOrEmpty)
    }
}

public struct ScrollAnchorRole : Hashable /*, Sendable */ {
    public static var initialOffset: ScrollAnchorRole {
        return ScrollAnchorRole()
    }

    public static var sizeChanges: ScrollAnchorRole {
        return ScrollAnchorRole()
    }

    public static var alignment: ScrollAnchorRole {
        return ScrollAnchorRole()
    }
}

public struct ScrollBounceBehavior /* : Sendable */ {
    public static var automatic: ScrollBounceBehavior {
        return ScrollBounceBehavior()
    }

    public static var always: ScrollBounceBehavior {
        return ScrollBounceBehavior()
    }

    public static var basedOnSize: ScrollBounceBehavior {
        return ScrollBounceBehavior()
    }
}

public struct ScrollContentOffsetAdjustmentBehavior {
    public static var automatic: ScrollContentOffsetAdjustmentBehavior {
        return ScrollContentOffsetAdjustmentBehavior()
    }

    public static var disabled: ScrollContentOffsetAdjustmentBehavior {
        return ScrollContentOffsetAdjustmentBehavior()
    }
}

public struct ScrollDismissesKeyboardMode /* : Sendable */ {
    public static var automatic: ScrollDismissesKeyboardMode {
        return ScrollDismissesKeyboardMode()
    }

    public static var immediately: ScrollDismissesKeyboardMode {
        return ScrollDismissesKeyboardMode()
    }

    public static var interactively: ScrollDismissesKeyboardMode {
        return ScrollDismissesKeyboardMode()
    }

    public static var never: ScrollDismissesKeyboardMode {
        return ScrollDismissesKeyboardMode()
    }
}

public struct ScrollGeometry : Equatable /*, Sendable */ {
    public var contentOffset = CGPoint()
    public var contentSize = CGSize()
    public var contentInsets = EdgeInsets()
    public var containerSize = CGSize()

    @available(*, unavailable)
    public var visibleRect: CGRect {
        fatalError()
    }

    @available(*, unavailable)
    public var bounds: CGRect {
        fatalError()
    }

    public init() {
    }

    public init(contentOffset: CGPoint, contentSize: CGSize, contentInsets: EdgeInsets, containerSize: CGSize) {
        self.contentOffset = contentOffset
        self.contentSize = contentSize
        self.contentInsets = contentInsets
        self.containerSize = containerSize
    }
}

extension ScrollGeometry : CustomDebugStringConvertible {
    public var debugDescription: String {
        return "SkipFuseUI.ScrollGeometry: \(contentOffset)"
    }
}

public struct ScrollIndicatorVisibility : Equatable {
    public static var automatic: ScrollIndicatorVisibility {
        return ScrollIndicatorVisibility()
    }

    public static var visible: ScrollIndicatorVisibility {
        return ScrollIndicatorVisibility()
    }

    public static var hidden: ScrollIndicatorVisibility {
        return ScrollIndicatorVisibility()
    }

    public static var never: ScrollIndicatorVisibility {
        return ScrollIndicatorVisibility()
    }
}

public struct ScrollInputBehavior : /* Sendable, */ Equatable {
    public static let automatic = ScrollInputBehavior()
    public static let enabled = ScrollInputBehavior()
    public static let disabled = ScrollInputBehavior()
}

public struct ScrollInputKind : /* Sendable, */ Equatable {
}

@frozen public enum ScrollPhase : Hashable /*, BitwiseCopyable, Sendable */ {
    case idle
    case tracking
    case interacting
    case decelerating
    case animating

    public var isScrolling: Bool {
        switch self {
        case .idle:
            return false
        default:
            return true
        }
    }
}

extension ScrollPhase : CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .idle:
            return "idle"
        case .tracking:
            return "tracking"
        case .interacting:
            return "interacting"
        case .decelerating:
            return "decelerating"
        case .animating:
            return "animating"
        }
    }
}

public struct ScrollPhaseChangeContext {
    @available(*, unavailable)
    public var geometry: ScrollGeometry {
        fatalError()
    }

    @available(*, unavailable)
    public var velocity: CGVector? {
        fatalError()
    }
}

public struct ScrollPosition : Equatable /*, Sendable */ {
}

extension ScrollPosition {
    public init(id: some Hashable & Sendable, anchor: UnitPoint? = nil) {
    }

    public init(idType: (some Hashable & Sendable).Type = Never.self) {
    }

    public init(idType: (some Hashable & Sendable).Type = Never.self, edge: Edge) {
    }

    public init(idType: (some Hashable & Sendable).Type = Never.self, point: CGPoint) {
    }

    public init(idType: (some Hashable & Sendable).Type = Never.self, x: CGFloat, y: CGFloat) {
    }

    public init(idType: (some Hashable & Sendable).Type = Never.self, x: CGFloat) {
    }

    public init(idType: (some Hashable & Sendable).Type = Never.self, y: CGFloat) {
    }
}

extension ScrollPosition {
    @available(*, unavailable)
    public mutating func scrollTo(id: some Hashable & Sendable, anchor: UnitPoint? = nil) {
    }

    @available(*, unavailable)
    public mutating func scrollTo(edge: Edge) {
    }

    @available(*, unavailable)
    public mutating func scrollTo(point: CGPoint) {
    }

    @available(*, unavailable)
    public mutating func scrollTo(x: CGFloat, y: CGFloat) {
    }

    @available(*, unavailable)
    public mutating func scrollTo(x: CGFloat) {
    }

    @available(*, unavailable)
    public mutating func scrollTo(y: CGFloat) {
    }
}

extension ScrollPosition {
    @available(*, unavailable)
    public var isPositionedByUser: Bool {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }

    @available(*, unavailable)
    public var edge: Edge? {
        fatalError()
    }

    @available(*, unavailable)
    public var point: CGPoint? {
        fatalError()
    }

    @available(*, unavailable)
    public var viewID: (any Hashable & Sendable)? {
        fatalError()
    }

    @available(*, unavailable)
    public func viewID<T>(type: T.Type) -> T? where T : Hashable /*, T : Sendable */ {
        fatalError()
    }
}

public struct ScrollTarget : Hashable {
    public var rect: CGRect
    public var anchor: UnitPoint?

    // Manually implement `Hashable` because CGRect does not conform on our CI Swift version

    public func hash(into hasher: inout Hasher) {
        hasher.combine(anchor)
        hasher.combine(rect.origin.x)
        hasher.combine(rect.origin.y)
        hasher.combine(rect.size.width)
        hasher.combine(rect.size.height)
    }

    public static func ==(lhs: ScrollTarget, rhs: ScrollTarget) -> Bool {
        return lhs.anchor == rhs.anchor && lhs.rect.origin.x == rhs.rect.origin.x && lhs.rect.origin.y == rhs.rect.origin.y && lhs.rect.size.width == rhs.rect.size.width && lhs.rect.size.height == rhs.rect.size.height
    }
}

public protocol ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: Self.TargetContext)

    typealias TargetContext = ScrollTargetBehaviorContext

    var Java_scrollTargetBehavior: any SkipUI.ScrollTargetBehavior { get }
}

public struct PagingScrollTargetBehavior : ScrollTargetBehavior {
    @available(*, unavailable)
    public init() {
    }

    public func updateTarget(_ target: inout ScrollTarget, context: PagingScrollTargetBehavior.TargetContext) {
        fatalError()
    }

    public var Java_scrollTargetBehavior: any SkipUI.ScrollTargetBehavior {
        fatalError()
    }
}

extension ScrollTargetBehavior where Self == PagingScrollTargetBehavior {
    @available(*, unavailable)
    public static var paging: PagingScrollTargetBehavior {
        fatalError()
    }
}

public struct ViewAlignedScrollTargetBehavior : ScrollTargetBehavior {
    public struct LimitBehavior {
        let identifier: Int

        public static var automatic: ViewAlignedScrollTargetBehavior.LimitBehavior {
            return LimitBehavior(identifier: 1) // For bridging
        }

        public static var always: ViewAlignedScrollTargetBehavior.LimitBehavior {
            return LimitBehavior(identifier: 2) // For bridging
        }

        public static var alwaysByFew: ViewAlignedScrollTargetBehavior.LimitBehavior {
            return LimitBehavior(identifier: 3) // For bridging
        }

        public static var alwaysByOne: ViewAlignedScrollTargetBehavior.LimitBehavior {
            return LimitBehavior(identifier: 4) // For bridging
        }

        public static var never: ViewAlignedScrollTargetBehavior.LimitBehavior {
            return LimitBehavior(identifier: 3) // For bridging
        }
    }

    private let limitBehavior: LimitBehavior

    public init(limitBehavior: ViewAlignedScrollTargetBehavior.LimitBehavior = .automatic) {
        self.limitBehavior = limitBehavior
    }

    public func updateTarget(_ target: inout ScrollTarget, context: ViewAlignedScrollTargetBehavior.TargetContext) {
        fatalError()
    }

    public var Java_scrollTargetBehavior: any SkipUI.ScrollTargetBehavior {
        return SkipUI.ViewAlignedScrollTargetBehavior(bridgedLimitBehavior: limitBehavior.identifier)
    }
}

extension ScrollTargetBehavior where Self == ViewAlignedScrollTargetBehavior {
    public static var viewAligned: ViewAlignedScrollTargetBehavior {
        return viewAligned(limitBehavior: .automatic)
    }

    public static func viewAligned(limitBehavior: ViewAlignedScrollTargetBehavior.LimitBehavior) -> Self {
        return ViewAlignedScrollTargetBehavior(limitBehavior: limitBehavior)
    }
}

@dynamicMemberLookup public struct ScrollTargetBehaviorContext {
    @available(*, unavailable)
    public var originalTarget: ScrollTarget {
        fatalError()
    }

    @available(*, unavailable)
    public var velocity: CGVector {
        fatalError()
    }

    @available(*, unavailable)
    public var contentSize: CGSize {
        fatalError()
    }

    @available(*, unavailable)
    public var containerSize: CGSize {
        fatalError()
    }

    @available(*, unavailable)
    public var axes: Axis.Set {
        fatalError()
    }

    @available(*, unavailable)
    public subscript<T>(dynamicMember keyPath: KeyPath<EnvironmentValues, T>) -> T {
        fatalError()
    }
}

public struct ScrollTransitionConfiguration {
    public static func animated(_ animation: Animation = .default) -> ScrollTransitionConfiguration {
        return ScrollTransitionConfiguration()
    }

    public static let animated = ScrollTransitionConfiguration()

    public static func interactive(timingCurve: UnitCurve = .easeInOut) -> ScrollTransitionConfiguration {
        return ScrollTransitionConfiguration()
    }

    public static let interactive = ScrollTransitionConfiguration()
    public static let identity = ScrollTransitionConfiguration()

    public func animation(_ animation: Animation) -> ScrollTransitionConfiguration {
        return ScrollTransitionConfiguration()
    }

    public func threshold(_ threshold: ScrollTransitionConfiguration.Threshold) -> ScrollTransitionConfiguration {
        return ScrollTransitionConfiguration()
    }
}

extension ScrollTransitionConfiguration {
    public struct Threshold {
        public static let visible = ScrollTransitionConfiguration.Threshold()
        public static let hidden = ScrollTransitionConfiguration.Threshold()

        public static var centered: ScrollTransitionConfiguration.Threshold {
            return ScrollTransitionConfiguration.Threshold()
        }

        public static func visible(_ amount: Double) -> ScrollTransitionConfiguration.Threshold {
            return ScrollTransitionConfiguration.Threshold()
        }

        public func interpolated(towards other: ScrollTransitionConfiguration.Threshold, amount: Double) -> ScrollTransitionConfiguration.Threshold {
            return ScrollTransitionConfiguration.Threshold()
        }

        public func inset(by distance: Double) -> ScrollTransitionConfiguration.Threshold {
            return ScrollTransitionConfiguration.Threshold()
        }
    }
}

@frozen public enum ScrollTransitionPhase : Hashable /*, BitwiseCopyable */ {
    case topLeading
    case identity
    case bottomTrailing

    public var isIdentity: Bool {
        return self == .identity
    }

    public var value: Double {
        switch self {
        case .topLeading:
            return -1.0
        case .identity:
            return 0.0
        case .bottomTrailing:
            return 1.0
        }
    }
}

public struct ScrollViewProxy {
    let proxy: SkipUI.ScrollViewProxy

    public func scrollTo<ID>(_ id: ID, anchor: UnitPoint? = nil) where ID : Hashable {
        proxy.scrollTo(bridgedID: Java_swiftHashable(for: id), anchorX: anchor?.x, anchorY: anchor?.y)
    }
}

/* @MainActor */ @frozen /* @preconcurrency */ public struct ScrollViewReader<Content> : View where Content : View {
    /* @MainActor @preconcurrency */ public var content: (ScrollViewProxy) -> Content

    @inlinable /* nonisolated */ public init(@ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
        self.content = content
    }

    public typealias Body = Never
}

extension ScrollViewReader : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ScrollViewReader { skipUIProxy in
            let proxy = ScrollViewProxy(proxy: skipUIProxy)
            let view = self.content(proxy)
            return view.Java_viewOrEmpty
        }
    }
}

public struct PinnedScrollableViews : OptionSet /*, Sendable */ {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static let sectionHeaders = PinnedScrollableViews(rawValue: 1 << 0)
    public static let sectionFooters = PinnedScrollableViews(rawValue: 1 << 1)
}

extension View {
    @available(*, unavailable)
    /* nonisolated */ public func contentMargins(_ edges: Edge.Set = .all, _ insets: EdgeInsets, for placement: ContentMarginPlacement = .automatic) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func contentMargins(_ edges: Edge.Set = .all, _ length: CGFloat?, for placement: ContentMarginPlacement = .automatic) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func contentMargins(_ length: CGFloat, for placement: ContentMarginPlacement = .automatic) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func scrollBounceBehavior(_ behavior: ScrollBounceBehavior, axes: Axis.Set = [.vertical]) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func scrollClipDisabled(_ disabled: Bool = true) -> some View {
        stubView()
    }

    /* nonisolated */ public func scrollContentBackground(_ visibility: Visibility) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollContentBackground(bridgedVisibility: visibility.rawValue)
        }
    }

    @available(*, unavailable)
    /* nonisolated */ public func scrollDismissesKeyboard(_ mode: ScrollDismissesKeyboardMode) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func scrollDisabled(_ disabled: Bool) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func scrollIndicators(_ visibility: ScrollIndicatorVisibility, axes: Axis.Set = [.vertical, .horizontal]) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func scrollIndicatorsFlash(trigger value: some Equatable) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func scrollIndicatorsFlash(onAppear: Bool) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func scrollPosition(_ position: Binding<ScrollPosition>, anchor: UnitPoint? = nil) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func scrollPosition(id: Binding<(some Hashable)?>, anchor: UnitPoint? = nil) -> some View {
        stubView()
    }

    /* nonisolated */ public func scrollTargetBehavior(_ behavior: some ScrollTargetBehavior) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollTargetBehavior(behavior.Java_scrollTargetBehavior)
        }
    }

    /* nonisolated */ public func scrollTargetLayout(isEnabled: Bool = true) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollTargetLayout(isEnabled: isEnabled)
        }
    }
}

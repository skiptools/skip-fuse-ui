// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

public struct ScrollView<Content> where Content : View {
    public var content: Content
    public var axes: Axis.Set
    public var showsIndicators = true

    public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content()
    }
}

extension ScrollView : View {
    public typealias Body = Never
}

extension ScrollView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ScrollView(bridgedAxes: Int(axes.rawValue), showsIndicators: showsIndicators, bridgedContent: content.Java_viewOrEmpty)
    }
}

public struct ScrollAnchorRole : Hashable, Sendable {
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

public struct ScrollBounceBehavior : Sendable {
    let identifier: Int // For bridging

    public static var automatic: ScrollBounceBehavior {
        return ScrollBounceBehavior(identifier: 0)
    }

    public static var always: ScrollBounceBehavior {
        return ScrollBounceBehavior(identifier: 1)
    }

    public static var basedOnSize: ScrollBounceBehavior {
        return ScrollBounceBehavior(identifier: 2)
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

public struct ScrollDismissesKeyboardMode : Hashable, Sendable {
    let identifier: Int

    public static var automatic: ScrollDismissesKeyboardMode {
        return ScrollDismissesKeyboardMode(identifier: 1) // For bridging
    }

    public static var immediately: ScrollDismissesKeyboardMode {
        return ScrollDismissesKeyboardMode(identifier: 2) // For bridging
    }

    public static var interactively: ScrollDismissesKeyboardMode {
        return ScrollDismissesKeyboardMode(identifier: 3) // For bridging
    }

    public static var never: ScrollDismissesKeyboardMode {
        return ScrollDismissesKeyboardMode(identifier: 4) // For bridging
    }
}

public struct ScrollEdgeEffectStyle : Hashable, Sendable {
    let identifier: Int // For bridging

    public static var automatic: ScrollEdgeEffectStyle {
        return ScrollEdgeEffectStyle(identifier: 0)
    }
    public static var hard: ScrollEdgeEffectStyle {
        return ScrollEdgeEffectStyle(identifier: 1)
    }
    public static var soft: ScrollEdgeEffectStyle {
        return ScrollEdgeEffectStyle(identifier: 2)
    }
}

public struct ScrollGeometry : Equatable, Sendable {
    public var contentOffset = CGPoint()
    public var contentSize = CGSize()
    public var contentInsets = EdgeInsets()
    public var containerSize = CGSize()

    /// The content rectangle currently visible in the container.
    public var visibleRect: CGRect {
        return CGRect(origin: contentOffset, size: containerSize)
    }

    public var bounds: CGRect {
        return CGRect(origin: CGPoint(x: -contentInsets.leading, y: -contentInsets.top), size: containerSize)
    }

    public init() {
    }

    public init(contentOffset: CGPoint, contentSize: CGSize, contentInsets: EdgeInsets, containerSize: CGSize) {
        self.contentOffset = contentOffset
        self.contentSize = contentSize
        self.contentInsets = contentInsets
        self.containerSize = containerSize
    }

    /// Content offset, content size, insets (top, leading, bottom, trailing), and container size.
    init(bridgedValues values: [Double]) {
        self.init(contentOffset: CGPoint(x: values[0], y: values[1]), contentSize: CGSize(width: values[2], height: values[3]), contentInsets: EdgeInsets(top: values[4], leading: values[5], bottom: values[6], trailing: values[7]), containerSize: CGSize(width: values[8], height: values[9]))
    }
}

extension ScrollGeometry : CustomDebugStringConvertible {
    public var debugDescription: String {
        return "SkipSwiftUI.ScrollGeometry: \(contentOffset)"
    }
}

public struct ScrollIndicatorVisibility : Equatable {
    public let rawValue: Int

    private init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static var automatic: ScrollIndicatorVisibility {
        return ScrollIndicatorVisibility(rawValue: 0) // For bridging
    }

    public static var visible: ScrollIndicatorVisibility {
        return ScrollIndicatorVisibility(rawValue: 1) // For bridging
    }

    public static var hidden: ScrollIndicatorVisibility {
        return ScrollIndicatorVisibility(rawValue: 2) // For bridging
    }

    public static var never: ScrollIndicatorVisibility {
        return ScrollIndicatorVisibility(rawValue: 3) // For bridging
    }
}

public struct ScrollInputBehavior : Sendable, Equatable {
    public static let automatic = ScrollInputBehavior()
    public static let enabled = ScrollInputBehavior()
    public static let disabled = ScrollInputBehavior()
}

public struct ScrollInputKind : Sendable, Equatable {
}

@frozen public enum ScrollPhase : Hashable, BitwiseCopyable, Sendable {
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

public struct ScrollPosition : Equatable, Sendable {
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
    public func viewID<T>(type: T.Type) -> T? where T : Hashable, T : Sendable {
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

    @available(*, unavailable)
    public init(anchor: UnitPoint?) {
        fatalError()
    }

    @available(*, unavailable)
    public init(limitBehavior: ViewAlignedScrollTargetBehavior.LimitBehavior, anchor: UnitPoint?) {
        fatalError()
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

    @available(*, unavailable)
    public static func viewAligned(anchor: UnitPoint?) -> Self {
        fatalError()
    }

    @available(*, unavailable)
    public static func viewAligned(limitBehavior: ViewAlignedScrollTargetBehavior.LimitBehavior, anchor: UnitPoint?) -> Self {
        fatalError()
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

public struct ScrollTransitionConfiguration : Sendable {
    let identifier: Int // For bridging: 0 identity, 1 animated, 2 interactive

    public static func animated(_ animation: Animation = .default) -> ScrollTransitionConfiguration {
        return .animated
    }

    public static let animated = ScrollTransitionConfiguration(identifier: 1)

    public static func interactive(timingCurve: UnitCurve = .easeInOut) -> ScrollTransitionConfiguration {
        return .interactive
    }

    public static let interactive = ScrollTransitionConfiguration(identifier: 2)
    public static let identity = ScrollTransitionConfiguration(identifier: 0)

    public func animation(_ animation: Animation) -> ScrollTransitionConfiguration {
        return self
    }

    public func threshold(_ threshold: ScrollTransitionConfiguration.Threshold) -> ScrollTransitionConfiguration {
        return self
    }
}

extension ScrollTransitionConfiguration {
    public struct Threshold : Sendable {
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

@frozen public enum ScrollTransitionPhase : Hashable, BitwiseCopyable {
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

@frozen public struct ScrollViewReader<Content> where Content : View {
    public var content: (ScrollViewProxy) -> Content

    /* @inlinable */public init(@ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
        self.content = content
    }
}

extension ScrollViewReader : View {
    public typealias Body = Never
}

extension ScrollViewReader : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ScrollViewReader { skipUIProxy in
            let proxy = ScrollViewProxy(proxy: skipUIProxy)
            let view = content(proxy)
            return view.Java_viewOrEmpty
        }
    }
}

public struct PinnedScrollableViews : OptionSet, Sendable {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    @available(*, unavailable)
    public static let sectionHeaders = PinnedScrollableViews(rawValue: 1 << 0) // For bridging
    @available(*, unavailable)
    public static let sectionFooters = PinnedScrollableViews(rawValue: 1 << 1) // For bridging
}

extension View {
    /// Sets the content margins for this view.
    nonisolated public func contentMargins(_ edges: Edge.Set = .all, _ insets: EdgeInsets, for placement: ContentMarginPlacement = .automatic) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.contentMargins(Int(edges.rawValue), top: insets.top, leading: insets.leading, bottom: insets.bottom, trailing: insets.trailing, for: placement.rawValue)
        }
    }

    /// Sets the content margins for this view.
    nonisolated public func contentMargins(_ edges: Edge.Set = .all, _ length: CGFloat?, for placement: ContentMarginPlacement = .automatic) -> some View {
        let insets: EdgeInsets
        if let length {
            insets = EdgeInsets(top: edges.contains(.top) ? length : 0.0,
                                leading: edges.contains(.leading) ? length : 0.0,
                                bottom: edges.contains(.bottom) ? length : 0.0,
                                trailing: edges.contains(.trailing) ? length : 0.0)
        } else {
            insets = EdgeInsets()
        }
        return contentMargins(edges, insets, for: placement)
    }

    /// Sets the content margins for this view.
    nonisolated public func contentMargins(_ length: CGFloat, for placement: ContentMarginPlacement = .automatic) -> some View {
        return contentMargins(.all, length, for: placement)
    }

    nonisolated public func scrollBounceBehavior(_ behavior: ScrollBounceBehavior, axes: Axis.Set = [.vertical]) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollBounceBehavior(bridgedBehavior: behavior.identifier)
        }
    }

    @available(*, unavailable)
    nonisolated public func scrollClipDisabled(_ disabled: Bool = true) -> some View {
        stubView()
    }

    nonisolated public func scrollContentBackground(_ visibility: Visibility) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollContentBackground(bridgedVisibility: visibility.rawValue)
        }
    }

    nonisolated public func scrollDismissesKeyboard(_ mode: ScrollDismissesKeyboardMode) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollDismissesKeyboard(bridgedMode: mode.identifier)
        }
    }

    nonisolated public func scrollDisabled(_ disabled: Bool) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollDisabled(disabled)
        }
    }

    nonisolated public func scrollIndicators(_ visibility: ScrollIndicatorVisibility, axes: Axis.Set = [.vertical, .horizontal]) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollIndicators(bridgedVisibility: visibility.rawValue, bridgedAxes: Int(axes.rawValue))
        }
    }

    /// Briefly shows a `List`'s scroll indicator whenever `value` changes.
    nonisolated public func scrollIndicatorsFlash(trigger value: some Equatable) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollIndicatorsFlash(bridgedTrigger: Java_swiftEquatable(for: value), unusedp: nil)
        }
    }

    /// Briefly shows a `List`'s scroll indicator when it appears.
    nonisolated public func scrollIndicatorsFlash(onAppear: Bool) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollIndicatorsFlash(onAppear: onAppear)
        }
    }

    /// Treats a `List`'s content as it scrolls under an edge: `.soft` fades it out, `.hard` shows a crisp dividing edge.
    nonisolated public func scrollEdgeEffectStyle(_ style: ScrollEdgeEffectStyle?, for edges: Edge.Set) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollEdgeEffectStyle(bridgedStyle: style?.identifier, bridgedEdges: Int(edges.rawValue))
        }
    }

    /// The initial scroll position of a `List`; `.bottom` starts at the end and stays there as rows are added.
    nonisolated public func defaultScrollAnchor(_ anchor: UnitPoint?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.defaultScrollAnchor(anchorX: anchor?.x, anchorY: anchor?.y)
        }
    }

    /// Calls `action` when the value that `transform` derives from a `List`'s scroll geometry changes.
    nonisolated public func onScrollGeometryChange<T>(for type: T.Type, of transform: @escaping (ScrollGeometry) -> T, action: @escaping (_ oldValue: T, _ newValue: T) -> Void) -> some View where T : Equatable {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onScrollGeometryChange(bridgedTransform: { Java_swiftEquatable(for: transform(ScrollGeometry(bridgedValues: $0))) }, bridgedAction: { oldValue, newValue in
                guard let oldValue = (oldValue as? SwiftEquatable)?.value as? T, let newValue = (newValue as? SwiftEquatable)?.value as? T else {
                    return
                }
                action(oldValue, newValue)
            })
        }
    }

    /// Calls `action` when at least `threshold` of the view becomes visible, or stops being visible, in its scroll container.
    nonisolated public func onScrollVisibilityChange(threshold: Double = 0.5, _ action: @escaping (Bool) -> Void) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onScrollVisibilityChange(threshold: threshold, action)
        }
    }

    /// Applies effects as the view scrolls into and out of its scroll container's visible region.
    nonisolated public func scrollTransition(_ configuration: ScrollTransitionConfiguration = .interactive, axis: Axis? = nil, transition: @escaping (EmptyVisualEffect, ScrollTransitionPhase) -> some VisualEffect) -> some View {
        return scrollTransition(topLeading: configuration, bottomTrailing: configuration, axis: axis, transition: transition)
    }

    nonisolated public func scrollTransition(topLeading: ScrollTransitionConfiguration, bottomTrailing: ScrollTransitionConfiguration, axis: Axis? = nil, transition: @escaping (EmptyVisualEffect, ScrollTransitionPhase) -> some VisualEffect) -> some View {
        // Effects are resolved at each phase and interpolated in Compose
        let effects: [Double] = [ScrollTransitionPhase.identity, .topLeading, .bottomTrailing].flatMap { (transition(EmptyVisualEffect(), $0) as? EmptyVisualEffect ?? EmptyVisualEffect()).bridgedValues }
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollTransition(bridgedTopLeading: topLeading.identifier, bridgedBottomTrailing: bottomTrailing.identifier, bridgedAxis: Int(axis?.rawValue ?? Axis.vertical.rawValue), bridgedEffects: effects)
        }
    }

    @available(*, unavailable)
    nonisolated public func scrollPosition(_ position: Binding<ScrollPosition>, anchor: UnitPoint? = nil) -> some View {
        stubView()
    }

    nonisolated public func scrollPosition(id: Binding<AnyHashable?>, anchor: UnitPoint? = nil) -> some View {
        return ModifierView(target: self) {
            // Bridge to SkipUI using closure-based API
            let getId: () -> AnyHashable? = { id.wrappedValue }
            let setId: (AnyHashable?) -> Void = { id.wrappedValue = $0 }
            return $0.Java_viewOrEmpty.scrollPosition(getId: getId, setId: setId)
        }
    }

    nonisolated public func scrollTargetBehavior(_ behavior: some ScrollTargetBehavior) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollTargetBehavior(behavior.Java_scrollTargetBehavior)
        }
    }

    nonisolated public func scrollTargetLayout(isEnabled: Bool = true) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollTargetLayout(isEnabled: isEnabled)
        }
    }
}

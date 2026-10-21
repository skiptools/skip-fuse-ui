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
    public static var automatic: ScrollEdgeEffectStyle {
        return ScrollEdgeEffectStyle()
    }
    public static var hard: ScrollEdgeEffectStyle {
        return ScrollEdgeEffectStyle()
    }
    public static var soft: ScrollEdgeEffectStyle {
        return ScrollEdgeEffectStyle()
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

extension ScrollPhase {
    /// The phase with a `SkipUI.ScrollPhase` raw value.
    init(bridgedRawValue: Int) {
        self = [.idle, .tracking, .interacting, .decelerating, .animating][bridgedRawValue]
    }
}

public struct ScrollPhaseChangeContext {
    public let geometry: ScrollGeometry
    /// The velocity of the content in points per millisecond, which is zero except as the user flings it.
    public let velocity: CGVector?

    /// `ScrollGeometry` bridged values followed by the velocity's `dx` and `dy`.
    init(bridgedValues values: [Double]) {
        self.geometry = ScrollGeometry(bridgedValues: values)
        self.velocity = CGVector(dx: values[10], dy: values[11])
    }
}

/// Where a scroll view's content is scrolled to: a view ID, an edge, or a content offset.
public struct ScrollPosition : Equatable, @unchecked Sendable {
    public private(set) var edge: Edge?
    public var isPositionedByUser = false
    var id: AnyHashable?
    /// The content offset on each axis, nil to leave that axis where it is.
    var x: CGFloat?
    var y: CGFloat?
    var anchor: UnitPoint?
}

extension ScrollPosition {
    public init(id: some Hashable & Sendable, anchor: UnitPoint? = nil) {
        self.id = id
        self.anchor = anchor
    }

    public init(idType: (some Hashable & Sendable).Type = Never.self) {
    }

    public init(idType: (some Hashable & Sendable).Type = Never.self, edge: Edge) {
        self.edge = edge
    }

    public init(idType: (some Hashable & Sendable).Type = Never.self, point: CGPoint) {
        self.x = point.x
        self.y = point.y
    }

    public init(idType: (some Hashable & Sendable).Type = Never.self, x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }

    public init(idType: (some Hashable & Sendable).Type = Never.self, x: CGFloat) {
        self.x = x
    }

    public init(idType: (some Hashable & Sendable).Type = Never.self, y: CGFloat) {
        self.y = y
    }
}

extension ScrollPosition {
    public mutating func scrollTo(id: some Hashable & Sendable, anchor: UnitPoint? = nil) {
        self = ScrollPosition(id: id, anchor: anchor)
    }

    public mutating func scrollTo(edge: Edge) {
        self = ScrollPosition(edge: edge)
    }

    public mutating func scrollTo(point: CGPoint) {
        self = ScrollPosition(point: point)
    }

    public mutating func scrollTo(x: CGFloat, y: CGFloat) {
        self = ScrollPosition(x: x, y: y)
    }

    public mutating func scrollTo(x: CGFloat) {
        self = ScrollPosition(x: x)
    }

    public mutating func scrollTo(y: CGFloat) {
        self = ScrollPosition(y: y)
    }
}

extension ScrollPosition {
    /// The content offset, when the position sets both axes.
    public var point: CGPoint? {
        return x == nil || y == nil ? nil : CGPoint(x: x!, y: y!)
    }

    public var viewID: (any Hashable & Sendable)? {
        // IDs come from `ForEach` or `id`, so are Hashable, and `Sendable` can't be checked at runtime
        return id.map { $0.base as! any Hashable & Sendable }
    }

    public func viewID<T>(type: T.Type) -> T? where T : Hashable, T : Sendable {
        return id?.base as? T
    }

    var Java_scrollPosition: SkipUI.ScrollPosition {
        return SkipUI.ScrollPosition(bridgedID: id.map { Java_swiftHashable(for: $0) }, bridgedEdge: edge.map { Int($0.rawValue) }, x: x, y: y, anchorX: anchor?.x, anchorY: anchor?.y, isPositionedByUser: isPositionedByUser)
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

    @available(*, unavailable)
    nonisolated public func scrollBounceBehavior(_ behavior: ScrollBounceBehavior, axes: Axis.Set = [.vertical]) -> some View {
        stubView()
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

    @available(*, unavailable)
    nonisolated public func scrollIndicatorsFlash(trigger value: some Equatable) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func scrollIndicatorsFlash(onAppear: Bool) -> some View {
        stubView()
    }

    /// Calls `action` when the value that `transform` derives from a scroll view's geometry changes.
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

    nonisolated public func onScrollPhaseChange(_ action: @escaping (_ oldPhase: ScrollPhase, _ newPhase: ScrollPhase) -> Void) -> some View {
        return onScrollPhaseChange { oldPhase, newPhase, _ in
            action(oldPhase, newPhase)
        }
    }

    /// Calls `action` as a scroll view in this view starts and stops scrolling: when the user drags or flings it, and
    /// when the app scrolls it with animation.
    nonisolated public func onScrollPhaseChange(_ action: @escaping (_ oldPhase: ScrollPhase, _ newPhase: ScrollPhase, _ context: ScrollPhaseChangeContext) -> Void) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onScrollPhaseChange(bridgedAction: { values in
                action(ScrollPhase(bridgedRawValue: Int(values[0])), ScrollPhase(bridgedRawValue: Int(values[1])), ScrollPhaseChangeContext(bridgedValues: Array(values.dropFirst(2))))
            })
        }
    }

    /// Scrolls the scroll view in this view as `position` changes, and writes back the ID of the view the user scrolls to.
    nonisolated public func scrollPosition(_ position: Binding<ScrollPosition>, anchor: UnitPoint? = nil) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scrollPosition(getPosition: { position.wrappedValue.Java_scrollPosition }, onUserScroll: {
                var userPosition = ScrollPosition()
                // The ID arrives as the SwiftHashable that ForEach bridged it as
                let id = ($0 as? AnyHashable)?.base ?? $0
                userPosition.id = (id as? SwiftHashable)?.base as? AnyHashable
                position.wrappedValue = userPosition
            }, anchorX: anchor?.x, anchorY: anchor?.y)
        }
    }

    nonisolated public func scrollPosition<ID>(id: Binding<ID?>, anchor: UnitPoint? = nil) -> some View where ID : Hashable {
        return scrollPosition(Binding(get: {
            var position = ScrollPosition()
            position.id = id.wrappedValue.map { AnyHashable($0) }
            return position
        }, set: {
            id.wrappedValue = $0.id?.base as? ID
        }), anchor: anchor)
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

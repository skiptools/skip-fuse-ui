// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

/* @MainActor @preconcurrency */ public protocol ToolbarContent {
//    associatedtype Body : ToolbarContent
//
//    @ToolbarContentBuilder @MainActor /* @preconcurrency */ var body: Self.Body { get }
}

extension ToolbarContent {
    /* nonisolated */ public func hidden(_ hidden: Bool = true) -> some ToolbarContent {
        if hidden {
            return AnyToolbarContent(erasing: EmptyToolbarContent())
        } else {
            return AnyToolbarContent(erasing: self)
        }
    }
}

public protocol CustomizableToolbarContent : ToolbarContent /* where Self.Body : CustomizableToolbarContent */ {
}

extension Optional : ToolbarContent where Wrapped : ToolbarContent {
}

extension Optional : CustomizableToolbarContent where Wrapped : CustomizableToolbarContent {
}

func stubToolbarContent() -> EmptyToolbarContent {
    return EmptyToolbarContent()
}

public struct EmptyToolbarContent : ToolbarContent, CustomizableToolbarContent {
}

extension EmptyToolbarContent : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.EmptyView()
    }
}

/* @MainActor */ @frozen /* @preconcurrency */ public struct AnyToolbarContent : ToolbarContent {
    private let content: any ToolbarContent

    /* nonisolated */ public init<C>(_ content: C) where C : ToolbarContent {
        self.init(erasing: content)
    }

    /* nonisolated */ public init<C>(erasing content: C) where C : ToolbarContent {
        self.content = content
    }
}

extension AnyToolbarContent : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
    }
}

/* @MainActor */ @frozen /* @preconcurrency */ public struct AnyCustomizableToolbarContent : CustomizableToolbarContent {
    private let content: any CustomizableToolbarContent

    /* nonisolated */ public init<C>(_ content: C) where C : CustomizableToolbarContent {
        self.init(erasing: content)
    }

    /* nonisolated */ public init<C>(erasing content: C) where C : CustomizableToolbarContent {
        self.content = content
    }
}

extension AnyCustomizableToolbarContent : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
    }
}

extension CustomizableToolbarContent {
    /* nonisolated */ public func hidden(_ hidden: Bool = true) -> some CustomizableToolbarContent {
        if hidden {
            return AnyCustomizableToolbarContent(erasing: EmptyToolbarContent())
        } else {
            return AnyCustomizableToolbarContent(erasing: self)
        }
    }
}

extension CustomizableToolbarContent {
    /* nonisolated */ public func customizationBehavior(_ behavior: ToolbarCustomizationBehavior) -> some CustomizableToolbarContent {
        // Only `default` is @available, so can return self
        return self
    }
}

extension CustomizableToolbarContent {
    @available(*, unavailable)
    public func defaultCustomization(_ defaultVisibility: Visibility = .automatic, options: ToolbarCustomizationOptions = []) -> some CustomizableToolbarContent {
        stubToolbarContent()
    }
}

/* @MainActor @preconcurrency */ public struct ToolbarCommands : Commands {
    /* nonisolated */ public init() {
    }
}

public struct ToolbarCustomizationBehavior /* : Sendable */ {
    public static var `default`: ToolbarCustomizationBehavior {
        return ToolbarCustomizationBehavior()
    }

    @available(*, unavailable)
    public static var reorderable: ToolbarCustomizationBehavior {
        fatalError()
    }

    @available(*, unavailable)
    public static var disabled: ToolbarCustomizationBehavior {
        fatalError()
    }
}

public struct ToolbarCustomizationOptions : OptionSet /*, Sendable */ {
    public static var alwaysAvailable: ToolbarCustomizationOptions {
        return ToolbarCustomizationOptions(rawValue: 1 << 0)
    }

    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ToolbarDefaultItemKind {
    public static let sidebarToggle = ToolbarDefaultItemKind()

    public static let title = ToolbarDefaultItemKind()
}

/* @MainActor @preconcurrency */ public struct ToolbarItem<ID, Content> : ToolbarContent where Content : View {
    private let _id: ID
    private let placement: ToolbarItemPlacement
    private let content: Content
}

extension ToolbarItem where ID == () {
    /* nonisolated */ public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) {
        self._id = ()
        self.placement = placement
        self.content = content()
    }
}

extension ToolbarItem : CustomizableToolbarContent where ID == String {
    /* nonisolated */ public init(id: String, placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) {
        self._id = id
        self.placement = placement
        self.content = content()
    }

    @available(*, unavailable)
    /* nonisolated */ public init(id: String, placement: ToolbarItemPlacement = .automatic, showsByDefault: Bool, @ViewBuilder content: () -> Content) {
        fatalError()
    }
}

extension ToolbarItem : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let idString = _id as? String ?? ""
        return SkipUI.ToolbarItem(id: idString, bridgedPlacement: placement.identifier, bridgedContent: content.Java_viewOrEmpty)
    }
}

extension ToolbarItem : Identifiable where ID : Hashable {
    /* @MainActor @preconcurrency */ public var id: ID {
        return _id
    }
}

/* @MainActor @preconcurrency */ public struct ToolbarItemGroup<Content> : ToolbarContent where Content : View {
    private let placement: ToolbarItemPlacement
    private let content: Content

    /* nonisolated */ public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) {
        self.placement = placement
        self.content = content()
    }
}

extension ToolbarItemGroup : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ToolbarItemGroup(bridgedPlacement: placement.identifier, bridgedContent: content.Java_viewOrEmpty)
    }
}

extension ToolbarItemGroup {
    @available(*, unavailable)
    /* nonisolated */ public init<C, L>(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> C, @ViewBuilder label: () -> L) where /* Content == LabeledToolbarItemGroupContent<C, L>, */ C : View, L : View {
        fatalError()
    }
}

public struct ToolbarItemPlacement {
    public static let automatic = ToolbarItemPlacement(identifier: 0) // For bridging

    public static let principal = ToolbarItemPlacement(identifier: 1) // For bridging

    public static let navigation = ToolbarItemPlacement(identifier: 2) // For bridging

    public static let primaryAction = ToolbarItemPlacement(identifier: 3) // For bridging

    public static let secondaryAction = ToolbarItemPlacement(identifier: 4) // For bridging

    public static let status = ToolbarItemPlacement(identifier: 5) // For bridging

    public static let confirmationAction = ToolbarItemPlacement(identifier: 6) // For bridging

    public static let cancellationAction = ToolbarItemPlacement(identifier: 7) // For bridging

    public static let destructiveAction = ToolbarItemPlacement(identifier: 8) // For bridging

    public static let keyboard = ToolbarItemPlacement(identifier: 9) // For bridging

    public static let topBarLeading = ToolbarItemPlacement(identifier: 10) // For bridging

    public static let topBarTrailing = ToolbarItemPlacement(identifier: 11) // For bridging

    public static let bottomBar = ToolbarItemPlacement(identifier: 12) // For bridging

    public static let navigationBarLeading = ToolbarItemPlacement(identifier: 13) // For bridging

    public static let navigationBarTrailing = ToolbarItemPlacement(identifier: 14) // For bridging

    let identifier: Int // For bridging

    init(identifier: Int) {
        self.identifier = identifier
    }
}

public struct ToolbarLabelStyle : /* Sendable, */ Equatable {
    public static var automatic: ToolbarLabelStyle {
        return ToolbarLabelStyle()
    }
}

public struct ToolbarPlacement {
    public static var automatic: ToolbarPlacement {
        return ToolbarPlacement(identifier: 0) // For bridging
    }

    public static var bottomBar: ToolbarPlacement {
        return ToolbarPlacement(identifier: 1) // For bridging
    }

    public static var navigationBar: ToolbarPlacement {
        return ToolbarPlacement(identifier: 2) // For bridging
    }

    public static var tabBar: ToolbarPlacement {
        return ToolbarPlacement(identifier: 3) // For bridging
    }

    let identifier: Int // For bridging

    init(identifier: Int) {
        self.identifier = identifier
    }
}

public struct ToolbarRole /* : Sendable */ {
    public static var automatic: ToolbarRole {
        return ToolbarRole()
    }

    @available(*, unavailable)
    public static var editor: ToolbarRole {
        fatalError()
    }
}

public struct ToolbarTitleDisplayMode {
    public static var automatic: ToolbarTitleDisplayMode {
        return ToolbarTitleDisplayMode(identifier: 0) // For bridging
    }

    public static var large: ToolbarTitleDisplayMode {
        return ToolbarTitleDisplayMode(identifier: 1) // For bridging
    }

    public static var inlineLarge: ToolbarTitleDisplayMode {
        return ToolbarTitleDisplayMode(identifier: 2) // For bridging
    }

    public static var inline: ToolbarTitleDisplayMode {
        return ToolbarTitleDisplayMode(identifier: 3) // For bridging
    }

    let identifier: Int // For bridging

    init(identifier: Int) {
        self.identifier = identifier
    }
}

/* @MainActor @preconcurrency */ public struct ToolbarTitleMenu<Content> : ToolbarContent, CustomizableToolbarContent where Content : View {
    private let content: Content

    /* nonisolated */ public init() where Content == EmptyView {
        self.content = EmptyView()
    }

    /* nonisolated */ public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

//~~~ TODO when Group implemented
//extension Group : ToolbarContent where Content : ToolbarContent {
//    /* nonisolated */ public init(@ToolbarContentBuilder content: () -> Content) {
//        // TODO
//    }
//}
//
//extension Group : CustomizableToolbarContent where Content : CustomizableToolbarContent {
//    public init(@ToolbarContentBuilder content: () -> Content) {
//        // TODO
//    }
//}

@resultBuilder public struct ToolbarContentBuilder {
    public static func buildBlock() -> EmptyToolbarContent {
        return EmptyToolbarContent()
    }

    public static func buildExpression<Content>(_ content: Content) -> Content where Content : ToolbarContent {
        return content
    }

    public static func buildBlock<Content>(_ content: Content) -> Content where Content : ToolbarContent {
        return content
    }

    public static func buildBlock(_ content: (any ToolbarContent)...) -> TupleToolbarContent {
        return TupleToolbarContent(content)
    }

    public static func buildExpression<Content>(_ content: Content) -> Content where Content : CustomizableToolbarContent {
        return content
    }

    public static func buildBlock<Content>(_ content: Content) -> Content where Content : CustomizableToolbarContent {
        return content
    }

    public static func buildBlock(_ content: (any CustomizableToolbarContent)...) -> TupleToolbarContent {
        return TupleToolbarContent(content)
    }
}

extension ToolbarContentBuilder {
    public static func buildIf<Content>(_ content: Content?) -> Content? where Content : ToolbarContent {
        return content
    }

    public static func buildEither<TrueContent>(first: TrueContent) -> TrueContent where TrueContent : ToolbarContent {
        return first
    }

    public static func buildEither<FalseContent>(second: FalseContent) -> FalseContent where FalseContent : ToolbarContent {
        return second
    }

    public static func buildIf<Content>(_ content: Content?) -> Content? where Content : CustomizableToolbarContent {
        return content
    }

    public static func buildEither<TrueContent>(first: TrueContent) -> TrueContent where TrueContent : CustomizableToolbarContent {
        return first
    }

    public static func buildEither<FalseContent>(second: FalseContent) -> FalseContent where FalseContent : CustomizableToolbarContent {
        return second
    }
}

extension ToolbarContentBuilder {
    public static func buildLimitedAvailability<Content>(_ content: Content) -> Content where Content : ToolbarContent {
        return content
    }

    public static func buildLimitedAvailability<Content>(_ content: Content) -> Content where Content : CustomizableToolbarContent {
        return content
    }
}

public struct TupleToolbarContent : ToolbarContent, CustomizableToolbarContent {
    private let content: [any ToolbarContent]

    public init(_ content: [any ToolbarContent]) {
        self.content = content
    }
}

extension TupleToolbarContent : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let javaViews = content.compactMap { ($0 as? SkipUIBridging)?.Java_view }
        return SkipUI.ComposeBuilder(bridgedViews: javaViews)
    }
}

extension View {
    /* nonisolated */ public func toolbarBackground<S>(_ style: S, for bars: ToolbarPlacement...) -> some View where S : ShapeStyle {
        return ModifierView(target: self) {
            let javaStyle = style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.Color._clear
            return $0.Java_viewOrEmpty.toolbarBackground(javaStyle, bridgedPlacements: bars.map(\.identifier))
        }
    }

    /* nonisolated */ public func toolbarBackground(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbarBackgroundVisibility(bridgedVisibility: visibility.rawValue, bridgedPlacements: bars.map(\.identifier))
        }
    }

    /* nonisolated */ public func toolbarBackgroundVisibility(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbarBackgroundVisibility(bridgedVisibility: visibility.rawValue, bridgedPlacements: bars.map(\.identifier))
        }
    }

    /* nonisolated */ public func toolbarColorScheme(_ colorScheme: ColorScheme?, for bars: ToolbarPlacement...) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbarColorScheme(bridgedColorScheme: colorScheme?.rawValue, bridgedPlacements: bars.map(\.identifier))
        }
    }

    /* nonisolated */ public func toolbar(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbarVisibility(bridgedVisibility: visibility.rawValue, bridgedPlacements: bars.map(\.identifier))
        }
    }

    /* nonisolated */ public func toolbarVisibility(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbarVisibility(bridgedVisibility: visibility.rawValue, bridgedPlacements: bars.map(\.identifier))
        }
    }

    @available(*, unavailable)
    nonisolated public func toolbar(removing defaultItemKind: ToolbarDefaultItemKind?) -> some View {
        stubView()
    }

    /* nonisolated */ public func toolbar<Content>(@ViewBuilder content: () -> Content) -> some View where Content : View {
        let content = content()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbar(id: "", bridgedContent: content.Java_viewOrEmpty)
        }
    }

    /* nonisolated */ public func toolbar<Content>(@ToolbarContentBuilder content: () -> Content) -> some View where Content : ToolbarContent {
        let content = content()
        return ModifierView(target: self) {
            let javaContent = (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
            return $0.Java_viewOrEmpty.toolbar(id: "", bridgedContent: javaContent)
        }
    }

    /* nonisolated */ public func toolbar<Content>(id: String, @ToolbarContentBuilder content: () -> Content) -> some View where Content : CustomizableToolbarContent {
        let content = content()
        return ModifierView(target: self) {
            let javaContent = (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
            return $0.Java_viewOrEmpty.toolbar(id: "", bridgedContent: javaContent)
        }
    }

    @available(*, unavailable)
    /* nonisolated */ public func toolbarTitleMenu<C>(@ViewBuilder content: () -> C) -> some View where C : View {
        stubView()
    }

    /* nonisolated */ public func toolbarTitleDisplayMode(_ mode: ToolbarTitleDisplayMode) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbarTitleDisplayMode(bridgedMode: mode.identifier)
        }
    }

    /* nonisolated */ public func toolbarRole(_ role: ToolbarRole) -> some View {
        // Only .automatic is @available, so we can return self
        return self
    }
}

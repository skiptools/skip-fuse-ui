// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

@MainActor @preconcurrency public protocol ToolbarContent {
    associatedtype Body : ToolbarContent

    @ToolbarContentBuilder @MainActor @preconcurrency var body: Self.Body { get }
}

public protocol CustomizableToolbarContent : ToolbarContent where Self.Body : CustomizableToolbarContent {
}

extension Never : ToolbarContent, CustomizableToolbarContent {
}

extension Optional : ToolbarContent where Wrapped : ToolbarContent {
    public var body: AnyToolbarContent {
        switch self {
        case .none:
            return AnyToolbarContent(EmptyToolbarContent())
        case .some(let content):
            return AnyToolbarContent(content.body)
        }
    }
}

//extension Optional : CustomizableToolbarContent where Wrapped : CustomizableToolbarContent {
//}

func stubToolbarContent() -> EmptyToolbarContent {
    return EmptyToolbarContent()
}

public struct EmptyToolbarContent : ToolbarContent, CustomizableToolbarContent {
    public var body : Never { fatalError("Never") }
}

extension EmptyToolbarContent : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.EmptyView()
    }
}

@frozen public struct AnyToolbarContent {
    private let content: any ToolbarContent

    public init<C>(_ content: C) where C : ToolbarContent {
        self.init(erasing: content)
    }

    public init<C>(erasing content: C) where C : ToolbarContent {
        self.content = content
    }
}

extension AnyToolbarContent : ToolbarContent {
    public var body : Never { fatalError("Never") }
}

extension AnyToolbarContent : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
    }
}

@frozen public struct AnyCustomizableToolbarContent {
    private let content: any CustomizableToolbarContent

    public init<C>(_ content: C) where C : CustomizableToolbarContent {
        self.init(erasing: content)
    }

    public init<C>(erasing content: C) where C : CustomizableToolbarContent {
        self.content = content
    }
}

extension AnyCustomizableToolbarContent : CustomizableToolbarContent {
    public var body : Never { fatalError("Never") }
}

extension AnyCustomizableToolbarContent : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
    }
}

extension ToolbarContent {
    nonisolated public func hidden(_ hidden: Bool = true) -> some ToolbarContent {
        if hidden {
            return AnyToolbarContent(erasing: EmptyToolbarContent())
        } else {
            return AnyToolbarContent(erasing: self)
        }
    }
}

extension CustomizableToolbarContent {
    nonisolated public func hidden(_ hidden: Bool = true) -> some CustomizableToolbarContent {
        if hidden {
            return AnyCustomizableToolbarContent(erasing: EmptyToolbarContent())
        } else {
            return AnyCustomizableToolbarContent(erasing: self)
        }
    }
}

extension CustomizableToolbarContent {
    nonisolated public func customizationBehavior(_ behavior: ToolbarCustomizationBehavior) -> some CustomizableToolbarContent {
        // Only `default` is @available, so can return self
        return self
    }
}

extension CustomizableToolbarContent {
    @available(*, unavailable)
    nonisolated public func defaultCustomization(_ defaultVisibility: Visibility = .automatic, options: ToolbarCustomizationOptions = []) -> some CustomizableToolbarContent {
        stubToolbarContent()
    }
}

extension CustomizableToolbarContent {
    @available(*, unavailable)
    nonisolated public func sharedBackgroundVisibility(_ visibility: Visibility) -> some CustomizableToolbarContent {
        stubToolbarContent()
    }
}

extension CustomizableToolbarContent {
    @available(*, unavailable)
    nonisolated public func matchedTransitionSource(id: some Hashable, in namespace: Namespace.ID) -> some CustomizableToolbarContent {
        stubToolbarContent()
    }
}

public struct ToolbarCommands : Commands {
    nonisolated public init() {
    }
}

public struct ToolbarCustomizationBehavior : Sendable {
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

public struct ToolbarCustomizationOptions : OptionSet, Sendable {
    public static var alwaysAvailable: ToolbarCustomizationOptions {
        return ToolbarCustomizationOptions(rawValue: 1 << 0)
    }

    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ToolbarDefaultItemKind : Sendable {
    public static let sidebarToggle = ToolbarDefaultItemKind(identifier: 1) // For bridging
    public static let title = ToolbarDefaultItemKind(identifier: 2) // For bridging
    public static let search = ToolbarDefaultItemKind(identifier: 3) // For bridging

    let identifier: Int // For bridging
}

public struct ToolbarItem<ID, Content> where Content : View {
    private let _id: ID
    private let placement: ToolbarItemPlacement
    private let content: Content
}

extension ToolbarItem: ToolbarContent {
    public var body : Never { fatalError("Never") }
}

extension ToolbarItem where ID == () {
    public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) {
        self._id = ()
        self.placement = placement
        self.content = content()
    }
}

extension ToolbarItem : CustomizableToolbarContent where ID == String {
    nonisolated public init(id: String, placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) {
        self._id = id
        self.placement = placement
        self.content = content()
    }

    @available(*, unavailable)
    nonisolated public init(id: String, placement: ToolbarItemPlacement = .automatic, showsByDefault: Bool, @ViewBuilder content: () -> Content) {
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
    /* @MainActor @preconcurrency */nonisolated public var id: ID {
        return _id
    }
}

public struct DefaultToolbarItem : ToolbarContent {
    @available(*, unavailable)
    nonisolated public init(kind: ToolbarDefaultItemKind, placement: ToolbarItemPlacement = .automatic) {
    }

    public var body : Never { fatalError("Never") }
}

public struct ToolbarItemGroup<Content> where Content : View {
    private let placement: ToolbarItemPlacement
    private let content: Content

    nonisolated public init(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) {
        self.placement = placement
        self.content = content()
    }
}

extension ToolbarItemGroup : ToolbarContent {
    public var body : Never { fatalError("Never") }
}

extension ToolbarItemGroup : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ToolbarItemGroup(bridgedPlacement: placement.identifier, bridgedContent: content.Java_viewOrEmpty)
    }
}

extension ToolbarItemGroup {
    @available(*, unavailable)
    nonisolated public init<C, L>(placement: ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> C, @ViewBuilder label: () -> L) where /* Content == LabeledToolbarItemGroupContent<C, L>, */ C : View, L : View {
        fatalError()
    }
}

public struct ToolbarSpacer {
    private let sizing: SpacerSizing
    private let placement: ToolbarItemPlacement

    public init(_ sizing: SpacerSizing = .flexible, placement: ToolbarItemPlacement = .automatic) {
        self.sizing = sizing
        self.placement = placement
    }
}

extension ToolbarSpacer : ToolbarContent, CustomizableToolbarContent {
    public var body : Never { fatalError("Never") }
}

extension ToolbarSpacer : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ToolbarSpacer(bridgedSizing: sizing.identifier, bridgedPlacement: placement.identifier)
    }
}

public struct ToolbarItemPlacement : Sendable {
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
    @available(*, unavailable)
    public static let title = ToolbarItemPlacement(identifier: 15) // For bridging
    @available(*, unavailable)
    public static let largeTitle = ToolbarItemPlacement(identifier: 16) // For bridging
    @available(*, unavailable)
    public static let subtitle = ToolbarItemPlacement(identifier: 17) // For bridging
    @available(*, unavailable)
    public static let largeSubtitle = ToolbarItemPlacement(identifier: 18) // For bridging

    let identifier: Int // For bridging

    init(identifier: Int) {
        self.identifier = identifier
    }
}

public struct ToolbarLabelStyle : Sendable, Equatable {
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

public struct ToolbarRole : Sendable {
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

public struct ToolbarTitleMenu<Content> where Content : View {
    private let content: Content

    public init() where Content == EmptyView {
        self.content = EmptyView()
    }

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

extension ToolbarTitleMenu : ToolbarContent, CustomizableToolbarContent {
    public var body : Never { fatalError("Never") }
}

extension ToolbarTitleMenu : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ToolbarTitleMenu(bridgedContent: content.Java_viewOrEmpty)
    }
}

extension Group : ToolbarContent where Content : ToolbarContent {
    nonisolated public init(@ToolbarContentBuilder content: () -> Content) {
        self.content = content()
    }

    public var body : Never { fatalError("Never") }
}

extension Group : CustomizableToolbarContent where Content : CustomizableToolbarContent {
    nonisolated public init(@ToolbarContentBuilder content: () -> Content) {
        self.content = content()
    }
}

@resultBuilder public struct ToolbarContentBuilder {
    public static func buildExpression<Content>(_ content: Content) -> Content where Content : ToolbarContent {
        return content
    }

    public static func buildExpression<Content>(_ content: Content) -> Content where Content : CustomizableToolbarContent {
        return content
    }

    public static func buildIf<Content>(_ content: Content?) -> Content? where Content : ToolbarContent {
        return content
    }

    public static func buildIf<Content>(_ content: Content?) -> Content? where Content : CustomizableToolbarContent {
        return content
    }

    public static func buildEither<TrueContent>(first: TrueContent) -> AnyToolbarContent where TrueContent : ToolbarContent {
        return AnyToolbarContent(first)
    }

    public static func buildEither<FalseContent>(second: FalseContent) -> AnyToolbarContent where FalseContent : ToolbarContent {
        return AnyToolbarContent(second)
    }

    public static func buildEither<TrueContent>(first: TrueContent) -> AnyCustomizableToolbarContent where TrueContent : CustomizableToolbarContent {
        return AnyCustomizableToolbarContent(first)
    }

    public static func buildEither<FalseContent>(second: FalseContent) -> AnyCustomizableToolbarContent where FalseContent : CustomizableToolbarContent {
        return AnyCustomizableToolbarContent(second)
    }

    public static func buildLimitedAvailability<Content>(_ content: Content) -> Content where Content : ToolbarContent {
        return content
    }

    public static func buildLimitedAvailability<Content>(_ content: Content) -> Content where Content : CustomizableToolbarContent {
        return content
    }

    public static func buildBlock() -> EmptyToolbarContent {
        return EmptyToolbarContent()
    }

    public static func buildBlock<Content>(_ content: Content) -> Content where Content : ToolbarContent {
        return content
    }

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent {
        return TupleToolbarContent([c0, c1])
    }

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2])
    }

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3])
    }

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent, C9 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent, C9 : ToolbarContent, C10 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent, C9 : ToolbarContent, C10 : ToolbarContent, C11 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent, C9 : ToolbarContent, C10 : ToolbarContent, C11 : ToolbarContent, C12 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent, C9 : ToolbarContent, C10 : ToolbarContent, C11 : ToolbarContent, C12 : ToolbarContent, C13 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent, C9 : ToolbarContent, C10 : ToolbarContent, C11 : ToolbarContent, C12 : ToolbarContent, C13 : ToolbarContent, C14 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent, C9 : ToolbarContent, C10 : ToolbarContent, C11 : ToolbarContent, C12 : ToolbarContent, C13 : ToolbarContent, C14 : ToolbarContent, C15 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent, C9 : ToolbarContent, C10 : ToolbarContent, C11 : ToolbarContent, C12 : ToolbarContent, C13 : ToolbarContent, C14 : ToolbarContent, C15 : ToolbarContent, C16 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16, _ c17: C17) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent, C9 : ToolbarContent, C10 : ToolbarContent, C11 : ToolbarContent, C12 : ToolbarContent, C13 : ToolbarContent, C14 : ToolbarContent, C15 : ToolbarContent, C16 : ToolbarContent, C17 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17, C18>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16, _ c17: C17, _ c18: C18) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent, C9 : ToolbarContent, C10 : ToolbarContent, C11 : ToolbarContent, C12 : ToolbarContent, C13 : ToolbarContent, C14 : ToolbarContent, C15 : ToolbarContent, C16 : ToolbarContent, C17 : ToolbarContent, C18 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17, C18, C19>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16, _ c17: C17, _ c18: C18, _ c19: C19) -> TupleToolbarContent where C0 : ToolbarContent, C1 : ToolbarContent, C2 : ToolbarContent, C3 : ToolbarContent, C4 : ToolbarContent, C5 : ToolbarContent, C6 : ToolbarContent, C7 : ToolbarContent, C8 : ToolbarContent, C9 : ToolbarContent, C10 : ToolbarContent, C11 : ToolbarContent, C12 : ToolbarContent, C13 : ToolbarContent, C14 : ToolbarContent, C15 : ToolbarContent, C16 : ToolbarContent, C17 : ToolbarContent, C18 : ToolbarContent, C19 : ToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19])
    }

    public static func buildBlock<Content>(_ content: Content) -> Content where Content : CustomizableToolbarContent {
        return content
    }

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1])
    }

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2])
    }

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3])
    }

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : ToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent, C9 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent, C9 : CustomizableToolbarContent, C10 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent, C9 : CustomizableToolbarContent, C10 : CustomizableToolbarContent, C11 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent, C9 : CustomizableToolbarContent, C10 : CustomizableToolbarContent, C11 : CustomizableToolbarContent, C12 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent, C9 : CustomizableToolbarContent, C10 : CustomizableToolbarContent, C11 : CustomizableToolbarContent, C12 : CustomizableToolbarContent, C13 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent, C9 : CustomizableToolbarContent, C10 : CustomizableToolbarContent, C11 : CustomizableToolbarContent, C12 : CustomizableToolbarContent, C13 : CustomizableToolbarContent, C14 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent, C9 : CustomizableToolbarContent, C10 : CustomizableToolbarContent, C11 : CustomizableToolbarContent, C12 : CustomizableToolbarContent, C13 : CustomizableToolbarContent, C14 : CustomizableToolbarContent, C15 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent, C9 : CustomizableToolbarContent, C10 : CustomizableToolbarContent, C11 : CustomizableToolbarContent, C12 : CustomizableToolbarContent, C13 : CustomizableToolbarContent, C14 : CustomizableToolbarContent, C15 : CustomizableToolbarContent, C16 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16, _ c17: C17) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent, C9 : CustomizableToolbarContent, C10 : CustomizableToolbarContent, C11 : CustomizableToolbarContent, C12 : CustomizableToolbarContent, C13 : CustomizableToolbarContent, C14 : CustomizableToolbarContent, C15 : CustomizableToolbarContent, C16 : CustomizableToolbarContent, C17 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17, C18>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16, _ c17: C17, _ c18: C18) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent, C9 : CustomizableToolbarContent, C10 : CustomizableToolbarContent, C11 : CustomizableToolbarContent, C12 : CustomizableToolbarContent, C13 : CustomizableToolbarContent, C14 : CustomizableToolbarContent, C15 : CustomizableToolbarContent, C16 : CustomizableToolbarContent, C17 : CustomizableToolbarContent, C18 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17, C18, C19>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16, _ c17: C17, _ c18: C18, _ c19: C19) -> TupleToolbarContent where C0 : CustomizableToolbarContent, C1 : CustomizableToolbarContent, C2 : CustomizableToolbarContent, C3 : CustomizableToolbarContent, C4 : CustomizableToolbarContent, C5 : CustomizableToolbarContent, C6 : CustomizableToolbarContent, C7 : CustomizableToolbarContent, C8 : CustomizableToolbarContent, C9 : CustomizableToolbarContent, C10 : CustomizableToolbarContent, C11 : CustomizableToolbarContent, C12 : CustomizableToolbarContent, C13 : CustomizableToolbarContent, C14 : CustomizableToolbarContent, C15 : CustomizableToolbarContent, C16 : CustomizableToolbarContent, C17 : CustomizableToolbarContent, C18 : CustomizableToolbarContent, C19 : CustomizableToolbarContent {
        return TupleToolbarContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19])
    }
}

public struct TupleToolbarContent {
    private let content: [any ToolbarContent]

    nonisolated public init(_ content: [any ToolbarContent]) {
        self.content = content
    }
}

extension TupleToolbarContent : ToolbarContent, CustomizableToolbarContent {
    public var body : Never { fatalError("Never") }
}

extension TupleToolbarContent : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let javaViews = content.compactMap { ($0 as? SkipUIBridging)?.Java_view }
        return SkipUI.ComposeBuilder(bridgedViews: javaViews)
    }
}

extension View {
    nonisolated public func toolbarBackground<S>(_ style: S, for bars: ToolbarPlacement...) -> some View where S : ShapeStyle {
        return ModifierView(target: self) {
            let javaStyle = style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.Color._clear
            return $0.Java_viewOrEmpty.toolbarBackground(javaStyle, bridgedPlacements: bars.map(\.identifier))
        }
    }

    nonisolated public func toolbarBackground(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbarBackgroundVisibility(bridgedVisibility: visibility.rawValue, bridgedPlacements: bars.map(\.identifier))
        }
    }

    nonisolated public func toolbarBackgroundVisibility(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbarBackgroundVisibility(bridgedVisibility: visibility.rawValue, bridgedPlacements: bars.map(\.identifier))
        }
    }

    nonisolated public func toolbarColorScheme(_ colorScheme: ColorScheme?, for bars: ToolbarPlacement...) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbarColorScheme(bridgedColorScheme: colorScheme?.rawValue, bridgedPlacements: bars.map(\.identifier))
        }
    }

    nonisolated public func toolbar(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbarVisibility(bridgedVisibility: visibility.rawValue, bridgedPlacements: bars.map(\.identifier))
        }
    }

    nonisolated public func toolbarVisibility(_ visibility: Visibility, for bars: ToolbarPlacement...) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbarVisibility(bridgedVisibility: visibility.rawValue, bridgedPlacements: bars.map(\.identifier))
        }
    }

    @available(*, unavailable)
    nonisolated public func toolbar(removing defaultItemKind: ToolbarDefaultItemKind?) -> some View {
        stubView()
    }

    nonisolated public func toolbar<Content>(@ViewBuilder content: () -> Content) -> some View where Content : View {
        let content = content()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbar(id: "", bridgedContent: content.Java_viewOrEmpty)
        }
    }

    nonisolated public func toolbar<Content>(@ToolbarContentBuilder content: () -> Content) -> some View where Content : ToolbarContent {
        let content = content()
        return ModifierView(target: self) {
            let javaContent = (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
            return $0.Java_viewOrEmpty.toolbar(id: "", bridgedContent: javaContent)
        }
    }

    nonisolated public func toolbar<Content>(id: String, @ToolbarContentBuilder content: () -> Content) -> some View where Content : CustomizableToolbarContent {
        let content = content()
        return ModifierView(target: self) {
            let javaContent = (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
            return $0.Java_viewOrEmpty.toolbar(id: "", bridgedContent: javaContent)
        }
    }

    nonisolated public func toolbarTitleMenu<C>(@ViewBuilder content: () -> C) -> some View where C : View {
        let content = content()
        return ModifierView(target: self) {
            let javaContent = (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
            return $0.Java_viewOrEmpty.toolbarTitleMenu(bridgedContent: javaContent)
        }
    }

    nonisolated public func toolbarTitleDisplayMode(_ mode: ToolbarTitleDisplayMode) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.toolbarTitleDisplayMode(bridgedMode: mode.identifier)
        }
    }

    nonisolated public func toolbarRole(_ role: ToolbarRole) -> some View {
        // Only .automatic is @available, so we can return self
        return self
    }
}

// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipFuse
import SkipUI

public struct TabView<SelectionValue, Content> where SelectionValue : Hashable /*, Content : View */ {
    private let selection: Binding<SelectionValue>?
    private let content: Content

    nonisolated public init(selection: Binding<SelectionValue>?, @ViewBuilder content: () -> Content) where Content : View {
        self.selection = selection
        self.content = content()
    }

    nonisolated public init(selection: Binding<SelectionValue>?, @TabContentBuilder<SelectionValue> content: () -> Content /* C */) where /* Content == TabContentBuilder<SelectionValue>.Content<C>, C */ Content : TabContent {
        self.selection = selection
        self.content = content()
    }
}

extension TabView : View {
    public typealias Body = Never
}

extension TabView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let selectionGet: (() -> Any)?
        let selectionSet: ((Any) -> Void)?
        if let selection {
            selectionGet = { Java_swiftHashable(for: selection.get()) }
            selectionSet = { selection.set(($0 as! SwiftHashable).base as! SelectionValue) }
        } else {
            selectionGet = nil
            selectionSet = nil
        }
        return SkipUI.TabView(selectionGet: selectionGet, selectionSet: selectionSet, bridgedContent: (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView())
    }
}

extension TabView where SelectionValue == Int {
    nonisolated public init(@ViewBuilder content: () -> Content) where Content : View {
        self.init(selection: nil, content: content)
    }
}

extension TabView {
    nonisolated public init(@TabContentBuilder<Never> content: () -> Content /* C */) where SelectionValue == Never, /* Content == TabContentBuilder<Never>.Content<C>, C */ Content : TabContent {
        self.init(selection: nil, content: content)
    }
}

extension View {
    nonisolated public func tabItem<V>(@ViewBuilder _ label: () -> V) -> some View where V : View {
        let label = label()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.tabItem(bridgedLabel: label.Java_viewOrEmpty)
        }
    }

    nonisolated public func tabViewStyle<S>(_ style: S) -> some View where S : TabViewStyle {
        return ModifierView(target: self) {
            let displayMode = (style as? PageTabViewStyle)?.indexDisplayMode.rawValue
            return $0.Java_viewOrEmpty.tabViewStyle(bridgedStyle: style.identifier, bridgedDisplayMode: displayMode)
        }
    }

    nonisolated public func tabBarMinimizeBehavior(_ behavior: TabBarMinimizeBehavior) -> some View {
        // We only support automatic, never
        return self
    }
}

public struct TabBarMinimizeBehavior : Hashable, Sendable {
    public static let automatic = TabBarMinimizeBehavior(identity: 1)
    @available(*, unavailable)
    public static let onScrollDown = TabBarMinimizeBehavior(identity: 2)
    @available(*, unavailable)
    public static let onScrollUp = TabBarMinimizeBehavior(identity: 3)
    public static let never = TabBarMinimizeBehavior(identity: 4)

    let identity: Int

    init(identity: Int) {
        self.identity = identity
    }
}

@MainActor @preconcurrency public protocol TabViewStyle {
    nonisolated var identifier: Int { get } // For bridging
}

extension TabViewStyle {
    nonisolated public var identifier: Int {
        return -1
    }
}

@MainActor @preconcurrency public struct SidebarAdaptableTabViewStyle : TabViewStyle {
    @available(*, unavailable)
    nonisolated public init() {
    }
}

extension TabViewStyle where Self == SidebarAdaptableTabViewStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var sidebarAdaptable: SidebarAdaptableTabViewStyle {
        fatalError()
    }
}

@MainActor @preconcurrency public struct TabBarOnlyTabViewStyle : TabViewStyle {
    nonisolated public init() {
    }

    public let identifier = 1 // For bridging
}

extension TabViewStyle where Self == TabBarOnlyTabViewStyle {
    @MainActor @preconcurrency public static var tabBarOnly: TabBarOnlyTabViewStyle {
        return TabBarOnlyTabViewStyle()
    }
}

@MainActor @preconcurrency public struct DefaultTabViewStyle : TabViewStyle {
    nonisolated public init() {
    }

    public let identifier = 0 // For bridging
}

extension TabViewStyle where Self == DefaultTabViewStyle {
    @MainActor @preconcurrency public static var automatic: DefaultTabViewStyle {
        return DefaultTabViewStyle()
    }
}

@MainActor @preconcurrency public struct GroupedTabViewStyle : TabViewStyle {
    @available(*, unavailable)
    nonisolated public init() {
    }
}

extension TabViewStyle where Self == GroupedTabViewStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var grouped: GroupedTabViewStyle {
        fatalError()
    }
}

@MainActor @preconcurrency public struct PageTabViewStyle: TabViewStyle, Sendable {
    public let indexDisplayMode: PageTabViewStyle.IndexDisplayMode

    public struct IndexDisplayMode : RawRepresentable, Equatable, Sendable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let automatic = IndexDisplayMode(rawValue: 0) // For bridging
        public static let always = IndexDisplayMode(rawValue: 1) // For bridging
        public static let never = IndexDisplayMode(rawValue: 2) // For bridging
    }

    nonisolated public init(indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic) {
        self.indexDisplayMode = indexDisplayMode
    }

    public let identifier = 2 // For bridging
}

extension TabViewStyle where Self == PageTabViewStyle {
    @MainActor @preconcurrency public static var page: PageTabViewStyle {
        return PageTabViewStyle()
    }

    @MainActor @preconcurrency public static func page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode) -> PageTabViewStyle {
        return PageTabViewStyle(indexDisplayMode: indexDisplayMode)
    }
}

public typealias DefaultTabLabel = Label<Text, Image>

public struct Tab<Value, Content, Label> {
    private let label: Label?
    private let content: Content
    private let value: Value?
    private let role: TabRole?

    public var modifiers: [(any SkipUI.View) -> any SkipUI.View] = []
}

extension Tab : TabContent where Value : Hashable, Content : View, Label : View {
    public typealias TabValue = Value

    @_disfavoredOverload nonisolated public init<S>(_ title: S, image: String, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol {
        self.init(title, image: image, value: value, role: nil, content: content)
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, image: String, value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol {
        self.content = content()
        self.label = DefaultTabLabel(title, image: image)
        self.value = value
        self.role = role
    }

    @_disfavoredOverload nonisolated public init<S, T>(_ title: S, image: String, value: T, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, S : StringProtocol, T : Hashable {
        self.init(title, image: image, value: value, role: nil, content: content)
    }

    @_disfavoredOverload nonisolated public init<S, T>(_ title: S, image: String, value: T, role: TabRole?, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, S : StringProtocol, T : Hashable {
        self.content = content()
        self.label = DefaultTabLabel(title, image: image)
        self.value = value
        self.role = role
    }

    nonisolated public init(_ titleKey: LocalizedStringKey, image: String, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleKey, image: image, value: value, role: nil, content: content)
    }

    @_disfavoredOverload nonisolated public init(_ titleResource: AndroidLocalizedStringResource, image: String, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleResource, image: image, value: value, role: nil, content: content)
    }

    nonisolated public init(_ titleKey: LocalizedStringKey, image: String, value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.content = content()
        self.label = DefaultTabLabel(titleKey, image: image)
        self.value = value
        self.role = role
    }

    @_disfavoredOverload nonisolated public init(_ titleResource: AndroidLocalizedStringResource, image: String, value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.content = content()
        self.label = DefaultTabLabel(titleResource, image: image)
        self.value = value
        self.role = role
    }

    nonisolated public init<T>(_ titleKey: LocalizedStringKey, image: String, value: T, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable {
        self.init(titleKey, image: image, value: value, role: nil, content: content)
    }

    @_disfavoredOverload nonisolated public init<T>(_ titleResource: AndroidLocalizedStringResource, image: String, value: T, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable {
        self.init(titleResource, image: image, value: value, role: nil, content: content)
    }

    nonisolated public init<T>(_ titleKey: LocalizedStringKey, image: String, value: T, role: TabRole?, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable {
        self.content = content()
        self.label = DefaultTabLabel(titleKey, image: image)
        self.value = value
        self.role = role
    }

    @_disfavoredOverload nonisolated public init<T>(_ titleResource: AndroidLocalizedStringResource, image: String, value: T, role: TabRole?, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable {
        self.content = content()
        self.label = DefaultTabLabel(titleResource, image: image)
        self.value = value
        self.role = role
    }

    nonisolated public init<S>(_ title: S, systemImage: String, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol {
        self.init(title, systemImage: systemImage, value: value, role: nil, content: content)
    }

    nonisolated public init<S>(_ title: S, systemImage: String, value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol {
        self.content = content()
        self.label = DefaultTabLabel(title, systemImage: systemImage)
        self.value = value
        self.role = role
    }

    @_disfavoredOverload nonisolated public init<S, T>(_ title: S, systemImage: String, value: T, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, S : StringProtocol, T : Hashable {
        self.init(title, systemImage: systemImage, value: value, role: nil, content: content)
    }

    @_disfavoredOverload nonisolated public init<S, T>(_ title: S, systemImage: String, value: T, role: TabRole?, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, S : StringProtocol, T : Hashable {
        self.content = content()
        self.label = DefaultTabLabel(title, systemImage: systemImage)
        self.value = value
        self.role = role
    }

    nonisolated public init(_ titleKey: LocalizedStringKey, systemImage: String, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleKey, systemImage: systemImage, value: value, role: nil, content: content)
    }

    @_disfavoredOverload nonisolated public init(_ titleResource: AndroidLocalizedStringResource, systemImage: String, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleResource, systemImage: systemImage, value: value, role: nil, content: content)
    }

    nonisolated public init(_ titleKey: LocalizedStringKey, systemImage: String, value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.content = content()
        self.label = DefaultTabLabel(titleKey, systemImage: systemImage)
        self.value = value
        self.role = role
    }

    @_disfavoredOverload nonisolated public init(_ titleResource: AndroidLocalizedStringResource, systemImage: String, value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.content = content()
        self.label = DefaultTabLabel(titleResource, systemImage: systemImage)
        self.value = value
        self.role = role
    }

    nonisolated public init<T>(_ titleKey: LocalizedStringKey, systemImage: String, value: T, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable {
        self.init(titleKey, systemImage: systemImage, value: value, role: nil, content: content)
    }

    @_disfavoredOverload nonisolated public init<T>(_ titleResource: AndroidLocalizedStringResource, systemImage: String, value: T, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable {
        self.init(titleResource, systemImage: systemImage, value: value, role: nil, content: content)
    }

    nonisolated public init<T>(_ titleKey: LocalizedStringKey, systemImage: String, value: T, role: TabRole?, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable {
        self.content = content()
        self.label = DefaultTabLabel(titleKey, systemImage: systemImage)
        self.value = value
        self.role = role
    }

    @_disfavoredOverload nonisolated public init<T>(_ titleResource: AndroidLocalizedStringResource, systemImage: String, value: T, role: TabRole?, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable {
        self.content = content()
        self.label = DefaultTabLabel(titleResource, systemImage: systemImage)
        self.value = value
        self.role = role
    }

    nonisolated public init(value: Value, @ViewBuilder content: () -> Content) where Label == EmptyView {
        self.content = content()
        self.label = nil
        self.value = value
        self.role = nil
    }

    nonisolated public init<V>(value: V, @ViewBuilder content: () -> Content) where Value == V?, Label == EmptyView, V : Hashable {
        self.content = content()
        self.label = nil
        self.value = value
        self.role = nil
    }

    nonisolated public init(value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.content = content()
        if role == .search {
            self.label = DefaultTabLabel("Search", systemImage: "magnifyingglass")
        } else {
            self.label = nil
        }
        self.value = value
        self.role = role
    }

    nonisolated public init<V>(value: V, role: TabRole?, @ViewBuilder content: () -> Content) where Value == V?, Label == DefaultTabLabel, V : Hashable {
        self.content = content()
        if role == .search {
            self.label = DefaultTabLabel("Search", systemImage: "magnifyingglass")
        } else {
            self.label = nil
        }
        self.value = value
        self.role = role
    }

    nonisolated public init(value: Value, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.init(value: value, role: nil, content: content, label: label)
    }

    nonisolated public init(value: Value, role: TabRole?, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.content = content()
        self.label = label()
        self.value = value
        self.role = role
    }

    nonisolated public init<V>(value: V, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) where Value == V?, V : Hashable {
        self.init(value: value, role: nil, content: content, label: label)
    }

    nonisolated public init<V>(value: V, role: TabRole?, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) where Value == V?, V : Hashable {
        self.content = content()
        self.label = label()
        self.value = value
        self.role = role
    }
}

extension Tab where Value == Never, Content : View, Label : View {
    @_disfavoredOverload public init<S>(_ title: S, image: String, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol {
        self.init(title, image: image, role: nil, content: content)
    }

    @_disfavoredOverload public init<S>(_ title: S, image: String, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol {
        self.content = content()
        self.label = DefaultTabLabel(title, image: image)
        self.value = nil
        self.role = role
    }

    public init(_ titleKey: LocalizedStringKey, image: String, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleKey, image: image, role: nil, content: content)
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, image: String, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleResource, image: image, role: nil, content: content)
    }

    public init(_ titleKey: LocalizedStringKey, image: String, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.content = content()
        self.label = DefaultTabLabel(titleKey, image: image)
        self.value = nil
        self.role = role
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, image: String, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.content = content()
        self.label = DefaultTabLabel(titleResource, image: image)
        self.value = nil
        self.role = role
    }

    @_disfavoredOverload public init<S>(_ title: S, systemImage: String, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol {
        self.init(title, systemImage: systemImage, role: nil, content: content)
    }

    @_disfavoredOverload public init<S>(_ title: S, systemImage: String, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol {
        self.content = content()
        self.label = DefaultTabLabel(title, systemImage: systemImage)
        self.value = nil
        self.role = role
    }

    public init(_ titleKey: LocalizedStringKey, systemImage: String, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleKey, systemImage: systemImage, role: nil, content: content)
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, systemImage: String, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleResource, systemImage: systemImage, role: nil, content: content)
    }

    public init(_ titleKey: LocalizedStringKey, systemImage: String, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.content = content()
        self.label = DefaultTabLabel(titleKey, systemImage: systemImage)
        self.value = nil
        self.role = role
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, systemImage: String, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.content = content()
        self.label = DefaultTabLabel(titleResource, systemImage: systemImage)
        self.value = nil
        self.role = role
    }
}

extension Tab where Value == Never, Content : View, Label : View {
    public init(@ViewBuilder content: () -> Content) where Label == EmptyView {
        self.content = content()
        self.label = nil
        self.value = nil
        self.role = nil
    }

    public init(role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.content = content()
        if role == .search {
            self.label = DefaultTabLabel("Search", systemImage: "magnifyingglass")
        } else {
            self.label = nil
        }
        self.value = nil
        self.role = role
    }

    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.init(role: nil, content: content, label: label)
    }

    public init(role: TabRole?, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.content = content()
        self.label = label()
        self.value = nil
        self.role = role
    }
}

extension Tab : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let javaContent = (content as? any View)?.Java_viewOrEmpty ?? SkipUI.EmptyView()
        let javaLabel = (label as? any View)?.Java_viewOrEmpty
        let javaValue: SwiftHashable?
        if let hashable = value as? AnyHashable {
            javaValue = Java_swiftHashable(for: hashable)
        } else {
            javaValue = nil
        }
        var javaView: any SkipUI.View = SkipUI.Tab(value: javaValue, bridgedRole: role?.identifier, bridgedContent: javaContent, bridgedLabel: javaLabel)
        for modifier in modifiers {
            javaView = modifier(javaView)
        }
        return javaView
    }
}

public struct TabSection<Header, Content, Footer, SelectionValue> {
    private let content: Content

    public var modifiers: [(any SkipUI.View) -> any SkipUI.View] = []
}

extension TabSection : TabContent where Header : View, Content : TabContent, Footer : View, SelectionValue == Content.TabValue {
    public typealias TabValue = Content.TabValue

//    public typealias Body = TabSection<Header, Content, Footer, SelectionValue>
}

extension TabSection where Content : TabContent, SelectionValue : Hashable {
    public init(@TabContentBuilder<SelectionValue> content: () -> Content, @ViewBuilder header: () -> Header) where Header : View, Footer == EmptyView {
        self.content = content()
    }

    public init(@TabContentBuilder<SelectionValue> content: () -> Content) where Header == EmptyView, Footer == EmptyView {
        self.content = content()
    }

    @_disfavoredOverload public init<S>(_ title: S, @TabContentBuilder<SelectionValue> content: () -> Content) where Header == Text, Footer == EmptyView, S : StringProtocol {
        self.content = content()
    }

    public init(_ titleKey: LocalizedStringKey, @TabContentBuilder<SelectionValue> content: () -> Content) where Header == Text, Footer == EmptyView {
        self.content = content()
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, @TabContentBuilder<SelectionValue> content: () -> Content) where Header == Text, Footer == EmptyView {
        self.content = content()
    }

    public init<V>(@TabContentBuilder<V?> content: () -> Content, @ViewBuilder header: () -> Header) where Header : View, Footer == EmptyView, SelectionValue == V?, V : Hashable {
        self.content = content()
    }

    public init<V>(@TabContentBuilder<V?> content: () -> Content) where Header == EmptyView, Footer == EmptyView, SelectionValue == V?, V : Hashable {
        self.content = content()
    }

    @_disfavoredOverload public init<V, S>(_ title: S, @TabContentBuilder<V?> content: () -> Content) where Header == Text, Footer == EmptyView, SelectionValue == V?, V : Hashable, S : StringProtocol {
        self.content = content()
    }

    public init<V>(_ titleKey: LocalizedStringKey, @TabContentBuilder<V?> content: () -> Content) where Header == Text, Footer == EmptyView, SelectionValue == V?, V : Hashable {
        self.content = content()
    }

    @_disfavoredOverload public init<V>(_ titleResource: AndroidLocalizedStringResource, @TabContentBuilder<V?> content: () -> Content) where Header == Text, Footer == EmptyView, SelectionValue == V?, V : Hashable {
        self.content = content()
    }
}

extension TabSection : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let javaContent = (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
        var javaView: any SkipUI.View = SkipUI.TabSection(bridgedContent: javaContent)
        for modifier in modifiers {
            javaView = modifier(javaView)
        }
        return javaView
    }
}

public struct AdaptableTabBarPlacement : Hashable, Sendable {
    public static let automatic = AdaptableTabBarPlacement()
    public static let tabBar = AdaptableTabBarPlacement()
    public static let sidebar = AdaptableTabBarPlacement()
}

public struct TabCustomizationBehavior : Equatable, Sendable {
    public static let automatic = TabCustomizationBehavior()
    public static let reorderable = TabCustomizationBehavior()
    public static let disabled = TabCustomizationBehavior()
}

public struct TabPlacement : Hashable, Sendable {
    public static let automatic = TabPlacement()
    public static let pinned = TabPlacement()
    public static let sidebarOnly = TabPlacement()
}

public struct TabRole : Hashable, Sendable {
    public static var search: TabRole {
        return TabRole(identifier: 1)
    }

    let identifier: Int // For bridging
}

@MainActor @preconcurrency public protocol TabContent<TabValue> {
    associatedtype TabValue : Hashable //where Self.TabValue == Self.Body.TabValue

//    associatedtype Body : TabContent
//
//    @TabContentBuilder<Self.TabValue> @MainActor @preconcurrency var body: Self.Body { get }

    nonisolated var modifiers: [(any SkipUI.View) -> any SkipUI.View] { get set }
}

public struct EmptyTabContent {
    public var modifiers: [(any SkipUI.View) -> any SkipUI.View] {
        get {
            return []
        }
        set {
        }
    }
}

extension EmptyTabContent : TabContent {
    public typealias TabValue = Never
}

public struct AnyTabContent<T> {
    var content: any TabContent<T>

    public init(_ content: any TabContent<T>) {
        self.content = content
    }

    public var modifiers: [(any SkipUI.View) -> any SkipUI.View] {
        get {
            return content.modifiers
        }
        set {
            content.modifiers = newValue
        }
    }
}

extension AnyTabContent : TabContent where T : Hashable {
    public typealias TabValue = T
}

extension AnyTabContent : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
    }
}

extension TabContent {
    @available(*, unavailable)
    nonisolated public func accessibilityValue(_ valueDescription: Text, isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    nonisolated public func accessibilityValue(_ valueKey: LocalizedStringKey, isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityValue(_ valueResource: AndroidLocalizedStringResource, isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityValue<S>(_ value: S, isEnabled: Bool = true) -> some TabContent<Self.TabValue> where S : StringProtocol {
        return self
    }
}

extension TabContent {
    @available(*, unavailable)
    nonisolated public func accessibilityLabel(_ label: Text, isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    nonisolated public func accessibilityLabel(_ labelKey: LocalizedStringKey, isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityLabel(_ labelResource: AndroidLocalizedStringResource, isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityLabel<S>(_ label: S, isEnabled: Bool = true) -> some TabContent<Self.TabValue> where S : StringProtocol {
        return self
    }
}

extension TabContent {
    @available(*, unavailable)
    nonisolated public func accessibilityHint(_ hint: Text, isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    nonisolated public func accessibilityHint(_ hintKey: LocalizedStringKey, isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityHint(_ hintResource: AndroidLocalizedStringResource, isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityHint<S>(_ hint: S, isEnabled: Bool = true) -> some TabContent<Self.TabValue> where S : StringProtocol {
        return self
    }
}

extension TabContent {
    @available(*, unavailable)
    nonisolated public func customizationBehavior(_ behavior: TabCustomizationBehavior, for placements: AdaptableTabBarPlacement...) -> some TabContent<Self.TabValue> {
        return self
    }

    nonisolated public func customizationID(_ id: String) -> some TabContent<Self.TabValue> {
        return self
    }
}

extension TabContent {
    @available(*, unavailable)
    nonisolated public func sectionActions<Content>(@ViewBuilder content: () -> Content) -> some TabContent<Self.TabValue> where Content : View {
        return self
    }
}

extension TabContent {
    @available(*, unavailable)
    @MainActor @preconcurrency public func dropDestination<T>(for payloadType: T.Type = T.self, action: @escaping ([T]) -> Void) -> some TabContent<Self.TabValue> /* where T : Transferable */ {
        return self
    }

    @available(*, unavailable)
    nonisolated public func springLoadingBehavior(_ behavior: SpringLoadingBehavior) -> some TabContent<Self.TabValue> {
        return self
    }
}

extension TabContent {
    @available(*, unavailable)
    @MainActor @preconcurrency public func draggable<T>(_ payload: @autoclosure @escaping () -> T) -> some TabContent<Self.TabValue> /* where T : Transferable */ {
        return self
    }
}

extension TabContent {
    @available(*, unavailable)
    nonisolated public func badge(_ count: Int) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    nonisolated public func badge(_ label: Text?) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    nonisolated public func badge(_ key: LocalizedStringKey) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func badge(_ resource: AndroidLocalizedStringResource) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func badge<S>(_ label: S) -> some TabContent<Self.TabValue> where S : StringProtocol {
        return self
    }
}

extension TabContent {
    @available(*, unavailable)
    nonisolated public func popover<Content>(isPresented: Binding<Bool>, attachmentAnchor: Any /* PopoverAttachmentAnchor = .rect(.bounds) */, arrowEdge: Edge? = nil, @ViewBuilder content: @escaping () -> Content) -> some TabContent<Self.TabValue> where Content : View {
        return self
    }

    @available(*, unavailable)
    nonisolated public func popover<Item, Content>(item: Binding<Item?>, attachmentAnchor: Any /* PopoverAttachmentAnchor = .rect(.bounds) */, arrowEdge: Edge? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some TabContent<Self.TabValue> where Item : Identifiable, Content : View {
        return self
    }
}

extension TabContent {
    @available(*, unavailable)
    nonisolated public func accessibilityInputLabels(_ inputLabels: [Text], isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    nonisolated public func accessibilityInputLabels(_ inputLabelKeys: [LocalizedStringKey], isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityInputLabels(_ inputLabelResources: [AndroidLocalizedStringResource], isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        return self
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityInputLabels<S>(_ inputLabels: [S], isEnabled: Bool = true) -> some TabContent<Self.TabValue> where S : StringProtocol {
        return self
    }
}

extension TabContent {
    @available(*, unavailable)
    nonisolated public func swipeActions<T>(edge: HorizontalEdge = .trailing, allowsFullSwipe: Bool = true, @ViewBuilder content: () -> T) -> some TabContent<Self.TabValue> where T : View {
        return self
    }
}

extension TabContent {
    @available(*, unavailable)
    nonisolated public func contextMenu<M>(@ViewBuilder menuItems: () -> M) -> some TabContent<Self.TabValue> where M : View {
        return self
    }
}

extension TabContent {
    nonisolated public func accessibilityIdentifier(_ identifier: String, isEnabled: Bool = true) -> some TabContent<Self.TabValue> {
        var tabContent = self
        tabContent.modifiers.append({ $0.accessibilityIdentifier(identifier, isEnabled: isEnabled) })
        return tabContent
    }
}

extension TabContent {
    @available(*, unavailable)
    nonisolated public func defaultVisibility(_ visibility: Visibility, for placements: AdaptableTabBarPlacement...) -> some TabContent<Self.TabValue> {
        return self
    }
}

extension TabContent {
    nonisolated public func hidden(_ hidden: Bool = true) -> some TabContent<Self.TabValue> {
        var tabContent = self
        tabContent.modifiers.append({ ($0 as? any SkipUI.TabContent)?.hidden(hidden) ?? $0 })
        return tabContent
    }
}

extension TabContent {
    nonisolated public func disabled(_ disabled: Bool) -> some TabContent<Self.TabValue> {
        var tabContent = self
        tabContent.modifiers.append({ ($0 as? any SkipUI.TabContent)?.disabled(disabled) ?? $0 })
        return tabContent
    }
}

extension TabContent {
    @available(*, unavailable)
    nonisolated public func tabPlacement(_ placement: TabPlacement) -> some TabContent<Self.TabValue> {
        return self
    }
}

public struct TupleTabContent<T> {
    private let contents: [any TabContent<T>]

    public init(_ contents: [any TabContent<T>]) {
        self.contents = contents
    }

    public var modifiers: [(any SkipUI.View) -> any SkipUI.View] = []
}

extension TupleTabContent : TabContent where T : Hashable {
    public typealias TabValue = T
}

extension TupleTabContent : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let javaContents = contents.compactMap { ($0 as? SkipUIBridging)?.Java_view }
        var javaView: any SkipUI.View = SkipUI.ComposeBuilder(bridgedViews: javaContents)
        for modifier in modifiers {
            javaView = modifier(javaView)
        }
        return javaView
    }
}

@resultBuilder public struct TabContentBuilder<TabValue> where TabValue : Hashable {
//    public struct Content<C> : View where C : TabContent {
//        @MainActor @preconcurrency public var body: some View { get }
//        public typealias Body = some View
//    }

    public static func buildExpression(_ content: some TabContent<TabValue>) -> some TabContent<TabValue> {
        return content
    }

    public static func buildBlock(_ content: some TabContent<TabValue>) -> some TabContent<TabValue> {
        return content
    }

    public static func buildIf(_ content: (some TabContent<TabValue>)?) -> (some TabContent<TabValue>)? {
        return content
    }

    public static func buildEither<T>(first: T) -> AnyTabContent<T.TabValue> where TabValue == T.TabValue, T : TabContent {
        return AnyTabContent(first)
    }

    public static func buildEither<F>(second: F) -> AnyTabContent<F.TabValue> where TabValue == F.TabValue, F : TabContent {
        return AnyTabContent(second)
    }

    public static func buildLimitedAvailability<T>(_ content: T) -> AnyTabContent<T.TabValue> where T : TabContent {
        return AnyTabContent(content)
    }
}

extension TabContentBuilder {
    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> some TabContent<TabValue> where TabValue == C0.TabValue, C0 : TabContent, C1 : TabContent, C0.TabValue == C1.TabValue {
        return TupleTabContent([c0, c1])
    }

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> some TabContent<TabValue> where TabValue == C0.TabValue, C0 : TabContent, C1 : TabContent, C2 : TabContent, C0.TabValue == C1.TabValue, C1.TabValue == C2.TabValue {
        return TupleTabContent([c0, c1, c2])
    }


    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> some TabContent<TabValue> where TabValue == C0.TabValue, C0 : TabContent, C1 : TabContent, C2 : TabContent, C3 : TabContent, C0.TabValue == C1.TabValue, C1.TabValue == C2.TabValue, C2.TabValue == C3.TabValue {
        return TupleTabContent([c0, c1, c2, c3])
    }


    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> some TabContent<TabValue> where TabValue == C0.TabValue, C0 : TabContent, C1 : TabContent, C2 : TabContent, C3 : TabContent, C4 : TabContent, C0.TabValue == C1.TabValue, C1.TabValue == C2.TabValue, C2.TabValue == C3.TabValue, C3.TabValue == C4.TabValue {
        return TupleTabContent([c0, c1, c2, c3, c4])
    }


    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> some TabContent<TabValue> where TabValue == C0.TabValue, C0 : TabContent, C1 : TabContent, C2 : TabContent, C3 : TabContent, C4 : TabContent, C5 : TabContent, C0.TabValue == C1.TabValue, C1.TabValue == C2.TabValue, C2.TabValue == C3.TabValue, C3.TabValue == C4.TabValue, C4.TabValue == C5.TabValue {
        return TupleTabContent([c0, c1, c2, c3, c4, c5])
    }


    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> some TabContent<TabValue> where TabValue == C0.TabValue, C0 : TabContent, C1 : TabContent, C2 : TabContent, C3 : TabContent, C4 : TabContent, C5 : TabContent, C6 : TabContent, C0.TabValue == C1.TabValue, C1.TabValue == C2.TabValue, C2.TabValue == C3.TabValue, C3.TabValue == C4.TabValue, C4.TabValue == C5.TabValue, C5.TabValue == C6.TabValue {
        return TupleTabContent([c0, c1, c2, c3, c4, c5, c6])
    }


    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> some TabContent<TabValue> where TabValue == C0.TabValue, C0 : TabContent, C1 : TabContent, C2 : TabContent, C3 : TabContent, C4 : TabContent, C5 : TabContent, C6 : TabContent, C7 : TabContent, C0.TabValue == C1.TabValue, C1.TabValue == C2.TabValue, C2.TabValue == C3.TabValue, C3.TabValue == C4.TabValue, C4.TabValue == C5.TabValue, C5.TabValue == C6.TabValue, C6.TabValue == C7.TabValue {
        return TupleTabContent([c0, c1, c2, c3, c4, c5, c6, c7])
    }


    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> some TabContent<TabValue> where TabValue == C0.TabValue, C0 : TabContent, C1 : TabContent, C2 : TabContent, C3 : TabContent, C4 : TabContent, C5 : TabContent, C6 : TabContent, C7 : TabContent, C8 : TabContent, C0.TabValue == C1.TabValue, C1.TabValue == C2.TabValue, C2.TabValue == C3.TabValue, C3.TabValue == C4.TabValue, C4.TabValue == C5.TabValue, C5.TabValue == C6.TabValue, C6.TabValue == C7.TabValue, C7.TabValue == C8.TabValue {
        return TupleTabContent([c0, c1, c2, c3, c4, c5, c6, c7, c8])
    }


    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> some TabContent<TabValue> where TabValue == C0.TabValue, C0 : TabContent, C1 : TabContent, C2 : TabContent, C3 : TabContent, C4 : TabContent, C5 : TabContent, C6 : TabContent, C7 : TabContent, C8 : TabContent, C9 : TabContent, C0.TabValue == C1.TabValue, C1.TabValue == C2.TabValue, C2.TabValue == C3.TabValue, C3.TabValue == C4.TabValue, C4.TabValue == C5.TabValue, C5.TabValue == C6.TabValue, C6.TabValue == C7.TabValue, C7.TabValue == C8.TabValue, C8.TabValue == C9.TabValue {
        return TupleTabContent([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9])
    }
}

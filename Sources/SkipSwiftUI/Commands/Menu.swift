// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

@MainActor @preconcurrency public struct Menu<Label, Content> : View where Label : View, Content : View {
    private let content: UncheckedSendableBox<Content>
    private let label: UncheckedSendableBox<Label>
    private let primaryAction: UncheckedSendableBox<() -> Void>?

    public typealias Body = Never
}

extension Menu : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Menu(bridgedContent: content.wrappedValue.Java_viewOrEmpty, bridgedLabel: label.wrappedValue.Java_viewOrEmpty, primaryAction: primaryAction?.wrappedValue)
    }
}

extension Menu {
    nonisolated public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.content = UncheckedSendableBox(content())
        self.label = UncheckedSendableBox(label())
        self.primaryAction = nil
    }

    nonisolated public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) where Label == Text {
        self.content = UncheckedSendableBox(content())
        self.label = UncheckedSendableBox(Text(titleKey))
        self.primaryAction = nil
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, @ViewBuilder content: () -> Content) where Label == Text, S : StringProtocol {
        self.content = UncheckedSendableBox(content())
        self.label = UncheckedSendableBox(Text(title))
        self.primaryAction = nil
    }
}

extension Menu {
    nonisolated public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label, primaryAction: @escaping () -> Void) {
        self.content = UncheckedSendableBox(content())
        self.label = UncheckedSendableBox(label())
        self.primaryAction = UncheckedSendableBox(primaryAction)
    }

    nonisolated public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content, primaryAction: @escaping () -> Void) where Label == Text {
        self.content = UncheckedSendableBox(content())
        self.label = UncheckedSendableBox(Text(titleKey))
        self.primaryAction = UncheckedSendableBox(primaryAction)
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, @ViewBuilder content: () -> Content, primaryAction: @escaping () -> Void) where Label == Text, S : StringProtocol {
        self.content = UncheckedSendableBox(content())
        self.label = UncheckedSendableBox(Text(title))
        self.primaryAction = UncheckedSendableBox(primaryAction)
    }
}

extension Menu where Label == SkipSwiftUI.Label<Text, Image> {
    nonisolated public init(_ titleKey: LocalizedStringKey, systemImage: String, @ViewBuilder content: () -> Content) {
        self.content = UncheckedSendableBox(content())
        self.label = UncheckedSendableBox(Label(titleKey, systemImage: systemImage))
        self.primaryAction = nil
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, systemImage: String, @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.content = UncheckedSendableBox(content())
        self.label = UncheckedSendableBox(Label(title, systemImage: systemImage))
        self.primaryAction = nil
    }

    nonisolated public init(_ titleKey: LocalizedStringKey, systemImage: String, @ViewBuilder content: () -> Content, primaryAction: @escaping () -> Void) {
        self.content = UncheckedSendableBox(content())
        self.label = UncheckedSendableBox(Label(titleKey, systemImage: systemImage))
        self.primaryAction = UncheckedSendableBox(primaryAction)
    }
}

//extension Menu where Label == SkipSwiftUI.Label<Text, Image> {
//    nonisolated public init(_ titleKey: LocalizedStringKey, image: ImageResource, @ViewBuilder content: () -> Content)
//
//    nonisolated public init<S>(_ title: S, image: ImageResource, @ViewBuilder content: () -> Content) where S : StringProtocol
//
//    nonisolated public init(_ titleKey: LocalizedStringKey, image: ImageResource, @ViewBuilder content: () -> Content, primaryAction: @escaping () -> Void)
//}

extension Menu where Label == MenuStyleConfiguration.Label, Content == MenuStyleConfiguration.Content {
    @available(*, unavailable)
    nonisolated public init(_ configuration: MenuStyleConfiguration) {
        fatalError()
    }
}

public struct MenuActionDismissBehavior : Equatable, Sendable {
    public static let automatic = MenuActionDismissBehavior(identifier: 0) // For bridging

    public static let enabled = MenuActionDismissBehavior(identifier: 0) // For bridging

    @available(*, unavailable)
    public static let disabled = MenuActionDismissBehavior(identifier: 1) // For bridging

    let identifier: Int // For bridging
}

public struct MenuOrder : Equatable, Hashable, Sendable {
    public static let automatic = MenuOrder(identifier: 0) // For bridging

    @available(*, unavailable)
    public static let priority = MenuOrder(identifier: 1) // For bridging

    public static let fixed = MenuOrder(identifier: 2) // For bridging

    public let identifier: Int
}

@MainActor @preconcurrency public protocol MenuStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = MenuStyleConfiguration

    nonisolated var identifier: Int { get } // For bridging
}

extension MenuStyle {
    nonisolated public var identifier: Int {
        return -1
    }
}

@MainActor @preconcurrency public struct ButtonMenuStyle : MenuStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: ButtonMenuStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 1 // For bridging
}

extension MenuStyle where Self == ButtonMenuStyle {
    @MainActor @preconcurrency public static var button: ButtonMenuStyle {
        return ButtonMenuStyle()
    }
}

@MainActor @preconcurrency public struct DefaultMenuStyle : MenuStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: ButtonMenuStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 0 // For bridging
}

extension MenuStyle where Self == DefaultMenuStyle {
    @MainActor @preconcurrency public static var automatic: DefaultMenuStyle {
        return DefaultMenuStyle()
    }
}

@MainActor @preconcurrency public struct BorderlessButtonMenuStyle : MenuStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public init() {
        fatalError()
    }

    @MainActor @preconcurrency public func makeBody(configuration: ButtonMenuStyle.Configuration) -> some View {
        stubView()
    }
}

extension MenuStyle where Self == BorderlessButtonMenuStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var borderlessButton: BorderlessButtonMenuStyle {
        fatalError()
    }
}

public struct MenuStyleConfiguration {
    @MainActor @preconcurrency public struct Label : View {
        public typealias Body = Never
    }

    @MainActor @preconcurrency public struct Content : View {
        public typealias Body = Never
    }
}

extension View {
    nonisolated public func menuStyle<S>(_ style: S) -> some View where S : MenuStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.menuStyle(bridgedStyle: style.identifier)
        }
    }
}

extension View {
    nonisolated public func menuOrder(_ order: MenuOrder) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.menuOrder(bridgedOrder: order.identifier)
        }
    }
}

extension View {
    nonisolated public func menuActionDismissBehavior(_ behavior: MenuActionDismissBehavior) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.menuActionDismissBehavior(bridgedBehavior: behavior.identifier)
        }
    }
}

extension View {
    @available(*, unavailable)
    @inlinable nonisolated public func menuIndicator(_ visibility: Visibility) -> some View {
        stubView()
    }
}

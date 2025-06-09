// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

@MainActor @preconcurrency public struct Button<Label> : View where Label : View {
    private let label: UncheckedSendableBox<Label>
    private let action: @MainActor () -> Void
    private let role: ButtonRole?

    @preconcurrency nonisolated public init(action: @escaping @MainActor () -> Void, @ViewBuilder label: () -> Label) {
        self.init(role: nil, action: action, label: label)
    }

    public typealias Body = Never
}

extension Button : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let action = self.action
        #if compiler(>=6.0)
        let isolatedAction = { MainActor.assumeIsolated { action() } }
        #else
        let isolatedAction = action
        #endif
        return SkipUI.Button(bridgedRole: role?.identifier, action: isolatedAction, bridgedLabel: label.wrappedValue.Java_viewOrEmpty)
    }
}

extension Button where Label == Text {
    @preconcurrency nonisolated public init(_ titleKey: LocalizedStringKey, action: @escaping @MainActor () -> Void) {
        self.init(action: action, label: { Text(titleKey) })
    }

    @_disfavoredOverload @preconcurrency nonisolated public init<S>(_ title: S, action: @escaping @MainActor () -> Void) where S : StringProtocol {
        self.init(action: action, label: { Text(title) })
    }
}

extension Button where Label == SkipSwiftUI.Label<Text, Image> {
    nonisolated public init(_ titleKey: LocalizedStringKey, systemImage: String, action: @escaping @MainActor () -> Void) {
        self.init(action: action, label: { SkipSwiftUI.Label(titleKey, systemImage: systemImage) })
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, systemImage: String, action: @escaping @MainActor () -> Void) where S : StringProtocol {
        self.init(action: action, label: { SkipSwiftUI.Label(title, systemImage: systemImage) })
    }
}

//extension Button where Label == Label<Text, Image> {
//    @preconcurrency nonisolated public init(_ titleKey: LocalizedStringKey, image: ImageResource, action: @escaping @MainActor () -> Void)
//
//    @preconcurrency nonisolated public init<S>(_ title: S, image: ImageResource, action: @escaping @MainActor () -> Void) where S : StringProtocol
//}

extension Button where Label == PrimitiveButtonStyleConfiguration.Label {
    @available(*, unavailable)
    nonisolated public init(_ configuration: PrimitiveButtonStyleConfiguration) {
        fatalError()
    }
}

extension Button {
    @preconcurrency nonisolated public init(role: ButtonRole?, action: @escaping @MainActor () -> Void, @ViewBuilder label: () -> Label) {
        self.role = role
        self.action = action
        self.label = UncheckedSendableBox(label())
    }
}

extension Button where Label == Text {
    @preconcurrency nonisolated public init(_ titleKey: LocalizedStringKey, role: ButtonRole?, action: @escaping @MainActor () -> Void) {
        self.init(role: role, action: action, label: { Text(titleKey) })
    }

    @_disfavoredOverload @preconcurrency nonisolated public init<S>(_ title: S, role: ButtonRole?, action: @escaping @MainActor () -> Void) where S : StringProtocol {
        self.init(role: role, action: action, label: { Text(title) })
    }
}

extension Button where Label == SkipSwiftUI.Label<Text, Image> {
    nonisolated public init(_ titleKey: LocalizedStringKey, systemImage: String, role: ButtonRole?, action: @escaping @MainActor () -> Void) {
        self.init(role: role, action: action, label: { SkipSwiftUI.Label(titleKey, systemImage: systemImage) })
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, systemImage: String, role: ButtonRole?, action: @escaping @MainActor () -> Void) where S : StringProtocol {
        self.init(role: role, action: action, label: { SkipSwiftUI.Label(title, systemImage: systemImage) })
    }
}

//extension Button where Label == Label<Text, Image> {
//    @preconcurrency nonisolated public init(_ titleKey: LocalizedStringKey, image: ImageResource, role: ButtonRole?, action: @escaping @MainActor () -> Void)
//
//    @preconcurrency nonisolated public init<S>(_ title: S, image: ImageResource, role: ButtonRole?, action: @escaping @MainActor () -> Void) where S : StringProtocol
//}

public struct ButtonRepeatBehavior : Hashable, Sendable {
    public static let automatic = ButtonRepeatBehavior()

    public static let enabled = ButtonRepeatBehavior()

    public static let disabled = ButtonRepeatBehavior()
}

public struct ButtonRole : Equatable, Sendable {
    public static let destructive = ButtonRole(identifier: 1) // For bridging

    public static let cancel = ButtonRole(identifier: 2) // For bridging

    let identifier: Int // For bridging
}

@MainActor @preconcurrency public protocol ButtonStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = ButtonStyleConfiguration
}

public struct ButtonStyleConfiguration {
    @MainActor @preconcurrency public struct Label : View {
        public typealias Body = Never
    }

    public let role: ButtonRole?
    public let label: ButtonStyleConfiguration.Label
    public let isPressed: Bool
}

@MainActor @preconcurrency public struct BorderedButtonStyle : PrimitiveButtonStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: BorderedButtonStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 3 // For bridging
}

@MainActor @preconcurrency public struct BorderedProminentButtonStyle : PrimitiveButtonStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: BorderedProminentButtonStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 4 // For bridging
}

@MainActor @preconcurrency public struct BorderlessButtonStyle : PrimitiveButtonStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: BorderlessButtonStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 2 // For bridging
}

@MainActor @preconcurrency public struct DefaultButtonStyle : PrimitiveButtonStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: DefaultButtonStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 0 // For bridging
}

@MainActor @preconcurrency public struct PlainButtonStyle : PrimitiveButtonStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: PlainButtonStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 1 // For bridging
}

@MainActor @preconcurrency public protocol PrimitiveButtonStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = PrimitiveButtonStyleConfiguration

    nonisolated var identifier: Int { get } // For bridging
}

extension PrimitiveButtonStyle {
    nonisolated public var identifier: Int {
        return -1
    }
}

extension PrimitiveButtonStyle where Self == DefaultButtonStyle {
    @MainActor @preconcurrency public static var automatic: DefaultButtonStyle {
        return DefaultButtonStyle()
    }
}

extension PrimitiveButtonStyle where Self == BorderlessButtonStyle {
    @MainActor @preconcurrency public static var borderless: BorderlessButtonStyle {
        return BorderlessButtonStyle()
    }
}

extension PrimitiveButtonStyle where Self == PlainButtonStyle {
    @MainActor @preconcurrency public static var plain: PlainButtonStyle {
        return PlainButtonStyle()
    }
}

extension PrimitiveButtonStyle where Self == BorderedButtonStyle {
    @MainActor @preconcurrency public static var bordered: BorderedButtonStyle {
        return BorderedButtonStyle()
    }
}

extension PrimitiveButtonStyle where Self == BorderedProminentButtonStyle {
    @MainActor @preconcurrency public static var borderedProminent: BorderedProminentButtonStyle {
        return BorderedProminentButtonStyle()
    }
}

public struct PrimitiveButtonStyleConfiguration {
    @MainActor @preconcurrency public struct Label : View {
        public typealias Body = Never
    }

    public let role: ButtonRole?
    public let label: PrimitiveButtonStyleConfiguration.Label

    @available(*, unavailable)
    public init(role: ButtonRole?, label: Label) {
        fatalError()
    }

    @available(*, unavailable)
    public func trigger() {
        fatalError()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func buttonRepeatBehavior(_ behavior: ButtonRepeatBehavior) -> some View {
        stubView()
    }

    nonisolated public func buttonStyle<S>(_ style: S) -> some View where S : PrimitiveButtonStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.buttonStyle(bridgedStyle: style.identifier)
        }
    }
}

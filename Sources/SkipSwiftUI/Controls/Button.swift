// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipFuse
import SkipUI

public struct Button<Label> where Label : View {
    private let label: Label?
    private let action: @MainActor () -> Void
    private let role: ButtonRole?

    @preconcurrency public init(action: @escaping @MainActor () -> Void, @ViewBuilder label: () -> Label) {
        self.init(role: nil, action: action, label: label)
    }
}

extension Button : View {
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
        return SkipUI.Button(bridgedRole: role?.identifier, action: isolatedAction, bridgedLabel: label?.Java_viewOrEmpty)
    }
}

extension Button where Label == Text {
    @preconcurrency public init(_ titleKey: LocalizedStringKey, action: @escaping @MainActor () -> Void) {
        self.init(action: action, label: { Text(titleKey) })
    }

    @_disfavoredOverload @preconcurrency public init(_ titleResource: AndroidLocalizedStringResource, action: @escaping @MainActor () -> Void) {
        self.init(action: action, label: { Text(titleResource) })
    }

    @_disfavoredOverload @preconcurrency public init<S>(_ title: S, action: @escaping @MainActor () -> Void) where S : StringProtocol {
        self.init(action: action, label: { Text(title) })
    }

    @preconcurrency public init(role: ButtonRole, action: @escaping @MainActor () -> Void) {
        self.role = role
        self.action = action
        self.label = nil
    }
}

extension Button where Label == SkipSwiftUI.Label<Text, Image> {
    @preconcurrency public init(_ titleKey: LocalizedStringKey, systemImage: String, action: @escaping @MainActor () -> Void) {
        self.init(action: action, label: { SkipSwiftUI.Label(titleKey, systemImage: systemImage) })
    }

    @_disfavoredOverload @preconcurrency public init(_ titleResource: AndroidLocalizedStringResource, systemImage: String, action: @escaping @MainActor () -> Void) {
        self.init(action: action, label: { SkipSwiftUI.Label(titleResource, systemImage: systemImage) })
    }

    @_disfavoredOverload @preconcurrency public init<S>(_ title: S, systemImage: String, action: @escaping @MainActor () -> Void) where S : StringProtocol {
        self.init(action: action, label: { SkipSwiftUI.Label(title, systemImage: systemImage) })
    }
}

//extension Button where Label == Label<Text, Image> {
//    public init(_ titleKey: LocalizedStringKey, image: ImageResource, action: @escaping @MainActor () -> Void)
//
//    public init<S>(_ title: S, image: ImageResource, action: @escaping @MainActor () -> Void) where S : StringProtocol
//}

extension Button where Label == PrimitiveButtonStyleConfiguration.Label {
    @available(*, unavailable)
    public init(_ configuration: PrimitiveButtonStyleConfiguration) {
        fatalError()
    }
}

extension Button {
    @preconcurrency public init(role: ButtonRole?, action: @escaping @MainActor () -> Void, @ViewBuilder label: () -> Label) {
        self.role = role
        self.action = action
        self.label = label()
    }
}

extension Button where Label == Text {
    @preconcurrency public init(_ titleKey: LocalizedStringKey, role: ButtonRole?, action: @escaping @MainActor () -> Void) {
        self.init(role: role, action: action, label: { Text(titleKey) })
    }

    @_disfavoredOverload @preconcurrency public init(_ titleResource: AndroidLocalizedStringResource, role: ButtonRole?, action: @escaping @MainActor () -> Void) {
        self.init(role: role, action: action, label: { Text(titleResource) })
    }

    @_disfavoredOverload @preconcurrency public init<S>(_ title: S, role: ButtonRole?, action: @escaping @MainActor () -> Void) where S : StringProtocol {
        self.init(role: role, action: action, label: { Text(title) })
    }
}

extension Button where Label == SkipSwiftUI.Label<Text, Image> {
    @preconcurrency public init(_ titleKey: LocalizedStringKey, systemImage: String, role: ButtonRole?, action: @escaping @MainActor () -> Void) {
        self.init(role: role, action: action, label: { SkipSwiftUI.Label(titleKey, systemImage: systemImage) })
    }

    @_disfavoredOverload @preconcurrency public init(_ titleResource: AndroidLocalizedStringResource, systemImage: String, role: ButtonRole?, action: @escaping @MainActor () -> Void) {
        self.init(role: role, action: action, label: { SkipSwiftUI.Label(titleResource, systemImage: systemImage) })
    }

    @_disfavoredOverload @preconcurrency public init<S>(_ title: S, systemImage: String, role: ButtonRole?, action: @escaping @MainActor () -> Void) where S : StringProtocol {
        self.init(role: role, action: action, label: { SkipSwiftUI.Label(title, systemImage: systemImage) })
    }
}

//extension Button where Label == Label<Text, Image> {
//    public init(_ titleKey: LocalizedStringKey, image: ImageResource, role: ButtonRole?, action: @escaping @MainActor () -> Void)
//
//    public init<S>(_ title: S, image: ImageResource, role: ButtonRole?, action: @escaping @MainActor () -> Void) where S : StringProtocol
//}

public struct ButtonRepeatBehavior : Hashable, Sendable {
    public static let automatic = ButtonRepeatBehavior()

    public static let enabled = ButtonRepeatBehavior()

    public static let disabled = ButtonRepeatBehavior()
}

public struct ButtonRole : Equatable, Sendable {
    public static let destructive = ButtonRole(identifier: 1) // For bridging
    public static let cancel = ButtonRole(identifier: 2) // For bridging
    public static let confirm = ButtonRole(identifier: 3) // For bridging
    public static let close = ButtonRole(identifier: 4) // For bridging

    let identifier: Int // For bridging
}

public struct ButtonSizing : Hashable, Sendable {
    public static let automatic = ButtonSizing(identifier: 0) // For bridging
    @available(*, unavailable)
    public static let flexible = ButtonSizing(identifier: 1) // For bridging
    @available(*, unavailable)
    public static let fitted = ButtonSizing(identifier: 2) // For bridging

    let identifier: Int // For bridging
}

@MainActor @preconcurrency public protocol ButtonStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = ButtonStyleConfiguration
}

public struct ButtonStyleConfiguration {
    public struct Label : View {
        public typealias Body = Never
    }

    public let role: ButtonRole?
    public let label: ButtonStyleConfiguration.Label
    public let isPressed: Bool
}

public struct BorderedButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: BorderedButtonStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 3 // For bridging
}

public struct BorderedProminentButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: BorderedProminentButtonStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 4 // For bridging
}

public struct BorderlessButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: BorderlessButtonStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 2 // For bridging
}

public struct DefaultButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: DefaultButtonStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 0 // For bridging
}

public struct PlainButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: PlainButtonStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 1 // For bridging
}

public struct GlassButtonStyle : PrimitiveButtonStyle {
    @available(*, unavailable)
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: GlassButtonStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 5 // For bridging
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

extension PrimitiveButtonStyle where Self == GlassButtonStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var glass: GlassButtonStyle {
        fatalError()
    }
}

public struct PrimitiveButtonStyleConfiguration {
    public struct Label : View {
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

    nonisolated public func buttonSizing(_ sizing: ButtonSizing) -> some View {
        // We only support .automatic
        return self
    }

    nonisolated public func buttonStyle<S>(_ style: S) -> some View where S : PrimitiveButtonStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.buttonStyle(bridgedStyle: style.identifier)
        }
    }
}

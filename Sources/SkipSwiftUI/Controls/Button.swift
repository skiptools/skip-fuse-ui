// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
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
        let isolatedAction = { assumeMainActorUnchecked { action() } }
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
    @preconcurrency public init(_ configuration: PrimitiveButtonStyleConfiguration) {
        let configurationBox = UncheckedSendableBox(configuration)
        self.init(role: configuration.role, action: { configurationBox.wrappedValue.trigger() }, label: { configuration.label })
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
    public struct Label {
        public typealias Body = Never

        let Java_label: any SkipUI.View
    }

    public let role: ButtonRole?
    public let label: ButtonStyleConfiguration.Label
    public let isPressed: Bool

    init(Java_configuration: SkipUI.ButtonStyleBridgedConfiguration) {
        self.role = Java_configuration.bridgedRole.map { ButtonRole(identifier: $0) }
        self.label = Label(Java_label: Java_configuration.label)
        self.isPressed = Java_configuration.isPressed
    }
}

extension ButtonStyleConfiguration.Label : View, SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return Java_label
    }
}

public struct BorderedButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: BorderedButtonStyle.Configuration) -> some View {
        Button(configuration).buttonStyle(self)
    }

    public let identifier = 3 // For bridging
}

public struct BorderedProminentButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: BorderedProminentButtonStyle.Configuration) -> some View {
        Button(configuration).buttonStyle(self)
    }

    public let identifier = 4 // For bridging
}

public struct BorderlessButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: BorderlessButtonStyle.Configuration) -> some View {
        Button(configuration).buttonStyle(self)
    }

    public let identifier = 2 // For bridging
}

public struct DefaultButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: DefaultButtonStyle.Configuration) -> some View {
        Button(configuration).buttonStyle(self)
    }

    public let identifier = 0 // For bridging
}

public struct PlainButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: PlainButtonStyle.Configuration) -> some View {
        Button(configuration).buttonStyle(self)
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

public struct M3TextButtonStyle : PrimitiveButtonStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: M3TextButtonStyle.Configuration) -> some View {
        Button(configuration).buttonStyle(self)
    }

    public let identifier = 7 // For bridging
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

extension PrimitiveButtonStyle where Self == M3TextButtonStyle {
    @MainActor @preconcurrency public static var m3Text: M3TextButtonStyle {
        return M3TextButtonStyle()
    }
}

public struct PrimitiveButtonStyleConfiguration {
    public struct Label {
        public typealias Body = Never

        let Java_label: any SkipUI.View
    }

    public let role: ButtonRole?
    public let label: PrimitiveButtonStyleConfiguration.Label
    private let Java_configuration: SkipUI.ButtonStyleBridgedConfiguration

    init(Java_configuration: SkipUI.ButtonStyleBridgedConfiguration) {
        self.role = Java_configuration.bridgedRole.map { ButtonRole(identifier: $0) }
        self.label = Label(Java_label: Java_configuration.label)
        self.Java_configuration = Java_configuration
    }

    public func trigger() {
        Java_configuration.trigger()
    }
}

extension PrimitiveButtonStyleConfiguration.Label : View, SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return Java_label
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
        let identifier = style.identifier
        let resolvedStyle = ResolvedButtonStyle(style) { style, Java_configuration in
            style.makeBody(configuration: PrimitiveButtonStyleConfiguration(Java_configuration: Java_configuration)).Java_viewOrEmpty
        }
        return ModifierView(target: self) {
            guard identifier < 0 else {
                return $0.Java_viewOrEmpty.buttonStyle(bridgedStyle: identifier)
            }
            return $0.Java_viewOrEmpty.buttonStyle(isPrimitive: true, environmentKeys: resolvedStyle.environmentKeys, bridgedMakeBody: resolvedStyle.makeBody(Java_configuration:))
        }
    }

    nonisolated public func buttonStyle<S>(_ style: S) -> some View where S : ButtonStyle {
        let resolvedStyle = ResolvedButtonStyle(style) { style, Java_configuration in
            style.makeBody(configuration: ButtonStyleConfiguration(Java_configuration: Java_configuration)).Java_viewOrEmpty
        }
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.buttonStyle(isPrimitive: false, environmentKeys: resolvedStyle.environmentKeys, bridgedMakeBody: resolvedStyle.makeBody(Java_configuration:))
        }
    }
}

/// A natively-compiled `ButtonStyle` or `PrimitiveButtonStyle` prepared for SkipUI.
///
/// SwiftUI resolves a style's dynamic properties before creating its body. Skip does not generate that resolution for
/// styles, so the style's `@Environment` properties are synced from each button's Compose environment before its body
/// is created.
struct ResolvedButtonStyle<Style> : @unchecked Sendable {
    /// The keys of the style's `@Environment` properties, which SkipUI reads at each button's position.
    let environmentKeys: [String]
    private let style: Style
    private let makeStyleBody: @MainActor (Style, SkipUI.ButtonStyleBridgedConfiguration) -> any SkipUI.View

    nonisolated init(_ style: Style, makeBody: @escaping @MainActor (Style, SkipUI.ButtonStyleBridgedConfiguration) -> any SkipUI.View) {
        self.environmentKeys = Java_environmentKeys(of: style)
        self.style = style
        self.makeStyleBody = makeBody
    }

    /// Creates the style's body for a button.
    ///
    /// Styles are only used on the main thread during composition.
    nonisolated func makeBody(Java_configuration: SkipUI.ButtonStyleBridgedConfiguration) -> any SkipUI.View {
        let Java_configurationBox = UncheckedSendableBox(Java_configuration)
        return assumeMainActorUnchecked {
            let Java_configuration = Java_configurationBox.wrappedValue
            Java_syncEnvironment(of: style) { Java_configuration.environmentSupport(forKey: $0) }
            return UncheckedSendableBox(makeStyleBody(style, Java_configuration))
        }.wrappedValue
    }
}

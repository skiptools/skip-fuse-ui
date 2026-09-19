// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipFuse
import SkipUI

public struct Toggle<Label> where Label : View {
    private let isOn: Binding<Bool>
    private let label: Label

    public init(isOn: Binding<Bool>, @ViewBuilder label: () -> Label) {
        self.isOn = isOn
        self.label = label()
    }

    public init<C>(sources: C, isOn: KeyPath<C.Element, Binding<Bool>>, @ViewBuilder label: () -> Label) where C : RandomAccessCollection {
        let getIsOn: () -> Bool = { sources.allSatisfy { $0[keyPath: isOn].wrappedValue } }
        let setIsOn: (Bool) -> Void = { value in sources.forEach { $0[keyPath: isOn].wrappedValue = value } }
        self.isOn = Binding(get: getIsOn, set: setIsOn)
        self.label = label()
    }
}

extension Toggle : View {
    public typealias Body = Never
}

extension Toggle : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Toggle(getIsOn: { isOn.wrappedValue }, setIsOn: { isOn.wrappedValue = $0 }, bridgedLabel: label.Java_viewOrEmpty)
    }
}

extension Toggle where Label == ToggleStyleConfiguration.Label {
    public init(_ configuration: ToggleStyleConfiguration) {
        self.isOn = configuration.$isOn
        self.label = configuration.label
    }
}

extension Toggle where Label == Text {
    public init(_ titleKey: LocalizedStringKey, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { Text(titleKey) })
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { Text(titleResource) })
    }

    @_disfavoredOverload public init<S>(_ title: S, isOn: Binding<Bool>) where S : StringProtocol {
        self.init(isOn: isOn, label: { Text(title) })
    }

    public init<C>(_ titleKey: LocalizedStringKey, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where C : RandomAccessCollection {
        self.init(sources: sources, isOn: isOn, label: { Text(titleKey) })
    }

    @_disfavoredOverload public init<C>(_ titleResource: AndroidLocalizedStringResource, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where C : RandomAccessCollection {
        self.init(sources: sources, isOn: isOn, label: { Text(titleResource) })
    }

    @_disfavoredOverload public init<S, C>(_ title: S, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where S : StringProtocol, C : RandomAccessCollection {
        self.init(sources: sources, isOn: isOn, label: { Text(title) })
    }
}

extension Toggle where Label == SkipSwiftUI.Label<Text, Image> {
    public init(_ titleKey: LocalizedStringKey, systemImage: String, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { SkipSwiftUI.Label(titleKey, systemImage: systemImage) })
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, systemImage: String, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { SkipSwiftUI.Label(titleResource, systemImage: systemImage) })
    }

    @_disfavoredOverload public init<S>(_ title: S, systemImage: String, isOn: Binding<Bool>) where S : StringProtocol {
        self.init(isOn: isOn, label: { SkipSwiftUI.Label(title, systemImage: systemImage) })
    }

    public init<C>(_ titleKey: LocalizedStringKey, systemImage: String, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where C : RandomAccessCollection {
        self.init(sources: sources, isOn: isOn, label: { SkipSwiftUI.Label(titleKey, systemImage: systemImage) })
    }

    @_disfavoredOverload public init<C>(_ titleResource: AndroidLocalizedStringResource, systemImage: String, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where C : RandomAccessCollection {
        self.init(sources: sources, isOn: isOn, label: { SkipSwiftUI.Label(titleResource, systemImage: systemImage) })
    }

    @_disfavoredOverload public init<S, C>(_ title: S, systemImage: String, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where S : StringProtocol, C : RandomAccessCollection {
        self.init(sources: sources, isOn: isOn, label: { SkipSwiftUI.Label(title, systemImage: systemImage) })
    }
}

@MainActor @preconcurrency public protocol ToggleStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = ToggleStyleConfiguration

    nonisolated var identifier: Int { get } // For bridging
}

extension ToggleStyle {
    nonisolated public var identifier: Int {
        return -1 // Custom style
    }
}

public struct ButtonToggleStyle : ToggleStyle {
    @available(*, unavailable)
    public init() {
        fatalError()
    }

    @MainActor @preconcurrency public func makeBody(configuration: ButtonToggleStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 1 // For bridging
}

extension ToggleStyle where Self == ButtonToggleStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var button: ButtonToggleStyle {
        fatalError()
    }
}

public struct DefaultToggleStyle : ToggleStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: DefaultToggleStyle.Configuration) -> some View {
        Toggle(configuration).toggleStyle(self)
    }

    public let identifier = 0 // For bridging
}

extension ToggleStyle where Self == DefaultToggleStyle {
    @MainActor @preconcurrency public static var automatic: DefaultToggleStyle {
        return DefaultToggleStyle()
    }
}

public struct SwitchToggleStyle : ToggleStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: SwitchToggleStyle.Configuration) -> some View {
        Toggle(configuration).toggleStyle(self)
    }

    public let identifier = 2 // For bridging
}

extension ToggleStyle where Self == SwitchToggleStyle {
    @MainActor @preconcurrency public static var `switch`: SwitchToggleStyle {
        return SwitchToggleStyle()
    }
}

public struct ToggleStyleConfiguration {
    public struct Label {
        public typealias Body = Never

        let Java_label: any SkipUI.View
    }

    public let label: ToggleStyleConfiguration.Label

    @Binding public var isOn: Bool

    public var isMixed: Bool

    init(Java_configuration: SkipUI.ToggleStyleBridgedConfiguration) {
        let config = Java_configuration
        self._isOn = Binding(get: { config.getIsOn() }, set: { config.setIsOn($0) })
        self.label = Label(Java_label: Java_configuration.label)
        self.isMixed = false
    }
}

extension ToggleStyleConfiguration.Label : View, SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return Java_label
    }
}

extension View {
    nonisolated public func toggleStyle<S>(_ style: S) -> some View where S : ToggleStyle {
        let identifier = style.identifier
        let resolvedStyle = ResolvedToggleStyle(style) { style, Java_configuration in
            style.makeBody(configuration: ToggleStyleConfiguration(Java_configuration: Java_configuration)).Java_viewOrEmpty
        }
        return ModifierView(target: self) {
            guard identifier < 0 else {
                return $0.Java_viewOrEmpty.toggleStyle(bridgedStyle: identifier)
            }
            return $0.Java_viewOrEmpty.toggleStyle(environmentKeys: resolvedStyle.environmentKeys, bridgedMakeBody: resolvedStyle.makeBody(Java_configuration:))
        }
    }
}

/// A natively-compiled `ToggleStyle` prepared for SkipUI.
///
/// SwiftUI resolves a style's dynamic properties before creating its body. Skip does not generate that resolution for
/// styles, so the style's `@Environment` properties are synced from each toggle's Compose environment before its body
/// is created.
struct ResolvedToggleStyle<Style> : @unchecked Sendable {
    /// The keys of the style's `@Environment` properties, which SkipUI reads at each toggle's position.
    let environmentKeys: [String]
    private let style: Style
    private let makeStyleBody: @MainActor (Style, SkipUI.ToggleStyleBridgedConfiguration) -> any SkipUI.View

    nonisolated init(_ style: Style, makeBody: @escaping @MainActor (Style, SkipUI.ToggleStyleBridgedConfiguration) -> any SkipUI.View) {
        self.environmentKeys = Java_environmentKeys(of: style)
        self.style = style
        self.makeStyleBody = makeBody
    }

    /// Creates the style's body for a toggle.
    ///
    /// Styles are only used on the main thread during composition.
    nonisolated func makeBody(Java_configuration: SkipUI.ToggleStyleBridgedConfiguration) -> any SkipUI.View {
        let Java_configurationBox = UncheckedSendableBox(Java_configuration)
        return assumeMainActorUnchecked {
            let Java_configuration = Java_configurationBox.wrappedValue
            Java_syncEnvironment(of: style) { Java_configuration.environmentSupport(forKey: $0) }
            return UncheckedSendableBox(makeStyleBody(style, Java_configuration))
        }.wrappedValue
    }
}

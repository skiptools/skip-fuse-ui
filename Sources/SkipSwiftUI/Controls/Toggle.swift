// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

@MainActor @preconcurrency public struct Toggle<Label> : View where Label : View {
    private let isOn: Binding<Bool>
    private let label: UncheckedSendableBox<Label>

    nonisolated public init(isOn: Binding<Bool>, @ViewBuilder label: () -> Label) {
        self.isOn = isOn
        self.label = UncheckedSendableBox(label())
    }

    nonisolated public init<C>(sources: C, isOn: KeyPath<C.Element, Binding<Bool>>, @ViewBuilder label: () -> Label) where C : RandomAccessCollection {
        let getIsOn: () -> Bool = { sources.allSatisfy { $0[keyPath: isOn].wrappedValue } }
        let setIsOn: (Bool) -> Void = { value in sources.forEach { $0[keyPath: isOn].wrappedValue = value } }
        self.isOn = Binding(get: getIsOn, set: setIsOn)
        self.label = UncheckedSendableBox(label())
    }

    public typealias Body = Never
}

extension Toggle : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Toggle(getIsOn: { isOn.wrappedValue }, setIsOn: { isOn.wrappedValue = $0 }, bridgedLabel: label.wrappedValue.Java_viewOrEmpty)
    }
}

extension Toggle where Label == ToggleStyleConfiguration.Label {
    @available(*, unavailable)
    nonisolated public init(_ configuration: ToggleStyleConfiguration) {
        fatalError()
    }
}

extension Toggle where Label == Text {
    nonisolated public init(_ titleKey: LocalizedStringKey, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { Text(titleKey) })
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, isOn: Binding<Bool>) where S : StringProtocol {
        self.init(isOn: isOn, label: { Text(title) })
    }

    nonisolated public init<C>(_ titleKey: LocalizedStringKey, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where C : RandomAccessCollection {
        self.init(sources: sources, isOn: isOn, label: { Text(titleKey) })
    }

    @_disfavoredOverload nonisolated public init<S, C>(_ title: S, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where S : StringProtocol, C : RandomAccessCollection {
        self.init(sources: sources, isOn: isOn, label: { Text(title) })
    }
}

extension Toggle where Label == SkipSwiftUI.Label<Text, Image> {
    nonisolated public init(_ titleKey: LocalizedStringKey, systemImage: String, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: { SkipSwiftUI.Label(titleKey, systemImage: systemImage) })
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, systemImage: String, isOn: Binding<Bool>) where S : StringProtocol {
        self.init(isOn: isOn, label: { SkipSwiftUI.Label(title, systemImage: systemImage) })
    }

    nonisolated public init<C>(_ titleKey: LocalizedStringKey, systemImage: String, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where C : RandomAccessCollection {
        self.init(sources: sources, isOn: isOn, label: { SkipSwiftUI.Label(titleKey, systemImage: systemImage) })
    }

    @_disfavoredOverload nonisolated public init<S, C>(_ title: S, systemImage: String, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where S : StringProtocol, C : RandomAccessCollection {
        self.init(sources: sources, isOn: isOn, label: { SkipSwiftUI.Label(title, systemImage: systemImage) })
    }
}

//extension Toggle where Label == Label<Text, Image> {
//    nonisolated public init(_ titleKey: LocalizedStringKey, image: ImageResource, isOn: Binding<Bool>)
//
//    @_disfavoredOverload nonisolated public init<S>(_ title: S, image: ImageResource, isOn: Binding<Bool>) where S : StringProtocol
//
//    nonisolated public init<C>(_ titleKey: LocalizedStringKey, image: ImageResource, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where C : RandomAccessCollection
//
//    nonisolated public init<S, C>(_ title: S, image: ImageResource, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where S : StringProtocol, C : RandomAccessCollection
//}

@MainActor @preconcurrency public protocol ToggleStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = ToggleStyleConfiguration
}

@MainActor @preconcurrency public struct ButtonToggleStyle : ToggleStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public init() {
        fatalError()
    }

    @MainActor @preconcurrency public func makeBody(configuration: ButtonToggleStyle.Configuration) -> some View {
        stubView()
    }
}

extension ToggleStyle where Self == ButtonToggleStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var button: ButtonToggleStyle {
        fatalError()
    }
}

@MainActor @preconcurrency public struct DefaultToggleStyle : ToggleStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: ButtonToggleStyle.Configuration) -> some View {
        stubView()
    }
}

extension ToggleStyle where Self == DefaultToggleStyle {
    @MainActor @preconcurrency public static var automatic: DefaultToggleStyle {
        return DefaultToggleStyle()
    }
}

@MainActor @preconcurrency public struct SwitchToggleStyle : ToggleStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: ButtonToggleStyle.Configuration) -> some View {
        stubView()
    }
}

extension ToggleStyle where Self == SwitchToggleStyle {
    @MainActor @preconcurrency public static var `switch`: SwitchToggleStyle {
        return SwitchToggleStyle()
    }
}

public struct ToggleStyleConfiguration {
    @MainActor @preconcurrency public struct Label : View {
        public typealias Body = Never
    }

    public let label: ToggleStyleConfiguration.Label

    @Binding public var isOn: Bool

    public var isMixed: Bool
}

extension View {
    nonisolated public func toggleStyle<S>(_ style: S) -> some View where S : ToggleStyle {
        // Only automatic is @available, so safe to return self
        return self
    }
}

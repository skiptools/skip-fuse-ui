// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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
    @available(*, unavailable)
    public init(_ configuration: ToggleStyleConfiguration) {
        fatalError()
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

//extension Toggle where Label == Label<Text, Image> {
//    public init(_ titleKey: LocalizedStringKey, image: ImageResource, isOn: Binding<Bool>)
//
//    @_disfavoredOverload public init<S>(_ title: S, image: ImageResource, isOn: Binding<Bool>) where S : StringProtocol
//
//    public init<C>(_ titleKey: LocalizedStringKey, image: ImageResource, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where C : RandomAccessCollection
//
//    public init<S, C>(_ title: S, image: ImageResource, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where S : StringProtocol, C : RandomAccessCollection
//}

@MainActor @preconcurrency public protocol ToggleStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = ToggleStyleConfiguration
}

public struct ButtonToggleStyle : ToggleStyle {
    @available(*, unavailable)
    public init() {
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

public struct DefaultToggleStyle : ToggleStyle {
    public init() {
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

public struct SwitchToggleStyle : ToggleStyle {
    public init() {
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
    public struct Label : View {
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

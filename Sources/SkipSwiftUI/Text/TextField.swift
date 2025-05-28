// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipUI

/* @MainActor */ @preconcurrency public struct TextField<Label> : View where Label : View {
    private let text: Binding<String>
    private let prompt: Text?
    private let label: Label

    public typealias Body = Never
}

extension TextField : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.TextField(getText: { text.wrappedValue }, setText: { text.wrappedValue = $0 }, prompt: prompt?.Java_view as? SkipUI.Text, isSecure: false, bridgedLabel: label.Java_viewOrEmpty)
    }
}

extension TextField {
    private static func text<F>(from value: Binding<F.FormatInput?>, format: F) -> Binding<String> where F : ParseableFormatStyle, F.FormatOutput == String {
        let getText: (F.FormatInput?) -> String = {
            guard let input = $0 else {
                return ""
            }
            return format.format(input)
        }
        let setText: (String) -> F.FormatInput? = {
            guard !$0.isEmpty else {
                return nil
            }
            return try? format.parseStrategy.parse($0)
        }
        return Binding<String>(get: { getText(value.wrappedValue) }, set: { value.wrappedValue = setText($0) })
    }

    private static func text<F>(from value: Binding<F.FormatInput>, format: F) -> Binding<String> where F : ParseableFormatStyle, F.FormatOutput == String {
        let getText: (F.FormatInput) -> String = { format.format($0) }
        let setText: (String) -> F.FormatInput = { try! format.parseStrategy.parse($0) }
        return Binding<String>(get: { getText(value.wrappedValue) }, set: { value.wrappedValue = setText($0) })
    }

    // Error: Cannot find AutoreleasingUnsafeMutablePointer in scope
//    private static func text<V>(from value: Binding<V>, formatter: Formatter) -> Binding<String> {
//        let getText: (V) -> String = { formatter.string(for: $0) ?? "" }
//        let setText: (String) -> V = { text in
//            var object: AnyObject?
//            withUnsafeMutablePointer(to: &object) { ptr in
//                let autoptr = AutoreleasingUnsafeMutablePointer<AnyObject?>(ptr)
//                formatter.getObjectValue(autoptr, for: text, errorDescription: nil)
//            }
//            return object as! V
//        }
//        return Binding<String>(get: { getText(value.wrappedValue) }, set: { value.wrappedValue = setText($0) })
//    }
}

extension TextField where Label == Text {
    nonisolated public init<F>(_ titleKey: LocalizedStringKey, value: Binding<F.FormatInput?>, format: F, prompt: Text? = nil) where F : ParseableFormatStyle, F.FormatOutput == String {
        self.text = Self.text(from: value, format: format)
        self.label = Text(titleKey)
        self.prompt = prompt
    }

    @_disfavoredOverload nonisolated public init<S, F>(_ title: S, value: Binding<F.FormatInput?>, format: F, prompt: Text? = nil) where S : StringProtocol, F : ParseableFormatStyle, F.FormatOutput == String {
        self.text = Self.text(from: value, format: format)
        self.label = Text(title)
        self.prompt = prompt
    }

    nonisolated public init<F>(_ titleKey: LocalizedStringKey, value: Binding<F.FormatInput>, format: F, prompt: Text? = nil) where F : ParseableFormatStyle, F.FormatOutput == String {
        self.text = Self.text(from: value, format: format)
        self.label = Text(titleKey)
        self.prompt = prompt
    }

    @_disfavoredOverload nonisolated public init<S, F>(_ title: S, value: Binding<F.FormatInput>, format: F, prompt: Text? = nil) where S : StringProtocol, F : ParseableFormatStyle, F.FormatOutput == String {
        self.text = Self.text(from: value, format: format)
        self.label = Text(title)
        self.prompt = prompt
    }
}

extension TextField {
    nonisolated public init<F>(value: Binding<F.FormatInput?>, format: F, prompt: Text? = nil, @ViewBuilder label: () -> Label) where F : ParseableFormatStyle, F.FormatOutput == String {
        self.text = Self.text(from: value, format: format)
        self.label = label()
        self.prompt = prompt
    }

    nonisolated public init<F>(value: Binding<F.FormatInput>, format: F, prompt: Text? = nil, @ViewBuilder label: () -> Label) where F : ParseableFormatStyle, F.FormatOutput == String {
        self.text = Self.text(from: value, format: format)
        self.label = label()
        self.prompt = prompt
    }
}

extension TextField where Label == Text {
    @available(*, unavailable)
    nonisolated public init<V>(_ titleKey: LocalizedStringKey, value: Binding<V>, formatter: Formatter, prompt: Text?) {
        fatalError()
//        self.text = Self.text(from: value, formatter: formatter)
//        self.label = Text(titleKey)
//        self.prompt = prompt
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<S, V>(_ title: S, value: Binding<V>, formatter: Formatter, prompt: Text?) where S : StringProtocol {
        fatalError()
//        self.text = Self.text(from: value, formatter: formatter)
//        self.label = Text(title)
//        self.prompt = prompt
    }
}

extension TextField {
    @available(*, unavailable)
    nonisolated public init<V>(value: Binding<V>, formatter: Formatter, prompt: Text? = nil, @ViewBuilder label: () -> Label) {
        fatalError()
//        self.text = Self.text(from: value, formatter: formatter)
//        self.label = label()
//        self.prompt = prompt
    }
}

extension TextField where Label == Text {
    @available(*, unavailable)
    nonisolated public init<V>(_ titleKey: LocalizedStringKey, value: Binding<V>, formatter: Formatter) {
        fatalError()
//        self.text = Self.text(from: value, formatter: formatter)
//        self.label = Text(titleKey)
//        self.prompt = nil
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<S, V>(_ title: S, value: Binding<V>, formatter: Formatter) where S : StringProtocol {
        fatalError()
//        self.text = Self.text(from: value, formatter: formatter)
//        self.label = Text(title)
//        self.prompt = nil
    }
}

extension TextField where Label == Text {
    @available(*, unavailable)
    nonisolated public init<V>(_ titleKey: LocalizedStringKey, value: Binding<V>, formatter: Formatter, onEditingChanged: @escaping (Bool) -> Void, onCommit: @escaping () -> Void) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<V>(_ titleKey: LocalizedStringKey, value: Binding<V>, formatter: Formatter, onEditingChanged: @escaping (Bool) -> Void) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<V>(_ titleKey: LocalizedStringKey, value: Binding<V>, formatter: Formatter, onCommit: @escaping () -> Void) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<S, V>(_ title: S, value: Binding<V>, formatter: Formatter, onEditingChanged: @escaping (Bool) -> Void, onCommit: @escaping () -> Void) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<S, V>(_ title: S, value: Binding<V>, formatter: Formatter, onEditingChanged: @escaping (Bool) -> Void) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<S, V>(_ title: S, value: Binding<V>, formatter: Formatter, onCommit: @escaping () -> Void) where S : StringProtocol {
        fatalError()
    }
}

extension TextField where Label == Text {
    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, text: Binding<String>, axis: Axis) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text?, axis: Axis) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<S>(_ title: S, text: Binding<String>, axis: Axis) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<S>(_ title: S, text: Binding<String>, prompt: Text?, axis: Axis) where S : StringProtocol {
        fatalError()
    }
}

extension TextField {
    @available(*, unavailable)
    nonisolated public init(text: Binding<String>, prompt: Text? = nil, axis: Axis, @ViewBuilder label: () -> Label) {
        fatalError()
    }
}

extension TextField where Label == Text {
    nonisolated public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text?) {
        self.text = text
        self.label = Text(titleKey)
        self.prompt = prompt
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, text: Binding<String>, prompt: Text?) where S : StringProtocol {
        self.text = text
        self.label = Text(title)
        self.prompt = prompt
    }
}

extension TextField {
    nonisolated public init(text: Binding<String>, prompt: Text? = nil, @ViewBuilder label: () -> Label) {
        self.text = text
        self.label = label()
        self.prompt = prompt
    }
}

#if compiler(>=6.0)
extension TextField where Label == Text {
    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, text: Binding<String>, selection: Binding<TextSelection?>, prompt: Text? = nil, axis: Axis? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<S>(_ title: S, text: Binding<String>, selection: Binding<TextSelection?>, prompt: Text? = nil, axis: Axis? = nil) where S : StringProtocol {
        fatalError()
    }
}
#endif

extension TextField where Label == Text {
    nonisolated public init(_ titleKey: LocalizedStringKey, text: Binding<String>) {
        self.text = text
        self.label = Text(titleKey)
        self.prompt = nil
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, text: Binding<String>) where S : StringProtocol {
        self.text = text
        self.label = Text(title)
        self.prompt = nil
    }
}

extension TextField where Label == Text {
    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, text: Binding<String>, onEditingChanged: @escaping (Bool) -> Void, onCommit: @escaping () -> Void) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, text: Binding<String>, onEditingChanged: @escaping (Bool) -> Void) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, text: Binding<String>, onCommit: @escaping () -> Void) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<S>(_ title: S, text: Binding<String>, onEditingChanged: @escaping (Bool) -> Void, onCommit: @escaping () -> Void) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<S>(_ title: S, text: Binding<String>, onEditingChanged: @escaping (Bool) -> Void) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<S>(_ title: S, text: Binding<String>, onCommit: @escaping () -> Void) where S : StringProtocol {
        fatalError()
    }
}

public protocol TextFieldStyle {
    var identifier: Int { get } // For bridging
}

extension TextFieldStyle {
    public var identifier: Int {
        return -1
    }
}

public struct DefaultTextFieldStyle : TextFieldStyle {
    public init() {
    }

    public let identifier = 0 // For bridging
}

extension TextFieldStyle where Self == DefaultTextFieldStyle {
    public static var automatic: DefaultTextFieldStyle {
        return DefaultTextFieldStyle()
    }
}

public struct RoundedBorderTextFieldStyle : TextFieldStyle {
    public init() {
    }

    public let identifier = 1 // For bridging
}

extension TextFieldStyle where Self == RoundedBorderTextFieldStyle {
    public static var roundedBorder: RoundedBorderTextFieldStyle {
        return RoundedBorderTextFieldStyle()
    }
}

public struct PlainTextFieldStyle : TextFieldStyle {
    public init() {
    }

    public let identifier = 2 // For bridging
}

extension TextFieldStyle where Self == PlainTextFieldStyle {
    public static var plain: PlainTextFieldStyle {
        return PlainTextFieldStyle()
    }
}

extension View {
    nonisolated public func autocorrectionDisabled(_ disable: Bool = true) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.autocorrectionDisabled(disable)
        }
    }
}

extension View {
    nonisolated public func keyboardType(_ type: UIKeyboardType) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.keyboardType(bridgedType: type.rawValue)
        }
    }
}

extension View {
    nonisolated public func onSubmit(of triggers: SubmitTriggers = .text, _ action: @escaping () -> Void) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onSubmit(bridgedTriggers: triggers.rawValue, action: action)
        }
    }

    @available(*, unavailable)
    nonisolated public func submitScope(_ isBlocking: Bool = true) -> some View {
        stubView()
    }
}

extension View {
    nonisolated public func submitLabel(_ submitLabel: SubmitLabel) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.submitLabel(bridgedLabel: submitLabel.identifier)
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func textContentType(_ textContentType: UITextContentType?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.textContentType(bridgedContentType: textContentType?.rawValue ?? -1)
        }
    }
}

extension View {
    nonisolated public func textFieldStyle<S>(_ style: S) -> some View where S : TextFieldStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.textFieldStyle(bridgedStyle: style.identifier)
        }
    }
}

extension View {
    nonisolated public func textInputAutocapitalization(_ autocapitalization: TextInputAutocapitalization?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.textInputAutocapitalization(bridgedAutocapitalization: autocapitalization?.identifier)
        }
    }
}

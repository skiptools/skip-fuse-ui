// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipFuse
import SkipUI

public struct SecureField<Label> where Label : View {
    private let text: Binding<String>
    private let prompt: Text?
    private let label: Label
    private var selection: Binding<TextSelection?>? = nil
}

extension SecureField : View {
    public typealias Body = Never
}

extension SecureField : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.TextField(getText: { text.wrappedValue }, setText: { text.wrappedValue = $0 }, getSelection: { selection?.wrappedValue }, setSelection: { selection?.wrappedValue = $0 }, prompt: prompt?.Java_view as? SkipUI.Text, isSecure: true, bridgedLabel: label.Java_viewOrEmpty)
    }
}

extension SecureField where Label == Text {
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text?) {
        self.label = Text(titleKey)
        self.text = text
        self.prompt = prompt
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, text: Binding<String>, prompt: Text?) {
        self.label = Text(titleResource)
        self.text = text
        self.prompt = prompt
    }

    @_disfavoredOverload public init<S>(_ title: S, text: Binding<String>, prompt: Text?) where S : StringProtocol {
        self.label = Text(title)
        self.text = text
        self.prompt = prompt
    }
}

extension SecureField {
    public init(text: Binding<String>, prompt: Text? = nil, @ViewBuilder label: () -> Label) {
        self.label = label()
        self.text = text
        self.prompt = prompt
    }
}

extension SecureField where Label == Text {
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>) {
        self.label = Text(titleKey)
        self.text = text
        self.prompt = nil
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, text: Binding<String>) {
        self.label = Text(titleResource)
        self.text = text
        self.prompt = nil
    }

    @_disfavoredOverload public init<S>(_ title: S, text: Binding<String>) where S : StringProtocol {
        self.label = Text(title)
        self.text = text
        self.prompt = nil
    }
}

extension SecureField where Label == Text {
    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, onCommit: @escaping () -> Void) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, text: Binding<String>, onCommit: @escaping () -> Void) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init<S>(_ title: S, text: Binding<String>, onCommit: @escaping () -> Void) where S : StringProtocol {
        fatalError()
    }
}

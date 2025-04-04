// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

/* @MainActor @preconcurrency */ public struct SecureField<Label> : View where Label : View {
    private let text: Binding<String>
    private let prompt: Text?
    private let label: Label

    public typealias Body = Never
}

extension SecureField : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.TextField(getText: { text.wrappedValue }, setText: { text.wrappedValue = $0 }, prompt: prompt?.Java_view as? SkipUI.Text, isSecure: true, bridgedLabel: label.Java_viewOrEmpty)
    }
}

extension SecureField where Label == Text {
    /* nonisolated */ public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text?) {
        self.label = Text(titleKey)
        self.text = text
        self.prompt = prompt
    }

    @_disfavoredOverload /* nonisolated */ public init<S>(_ title: S, text: Binding<String>, prompt: Text?) where S : StringProtocol {
        self.label = Text(title)
        self.text = text
        self.prompt = prompt
    }
}

extension SecureField {
    /* nonisolated */ public init(text: Binding<String>, prompt: Text? = nil, @ViewBuilder label: () -> Label) {
        self.label = label()
        self.text = text
        self.prompt = prompt
    }
}

extension SecureField where Label == Text {
    /* nonisolated */ public init(_ titleKey: LocalizedStringKey, text: Binding<String>) {
        self.label = Text(titleKey)
        self.text = text
        self.prompt = nil
    }

    @_disfavoredOverload /* nonisolated */ public init<S>(_ title: S, text: Binding<String>) where S : StringProtocol {
        self.label = Text(title)
        self.text = text
        self.prompt = nil
    }
}

extension SecureField where Label == Text {
    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, text: Binding<String>, onCommit: @escaping () -> Void) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<S>(_ title: S, text: Binding<String>, onCommit: @escaping () -> Void) where S : StringProtocol {
        fatalError()
    }
}

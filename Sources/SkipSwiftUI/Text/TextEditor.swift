// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

@MainActor @preconcurrency public struct TextEditor : View {
    private let text: Binding<String>

    nonisolated public init(text: Binding<String>) {
        self.text = text
    }

    #if compiler(>=6.0)
    @available(*, unavailable)
    nonisolated public init(text: Binding<String>, selection: Binding<TextSelection?>) {
        fatalError()
    }
    #endif

    public typealias Body = Never
}

extension TextEditor : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.TextEditor(getText: { text.wrappedValue }, setText: { text.wrappedValue = $0 })
    }
}

@MainActor @preconcurrency public protocol TextEditorStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = TextEditorStyleConfiguration

    nonisolated var identifier: Int { get } // For bridging
}

extension TextEditorStyle {
    nonisolated public var identifier: Int {
        return -1
    }
}

@MainActor @preconcurrency public struct AutomaticTextEditorStyle : TextEditorStyle {
    @MainActor @preconcurrency public func makeBody(configuration: AutomaticTextEditorStyle.Configuration) ->     AutomaticTextEditorStyle.Body {
        Body()
    }

    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public struct Body : View {
        public typealias Body = Never
    }

    public let identifier = 0 // For bridging
}

extension TextEditorStyle where Self == AutomaticTextEditorStyle {
    @MainActor @preconcurrency public static var automatic: AutomaticTextEditorStyle {
        return AutomaticTextEditorStyle()
    }
}

@MainActor @preconcurrency public struct PlainTextEditorStyle : TextEditorStyle {
    @MainActor @preconcurrency public func makeBody(configuration: PlainTextEditorStyle.Configuration) -> some View {
        stubView()
    }

    @MainActor @preconcurrency public init() {
    }

    public let identifier = 1 // For bridging
}

extension TextEditorStyle where Self == PlainTextEditorStyle {
    @MainActor @preconcurrency public static var plain: PlainTextEditorStyle {
        return PlainTextEditorStyle()
    }
}

public struct TextEditorStyleConfiguration {
}

extension View {
    nonisolated public func textEditorStyle(_ style: some TextEditorStyle) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.textEditorStyle(bridgedStyle: style.identifier)
        }
    }

    @available(*, unavailable)
    nonisolated public func findNavigator(isPresented: Binding<Bool>) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func findDisabled(_ isDisabled: Bool = true) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func replaceDisabled(_ isDisabled: Bool = true) -> some View {
        stubView()
    }
}

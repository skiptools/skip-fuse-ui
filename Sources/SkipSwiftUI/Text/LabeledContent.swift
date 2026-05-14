// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SkipFuse
import SkipUI

public struct LabeledContent<Label, Content> where Label: View, Content: View {
    private let content: Content
    private let label: Label
    
    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.content = content()
        self.label = label()
    }
}

extension LabeledContent: View {
    public typealias Body = Never
}

extension LabeledContent : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.LabeledContent(bridgedContent: content.Java_viewOrEmpty, bridgedLabel: label.Java_viewOrEmpty)
    }
}

extension LabeledContent where Label == Text, Content : View {
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.label = Text(titleKey)
        self.content = content()
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, @ViewBuilder content: () -> Content) {
        self.label = Text(titleResource)
        self.content = content()
    }

    @_disfavoredOverload public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.label = Text(title)
        self.content = content()
    }
}

extension LabeledContent where Label == Text, Content == Text {
    public init<S>(_ titleKey: LocalizedStringKey, value: S) where S : StringProtocol {
        self.label = Text(titleKey)
        self.content = Text(value)
    }

    @_disfavoredOverload public init<S>(_ titleResource: AndroidLocalizedStringResource, value: S) where S : StringProtocol {
        self.label = Text(titleResource)
        self.content = Text(value)
    }

    @_disfavoredOverload public init<S1, S2>(_ title: S1, value: S2) where S1 : StringProtocol, S2 : StringProtocol {
        self.label = Text(title)
        self.content = Text(value)
    }

    public init<F>(_ titleKey: LocalizedStringKey, value: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String {
        self.label = Text(titleKey)
        self.content = Text(value, format: format)
    }

    @_disfavoredOverload public init<F>(_ titleResource: AndroidLocalizedStringResource, value: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String {
        self.label = Text(titleResource)
        self.content = Text(value, format: format)
    }

    @_disfavoredOverload public init<S, F>(_ title: S, value: F.FormatInput, format: F) where S : StringProtocol, F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String {
        self.label = Text(title)
        self.content = Text(value, format: format)
    }
}

extension LabeledContent where Label == LabeledContentStyleConfiguration.Label, Content == LabeledContentStyleConfiguration.Content {
    public init(_ configuration: LabeledContentStyleConfiguration) {
        self.label = configuration.label
        self.content = configuration.content
    }
}

@MainActor @preconcurrency public protocol LabeledContentStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = LabeledContentStyleConfiguration
}

public struct AutomaticLabeledContentStyle : LabeledContentStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: AutomaticLabeledContentStyle.Configuration) -> some View {
        stubView()
    }
}

extension LabeledContentStyle where Self == AutomaticLabeledContentStyle {
    @MainActor @preconcurrency public static var automatic: AutomaticLabeledContentStyle {
        return AutomaticLabeledContentStyle()
    }
}

public struct LabeledContentStyleConfiguration {
    public struct Label : View {
        public typealias Body = Never
    }

    public struct Content : View {
        public typealias Body = Never
    }

    public let label = LabeledContentStyleConfiguration.Label()
    public let content = LabeledContentStyleConfiguration.Content()
}

extension View {
    nonisolated public func labeledContentStyle<S>(_ style: S) -> some View where S : LabeledContentStyle {
        stubView()
    }
}

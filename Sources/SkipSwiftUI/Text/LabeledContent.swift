// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation

public struct LabeledContent<Label, Content> {
}

extension LabeledContent : View where Label : View, Content : View {
    @available(*, unavailable)
    /* nonisolated */ public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        fatalError()
    }

    public typealias Body = Never
}

extension LabeledContent where Label == Text, Content : View {
    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S : StringProtocol {
        fatalError()
    }
}

extension LabeledContent where Label == Text, Content == Text {
    @available(*, unavailable)
    @_disfavoredOverload public init<S>(_ titleKey: LocalizedStringKey, value: S) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    public init<S1, S2>(_ title: S1, value: S2) where S1 : StringProtocol, S2 : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    public init<F>(_ titleKey: LocalizedStringKey, value: F.FormatInput, format: F) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init<S, F>(_ title: S, value: F.FormatInput, format: F) where S : StringProtocol, F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String {
        fatalError()
    }
}

extension LabeledContent where Label == LabeledContentStyleConfiguration.Label, Content == LabeledContentStyleConfiguration.Content {
    @available(*, unavailable)
    public init(_ configuration: LabeledContentStyleConfiguration) {
        fatalError()
    }
}

/* @MainActor @preconcurrency */ public protocol LabeledContentStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor /* @preconcurrency */ func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = LabeledContentStyleConfiguration
}

/* @MainActor @preconcurrency */ public struct AutomaticLabeledContentStyle : LabeledContentStyle {
    /* @MainActor @preconcurrency */ public init() {
    }

    @MainActor /* @preconcurrency */ public func makeBody(configuration: AutomaticLabeledContentStyle.Configuration) -> some View {
        stubView()
    }
}

extension LabeledContentStyle where Self == AutomaticLabeledContentStyle {
    /* @MainActor @preconcurrency */ public static var automatic: AutomaticLabeledContentStyle {
        return AutomaticLabeledContentStyle()
    }
}

public struct LabeledContentStyleConfiguration {
    /* @MainActor @preconcurrency */ public struct Label : View {
        public typealias Body = Never
    }

    /* @MainActor @preconcurrency */ public struct Content : View {
        public typealias Body = Never
    }

    public let label = LabeledContentStyleConfiguration.Label()
    public let content = LabeledContentStyleConfiguration.Content()
}

extension View {
    @available(*, unavailable)
    /* nonisolated */ public func labeledContentStyle<S>(_ style: S) -> some View where S : LabeledContentStyle {
        stubView()
    }
}

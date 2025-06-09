// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

@MainActor @preconcurrency public struct DisclosureGroup<Label, Content> : View where Label : View, Content : View {
    private let isExpanded: Binding<Bool>
    private let label: UncheckedSendableBox<Label>
    private let content: UncheckedSendableBox<Content>

    @available(*, unavailable)
    nonisolated public init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder label: () -> Label) {
        fatalError()
    }

    nonisolated public init(isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content, @ViewBuilder label: () -> Label) {
        self.isExpanded = isExpanded
        self.content = UncheckedSendableBox(content())
        self.label = UncheckedSendableBox(label())
    }

    public typealias Body = Never
}

extension DisclosureGroup : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.DisclosureGroup(getExpanded: { isExpanded.wrappedValue }, setExpanded: { isExpanded.wrappedValue = $0 }, bridgedContent: content.wrappedValue.Java_viewOrEmpty, bridgedLabel: label.wrappedValue.Java_viewOrEmpty)
    }
}

extension DisclosureGroup where Label == Text {
    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content) {
        fatalError()
    }

    nonisolated public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.init(isExpanded: isExpanded, content: content, label: { Text(titleKey) })
    }

    @available(*, unavailable)
    nonisolated public init<S>(_ label: S, @ViewBuilder content: @escaping () -> Content) where S : StringProtocol {
        fatalError()
    }

    @_disfavoredOverload nonisolated public init<S>(_ label: S, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) where S : StringProtocol {
        self.init(isExpanded: isExpanded, content: content, label: { Text(label) })
    }
}

@MainActor @preconcurrency public protocol DisclosureGroupStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = DisclosureGroupStyleConfiguration
}

@MainActor @preconcurrency public struct AutomaticDisclosureGroupStyle : DisclosureGroupStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: AutomaticDisclosureGroupStyle.Configuration) -> some View {
        stubView()
    }
}

extension DisclosureGroupStyle where Self == AutomaticDisclosureGroupStyle {
    @MainActor @preconcurrency public static var automatic: AutomaticDisclosureGroupStyle {
        return AutomaticDisclosureGroupStyle()
    }
}

public struct DisclosureGroupStyleConfiguration {
    @MainActor @preconcurrency public struct Label : View {
        public typealias Body = Never
    }

    public let label: DisclosureGroupStyleConfiguration.Label

    @MainActor @preconcurrency public struct Content : View {
        public typealias Body = Never
    }

    public let content: DisclosureGroupStyleConfiguration.Content

    @Binding public var isExpanded: Bool
}

extension View {
    nonisolated public func disclosureGroupStyle<S>(_ style: S) -> some View where S : DisclosureGroupStyle {
        // We only support .automatic style
        return self
    }
}

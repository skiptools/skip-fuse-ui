// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipFuse
import SkipUI

public struct DisclosureGroup<Label, Content> where Label : View, Content : View {
    private let isExpanded: Binding<Bool>
    private let label: Label
    private let content: Content

    @available(*, unavailable)
    public init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder label: () -> Label) {
        fatalError()
    }

    public init(isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content, @ViewBuilder label: () -> Label) {
        self.isExpanded = isExpanded
        self.content = content()
        self.label = label()
    }
}

extension DisclosureGroup : View {
    public typealias Body = Never
}

extension DisclosureGroup : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.DisclosureGroup(getExpanded: { isExpanded.wrappedValue }, setExpanded: { isExpanded.wrappedValue = $0 }, bridgedContent: content.Java_viewOrEmpty, bridgedLabel: label.Java_viewOrEmpty)
    }
}

extension DisclosureGroup where Label == Text {
    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, @ViewBuilder content: @escaping () -> Content) {
        fatalError()
    }

    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.init(isExpanded: isExpanded, content: content, label: { Text(titleKey) })
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.init(isExpanded: isExpanded, content: content, label: { Text(titleResource) })
    }

    @available(*, unavailable)
    public init<S>(_ label: S, @ViewBuilder content: @escaping () -> Content) where S : StringProtocol {
        fatalError()
    }

    @_disfavoredOverload public init<S>(_ label: S, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) where S : StringProtocol {
        self.init(isExpanded: isExpanded, content: content, label: { Text(label) })
    }
}

@MainActor @preconcurrency public protocol DisclosureGroupStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = DisclosureGroupStyleConfiguration
}

public struct AutomaticDisclosureGroupStyle : DisclosureGroupStyle {
    public init() {
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
    public struct Label : View {
        public typealias Body = Never
    }

    public let label: DisclosureGroupStyleConfiguration.Label

    public struct Content : View {
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

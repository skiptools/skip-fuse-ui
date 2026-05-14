// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipFuse
import SkipUI

public struct GroupBox<Label, Content> where Label : View, Content : View {
    private let label: Label?
    private let content: Content
}

extension GroupBox : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.GroupBox(bridgedLabel: (label as? SkipUIBridging)?.Java_view, bridgedContent: (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView())
    }
}

extension GroupBox : View {
    public typealias Body = Never
}

extension GroupBox where Label : View, Content : View {
    public init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.label = label()
        self.content = content()
    }
}

extension GroupBox where Label == EmptyView, Content : View {
    public init(@ViewBuilder content: () -> Content) {
        self.label = nil
        self.content = content()
    }
}

extension GroupBox where Label == Text, Content : View {
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.label = Text(titleKey) as? Label
        self.content = content()
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, @ViewBuilder content: () -> Content) {
        self.label = Text(titleResource) as? Label
        self.content = content()
    }

    @_disfavoredOverload public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.label = Text(title) as? Label
        self.content = content()
    }
}

extension GroupBox where Label : View, Content : View {
    @available(iOS, deprecated: 100000.0, renamed: "GroupBox(content:label:)")
    public init(label: Label, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
}

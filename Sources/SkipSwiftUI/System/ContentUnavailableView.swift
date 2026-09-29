// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipFuse
import SkipUI

/// A label, description, and actions shown when a view's content is unavailable.
public struct ContentUnavailableView<Label, Description, Actions> where Label : View, Description : View, Actions : View {
    private let label: Label
    private let description: Description
    private let actions: Actions

    public init(@ViewBuilder label: () -> Label, @ViewBuilder description: () -> Description = { EmptyView() }, @ViewBuilder actions: () -> Actions = { EmptyView() }) {
        self.label = label()
        self.description = description()
        self.actions = actions()
    }
}

extension ContentUnavailableView : View {
    public typealias Body = Never
}

extension ContentUnavailableView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ContentUnavailableView(bridgedLabel: label.Java_viewOrEmpty, bridgedDescription: description.Java_viewOrEmpty, bridgedActions: actions.Java_viewOrEmpty)
    }
}

extension ContentUnavailableView where Label == SkipSwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    public init(_ titleKey: LocalizedStringKey, image name: String, description: Text? = nil) {
        self.init(label: { SkipSwiftUI.Label(titleKey, image: name) }, description: { description })
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, image name: String, description: Text? = nil) {
        self.init(label: { SkipSwiftUI.Label(titleResource, image: name) }, description: { description })
    }

    @_disfavoredOverload public init<S>(_ title: S, image name: String, description: Text? = nil) where S : StringProtocol {
        self.init(label: { SkipSwiftUI.Label(title, image: name) }, description: { description })
    }

    public init(_ titleKey: LocalizedStringKey, systemImage name: String, description: Text? = nil) {
        self.init(label: { SkipSwiftUI.Label(titleKey, systemImage: name) }, description: { description })
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, systemImage name: String, description: Text? = nil) {
        self.init(label: { SkipSwiftUI.Label(titleResource, systemImage: name) }, description: { description })
    }

    @_disfavoredOverload public init<S>(_ title: S, systemImage name: String, description: Text? = nil) where S : StringProtocol {
        self.init(label: { SkipSwiftUI.Label(title, systemImage: name) }, description: { description })
    }
}

extension ContentUnavailableView where Label == SearchUnavailableContent.Label, Description == SearchUnavailableContent.Description, Actions == SearchUnavailableContent.Actions {
    /// Indicates that there are no search results.
    public static var search: ContentUnavailableView<SearchUnavailableContent.Label, SearchUnavailableContent.Description, SearchUnavailableContent.Actions> {
        return search(text: nil)
    }

    /// Indicates that there are no search results for `text`.
    public static func search(text: String) -> ContentUnavailableView<SearchUnavailableContent.Label, SearchUnavailableContent.Description, SearchUnavailableContent.Actions> {
        return search(text: Optional(text))
    }

    private static func search(text: String?) -> ContentUnavailableView<SearchUnavailableContent.Label, SearchUnavailableContent.Description, SearchUnavailableContent.Actions> {
        return ContentUnavailableView(label: { SearchUnavailableContent.Label(text: text) }, description: { SearchUnavailableContent.Description() }, actions: { SearchUnavailableContent.Actions() })
    }
}

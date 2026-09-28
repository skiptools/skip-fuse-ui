// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipFuse
import SkipUI

public struct SearchFieldPlacement : Sendable {
    let identifier: Int // For bridging

    public static let automatic = SearchFieldPlacement(identifier: 0)

    @available(*, unavailable)
    public static let toolbar = SearchFieldPlacement(identifier: 1)

    @available(*, unavailable)
    public static let sidebar = SearchFieldPlacement(identifier: 2)

    public static let navigationBarDrawer = SearchFieldPlacement(identifier: 3)

    /// With `.always`, the search field stays visible instead of scrolling away with the content.
    public static func navigationBarDrawer(displayMode: SearchFieldPlacement.NavigationBarDrawerDisplayMode) -> SearchFieldPlacement {
        return SearchFieldPlacement(identifier: displayMode == .always ? 4 : 3)
    }

    public enum NavigationBarDrawerDisplayMode : Sendable {
        case automatic
        case always
    }
}

public struct SearchPresentationToolbarBehavior {
    public static var automatic: SearchPresentationToolbarBehavior {
        return SearchPresentationToolbarBehavior()
    }

    @available(*, unavailable)
    public static var avoidHidingContent: SearchPresentationToolbarBehavior {
        fatalError()
    }
}

public struct SearchScopeActivation {
    let identifier: Int // For bridging

    public static var automatic: SearchScopeActivation {
        return SearchScopeActivation(identifier: 0)
    }

    public static var onTextEntry: SearchScopeActivation {
        return SearchScopeActivation(identifier: 1)
    }

    public static var onSearchPresentation: SearchScopeActivation {
        return SearchScopeActivation(identifier: 2)
    }
}

public struct SearchSuggestionsPlacement : Equatable, Sendable {
    public static var automatic: SearchSuggestionsPlacement {
        return SearchSuggestionsPlacement()
    }

    public static var menu: SearchSuggestionsPlacement {
        return SearchSuggestionsPlacement()
    }

    public static var content: SearchSuggestionsPlacement {
        return SearchSuggestionsPlacement()
    }

    public struct Set : OptionSet, Sendable {
        public var rawValue: Int

        public static var menu: SearchSuggestionsPlacement.Set {
            return SearchSuggestionsPlacement.Set(rawValue: 1 << 0)
        }

        public static var content: SearchSuggestionsPlacement.Set {
            return SearchSuggestionsPlacement.Set(rawValue: 1 << 1)
        }

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

public struct SearchUnavailableContent {
    public struct Label : View {
        let text: String?

        public typealias Body = Never
    }

    public struct Description : View {
        public typealias Body = Never
    }

    public struct Actions : View {
        public typealias Body = Never
    }
}

extension SearchUnavailableContent.Label : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let title = text.map { "No Results for \u{201C}\($0)\u{201D}" } ?? "No Results"
        return SkipSwiftUI.Label(title, systemImage: "magnifyingglass").Java_view
    }
}

extension SearchUnavailableContent.Description : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return Text("Check the spelling or try a new search.").Java_view
    }
}

extension SearchUnavailableContent.Actions : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.EmptyView()
    }
}

public struct FindContext : Sendable {
    public var isPresented: Binding<Bool>?
    public var supportsReplace: Bool
}

extension View {
    nonisolated public func searchable(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.searchable(getText: text.get, setText: text.set, prompt: prompt?.Java_view as? SkipUI.Text, bridgedPlacement: placement.identifier)
        }
    }

    nonisolated public func searchable(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey) -> some View {
        return searchable(text: text, placement: placement, prompt: Text(prompt))
    }

    @_disfavoredOverload nonisolated public func searchable(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: AndroidLocalizedStringResource) -> some View {
        return searchable(text: text, placement: placement, prompt: Text(prompt))
    }

    @_disfavoredOverload nonisolated public func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: S) -> some View where S : StringProtocol {
        return searchable(text: text, placement: placement, prompt: Text(prompt))
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func searchable(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey) -> some View {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: AndroidLocalizedStringResource) -> some View {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable<S>(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: S) -> some View where S : StringProtocol {
        stubView()
    }
}

extension View {
    nonisolated public func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder suggestions: () -> S) -> some View where S : View {
        return searchable(text: text, placement: placement, prompt: prompt).searchSuggestions(suggestions)
    }

    nonisolated public func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder suggestions: () -> S) -> some View where S : View {
        return searchable(text: text, placement: placement, prompt: Text(prompt), suggestions: suggestions)
    }

    @_disfavoredOverload nonisolated public func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: AndroidLocalizedStringResource, @ViewBuilder suggestions: () -> S) -> some View where S : View {
        return searchable(text: text, placement: placement, prompt: Text(prompt), suggestions: suggestions)
    }

    @_disfavoredOverload nonisolated public func searchable<V, S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder suggestions: () -> V) -> some View where V : View, S : StringProtocol {
        return searchable(text: text, placement: placement, prompt: Text(prompt), suggestions: suggestions)
    }
}

extension View {
    /// Suggestions replace a searchable `List`'s rows while its search field is focused.
    nonisolated public func searchSuggestions<S>(@ViewBuilder _ suggestions: () -> S) -> some View where S : View {
        let suggestions = suggestions()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.searchSuggestions(bridgedSuggestions: suggestions.Java_viewOrEmpty)
        }
    }

    nonisolated public func searchSuggestions(_ visibility: Visibility, for placements: SearchSuggestionsPlacement.Set) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.searchSuggestions(bridgedVisibility: visibility.rawValue, bridgedPlacements: placements.rawValue)
        }
    }

    /// Tapping this suggestion replaces the search text with `completion` and submits the search.
    nonisolated public func searchCompletion(_ completion: String) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.searchCompletion(completion)
        }
    }

    nonisolated public func searchScopes<V, S>(_ scope: Binding<V>, @ViewBuilder scopes: () -> S) -> some View where V : Hashable, S : View {
        return searchScopes(scope, activation: .automatic, scopes)
    }

    /// Scopes render as a segmented picker below the search field.
    nonisolated public func searchScopes<V, S>(_ scope: Binding<V>, activation: SearchScopeActivation, @ViewBuilder _ scopes: () -> S) -> some View where V : Hashable, S : View {
        let scopes = scopes()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.searchScopes(getScope: { Java_swiftHashable(for: scope.wrappedValue) }, setScope: {
                if let value: V = Java_bridgedTagValue($0) {
                    scope.wrappedValue = value
                }
            }, bridgedActivation: activation.identifier, bridgedScopes: scopes.Java_viewOrEmpty)
        }
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: AndroidLocalizedStringResource, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: AndroidLocalizedStringResource, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: some StringProtocol, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: AndroidLocalizedStringResource, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: AndroidLocalizedStringResource, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: some StringProtocol, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: AndroidLocalizedStringResource, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: AndroidLocalizedStringResource, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, C.Element : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable {
        stubView()
    }
}

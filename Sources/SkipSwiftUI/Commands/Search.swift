// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

public struct SearchFieldPlacement : Sendable {
    public static let automatic = SearchFieldPlacement()

    @available(*, unavailable)
    public static let toolbar = SearchFieldPlacement()

    @available(*, unavailable)
    public static let sidebar = SearchFieldPlacement()
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
    public static var automatic: SearchScopeActivation {
        return  SearchScopeActivation()
    }

    @available(*, unavailable)
    public static var onTextEntry: SearchScopeActivation {
        fatalError()
    }

    @available(*, unavailable)
    public static var onSearchPresentation: SearchScopeActivation {
        fatalError()
    }
}

public struct SearchSuggestionsPlacement : Equatable, Sendable {
    public static var automatic: SearchSuggestionsPlacement {
        return SearchSuggestionsPlacement()
    }

    @available(*, unavailable)
    public static var menu: SearchSuggestionsPlacement {
        fatalError()
    }

    @available(*, unavailable)
    public static var content: SearchSuggestionsPlacement {
        fatalError()
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
    @available(*, unavailable)
    @MainActor @preconcurrency public struct Label : View {
        public typealias Body = Never
    }

    @available(*, unavailable)
    @MainActor @preconcurrency public struct Description : View {
        public typealias Body = Never
    }

    @available(*, unavailable)
    @MainActor @preconcurrency public struct Actions : View {
        public typealias Body = Never
    }
}

extension View {
    nonisolated public func searchable(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.searchable(getText: text.get, setText: text.set, prompt: prompt?.Java_view as? SkipUI.Text)
        }
    }

    nonisolated public func searchable(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey) -> some View {
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
    @_disfavoredOverload nonisolated public func searchable<S>(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: S) -> some View where S : StringProtocol {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: Text? = nil, @ViewBuilder suggestions: () -> S) -> some View where S : View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder suggestions: () -> S) -> some View where S : View {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func searchable<V, S>(text: Binding<String>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder suggestions: () -> V) -> some View where V : View, S : StringProtocol {
        stubView()
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
    nonisolated public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable {
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
    nonisolated public func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: LocalizedStringKey, @ViewBuilder token: @escaping (Binding<C.Element>) -> some View) -> some View where C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable {
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
    @_disfavoredOverload nonisolated public func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement = .automatic, prompt: S, @ViewBuilder token: @escaping (C.Element) -> T) -> some View where C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, T : View, S : StringProtocol, C.Element : Identifiable {
        stubView()
    }
}

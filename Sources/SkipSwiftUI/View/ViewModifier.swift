// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

//~~~ TODO: Support custom view modifiers
/* @MainActor @preconcurrency */ public protocol ViewModifier {
    associatedtype Body : View

    @ViewBuilder @MainActor /* @preconcurrency */ func body(content: Self.Content) -> Self.Body

    associatedtype Content : View
}

extension ViewModifier where Self.Body == Never {
    @MainActor /* @preconcurrency */ public func body(content: Self.Content) -> Self.Body {
        fatalError()
    }
}

extension ViewModifier {
    @available(*, unavailable)
    @inlinable /* nonisolated */ public func concat<T>(_ modifier: T) -> Any /* ModifiedContent<Self, T> */ {
        fatalError()
    }
}

extension ViewModifier {
    @available(*, unavailable)
    /* @inlinable nonisolated */ public func transaction(_ transform: @escaping (inout Transaction) -> Void) -> some ViewModifier {
        stubViewModifier()
    }

    @available(*, unavailable)
    @MainActor /* @inlinable @preconcurrency */ public func animation(_ animation: Animation?) -> some ViewModifier {
        stubViewModifier()
    }
}

func stubViewModifier() -> EmptyModifier {
    return EmptyModifier()
}

extension Never : ViewModifier {
    public typealias Content = Never
}

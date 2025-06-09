// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

@MainActor @preconcurrency public protocol ViewModifier {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func body(content: Self.Content) -> Self.Body

    typealias Content = JavaBackedView

    nonisolated var Java_modifier: any SkipUI.ViewModifier { get }
}

extension ViewModifier {
    nonisolated public var Java_modifier: any SkipUI.ViewModifier {
        return SkipUI.EmptyModifier()
    }
}

extension ViewModifier where Self.Body == Never {
    @MainActor @preconcurrency public func body(content: Self.Content) -> Self.Body {
        fatalError()
    }
}

extension ViewModifier {
    @available(*, unavailable)
    @inlinable nonisolated public func concat<T>(_ modifier: T) -> Any /* ModifiedContent<Self, T> */ {
        fatalError()
    }
}

extension ViewModifier {
    @available(*, unavailable)
    /* @inlinable */ nonisolated public func transaction(_ transform: @escaping (inout Transaction) -> Void) -> some ViewModifier {
        stubViewModifier()
    }

    @available(*, unavailable)
    @MainActor /* @inlinable */ @preconcurrency public func animation(_ animation: Animation?) -> some ViewModifier {
        stubViewModifier()
    }
}

func stubViewModifier() -> EmptyModifier {
    return EmptyModifier()
}

extension Never : ViewModifier {
    public typealias Content = Never
}

extension View {
    /* @inlinable */ nonisolated public func modifier<T>(_ modifier: T) -> some View /* ModifiedContent<Self, T> */ where T : ViewModifier {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.modifier(modifier.Java_modifier)
        }
    }
}

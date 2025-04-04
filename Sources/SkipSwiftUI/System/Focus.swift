// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

public struct FocusInteractions : OptionSet /*, Sendable */ {
    public static let activate = FocusInteractions(rawValue: 1 << 0) // For bridging
    public static let edit = FocusInteractions(rawValue: 1 << 1) // For bridging
    public static var automatic = FocusInteractions(rawValue: 1 << 2) // For bridging

    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct DefaultFocusEvaluationPriority /* : Sendable */ {
    public static let automatic = DefaultFocusEvaluationPriority()

    public static let userInitiated = DefaultFocusEvaluationPriority()
}

extension View {
    @available(*, unavailable)
    /* nonisolated */ public func defaultFocus<V>(_ binding: FocusState<V>.Binding, _ value: V, priority: DefaultFocusEvaluationPriority = .automatic) -> some View where V : Hashable {
        stubView()
    }
}

extension View {
    /* nonisolated */ public func focused<Value>(_ binding: FocusState<Value>.Binding, equals value: Value) -> some View where Value : Hashable {
        // The SwiftUI.focused modifier we bridge to will force-set `nil`, so we must be careful to use `nil` as-is rather
        // than wrapping it in `SwiftHashable`
        let getValue: () -> Any? = {
            let value = binding.wrappedValue as Any?
            if let value {
                return Java_swiftHashable(for: value as! AnyHashable)
            } else {
                return nil
            }
        }
        let setValue: (Any?) -> Void = {
            binding.wrappedValue = ($0 as? SwiftHashable)?.base as! Value
        }
        let value = value as Any?
        let javaValue: Any?
        if let value {
            javaValue = Java_swiftHashable(for: value as! AnyHashable)
        } else {
            javaValue = nil
        }
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.focusedHashable(getValue: getValue, setValue: setValue, equals: javaValue)
        }
    }

    /* nonisolated */ public func focused(_ binding: FocusState<Bool>.Binding, equals value: Bool) -> some View {
        return ModifierView(target: self) {
            // Special case for `Bool` rather than a `nil`-able value
            $0.Java_viewOrEmpty.focusedBool(getValue: { binding.wrappedValue }, setValue: { binding.wrappedValue = $0 }, equals: value)
        }
    }

    /* nonisolated */ public func focused(_ condition: FocusState<Bool>.Binding) -> some View {
        return focused(condition, equals: true)
    }
}

extension View {
    @available(*, unavailable)
    /* nonisolated */ public func focusable(_ isFocusable: Bool = true) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func focusable(_ isFocusable: Bool = true, interactions: FocusInteractions) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func focusEffectDisabled(_ disabled: Bool = true) -> some View {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    /* nonisolated */ public func focusedValue<T>(_ object: T?) -> some View where T : AnyObject, T : Observable {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func focusedSceneValue<T>(_ object: T?) -> some View where T : AnyObject, T : Observable {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    /* nonisolated */ public func focusedValue<Value>(_ keyPath: WritableKeyPath<FocusedValues, Value?>, _ value: Value) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func focusedValue<Value>(_ keyPath: WritableKeyPath<FocusedValues, Value?>, _ value: Value?) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func focusedSceneValue<T>(_ keyPath: WritableKeyPath<FocusedValues, T?>, _ value: T) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func focusedSceneValue<T>(_ keyPath: WritableKeyPath<FocusedValues, T?>, _ value: T?) -> some View {
        stubView()
    }
}

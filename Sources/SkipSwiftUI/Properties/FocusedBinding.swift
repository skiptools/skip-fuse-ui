// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@available(*, unavailable)
@propertyWrapper public struct FocusedBinding<Value> : DynamicProperty {
    public init(_ keyPath: KeyPath<FocusedValues, Binding<Value>?>) {
    }

    @inlinable public var wrappedValue: Value? {
        get {
            fatalError()
        }
        nonmutating set {
            fatalError()
        }
    }

    public var projectedValue: Binding<Value?> {
        fatalError()
    }
}

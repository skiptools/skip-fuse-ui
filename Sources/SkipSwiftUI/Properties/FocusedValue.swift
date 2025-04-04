// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@available(*, unavailable)
@propertyWrapper public struct FocusedValue<Value> : DynamicProperty {
    public init(_ keyPath: KeyPath<FocusedValues, Value?>) {
    }

    @inlinable public var wrappedValue: Value? {
        fatalError()
    }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init(_ objectType: Value.Type) where Value : AnyObject, Value : Observable {
    }
}

public protocol FocusedValueKey {
    associatedtype Value
}

@available(*, unavailable)
public struct FocusedValues : Equatable {
    public subscript<Key>(key: Key.Type) -> Key.Value? where Key : FocusedValueKey {
        fatalError()
    }

    public static func == (lhs: FocusedValues, rhs: FocusedValues) -> Bool {
        fatalError()
    }
}

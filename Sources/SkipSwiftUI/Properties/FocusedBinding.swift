// Copyright 2025–2026 Skip

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

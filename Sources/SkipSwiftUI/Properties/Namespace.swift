// Copyright 2025–2026 Skip

@frozen @propertyWrapper public struct Namespace : DynamicProperty, BitwiseCopyable, Sendable {
    @available(*, unavailable)
    @inlinable public init() {
    }

    public var wrappedValue: Namespace.ID {
        fatalError()
    }

    @frozen public struct ID : Hashable, BitwiseCopyable, Sendable {
    }
}

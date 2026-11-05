// Copyright 2025–2026 Skip

@available(*, unavailable)
@MainActor @frozen @propertyWrapper @preconcurrency public struct FocusedObject<ObjectType> : DynamicProperty /* where ObjectType : ObservableObject */ {
    @MainActor @preconcurrency @dynamicMemberLookup @frozen public struct Wrapper {
        @MainActor @preconcurrency public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, T>) -> Binding<T> {
            fatalError()
        }
    }

    @MainActor @inlinable @preconcurrency public var wrappedValue: ObjectType? {
        fatalError()
    }

    @MainActor @preconcurrency public var projectedValue: FocusedObject<ObjectType>.Wrapper? {
        fatalError()
    }

    @MainActor @preconcurrency public init() {
    }
}

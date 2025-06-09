// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

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

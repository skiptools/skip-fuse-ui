// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Observation

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@dynamicMemberLookup @propertyWrapper public struct Bindable<Value> {
    public var wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public var projectedValue: Bindable<Value> {
        return self
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Bindable where Value : AnyObject {
    public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>) -> Binding<Subject> {
        return Binding<Subject>(get: { wrappedValue[keyPath: keyPath] }, set: { wrappedValue[keyPath: keyPath] = $0 })
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Bindable where Value : AnyObject, Value : Observable {
    public init(_ wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public init(projectedValue: Bindable<Value>) {
        self = projectedValue
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Bindable : Identifiable where Value : Identifiable {
    public var id: Value.ID {
        return wrappedValue.id
    }

    public typealias ID = Value.ID
}

//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//extension Bindable : Sendable where Value : Sendable {
//}

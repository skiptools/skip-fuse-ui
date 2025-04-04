// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@frozen @propertyWrapper public struct FocusState<Value> : DynamicProperty where Value : Hashable {
    @frozen @propertyWrapper public struct Binding {
        private let get: () -> Value
        private let set: (Value) -> Void

        fileprivate init(valueBox: BridgedStateBox<Value>?, get: @escaping () -> Value, set: @escaping (Value) -> Void) {
            self.valueBox = valueBox
            self.get = get
            self.set = set
        }

        /// The bound `@FocusState's` bridged value box.
        ///
        /// This is exposed to generated code here rather than on the `FocusState` because the property wrapper itself is considered
        /// private, but its projection is accessible to callers.
        public let valueBox: BridgedStateBox<Value>?

        public var wrappedValue: Value {
            get {
                get()
            }
            nonmutating set {
                set(newValue)
            }
        }

        public var projectedValue: Binding {
            return self
        }
    }

    private let valueBox: BridgedStateBox<Value>

    public var wrappedValue: Value {
        get {
            return valueBox.value
        }
        nonmutating set {
            valueBox.value = newValue
        }
    }

    public var projectedValue: FocusState<Value>.Binding {
        return Binding(valueBox: valueBox, get: { wrappedValue }, set: { wrappedValue = $0 })
    }

    public init() where Value == Bool {
        self.valueBox = BridgedStateBox(false, comparator: { $0 == $1 })
    }

    public init<T>() where Value == T?, T : Hashable {
        self.valueBox = BridgedStateBox(nil, comparator: { $0 == $1 })
    }
}

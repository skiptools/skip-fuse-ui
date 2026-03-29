// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

@propertyWrapper @frozen public struct GestureState<Value> : DynamicProperty {
    private let _valueBox: BridgedStateBox<Value>

    public init(wrappedValue value: Value) where Value : Equatable {
        self.init(wrappedValue: value, resetTransaction: Transaction())
    }

    public init(wrappedValue value: Value) {
        self.init(wrappedValue: value, resetTransaction: Transaction())
    }

    private init(wrappedValue value: Value, transaction: Transaction, reset: @escaping (BridgedStateBox<Value>, Value, Transaction) -> Void) where Value : Equatable {
        let valueBox = BridgedStateBox(value, comparator: { $0 == $1 })
        self._valueBox = valueBox
        self.reset = { reset(valueBox, value, transaction) }
    }

    private init(wrappedValue value: Value, transaction: Transaction, reset: @escaping (BridgedStateBox<Value>, Value, Transaction) -> Void) {
        let comparator: (Value, Value) -> Bool
        if Value.self is AnyObject.Type {
            comparator = { ($0 as AnyObject) === ($1 as AnyObject) }
        } else {
            comparator = { _, _ in false }
        }
        let valueBox = BridgedStateBox(value, comparator: comparator)
        self._valueBox = valueBox
        self.reset = { reset(valueBox, value, transaction) }
    }

    public init(initialValue value: Value) where Value : Equatable {
        self.init(initialValue: value, resetTransaction: Transaction())
    }

    public init(initialValue value: Value) {
        self.init(initialValue: value, resetTransaction: Transaction())
    }

    public init(wrappedValue value: Value, resetTransaction: Transaction) where Value : Equatable {
        self.init(wrappedValue: value, transaction: resetTransaction, reset: { box, value, transaction in
            withAnimation(transaction.animation) { box.value = value }
        })
    }

    public init(wrappedValue value: Value, resetTransaction: Transaction) {
        self.init(wrappedValue: value, transaction: resetTransaction, reset: { box, value, transaction in
            withAnimation(transaction.animation) { box.value = value }
        })
    }

    public init(initialValue value: Value, resetTransaction: Transaction) where Value : Equatable {
        self.init(wrappedValue: value, resetTransaction: resetTransaction)
    }

    public init(initialValue value: Value, resetTransaction: Transaction) {
        self.init(wrappedValue: value, resetTransaction: resetTransaction)
    }

    public init(wrappedValue: Value, reset: @escaping (Value, inout Transaction) -> Void) where Value : Equatable {
        self.init(wrappedValue: wrappedValue, transaction: Transaction(), reset: { box, value, transaction in
            var transaction = transaction
            reset(value, &transaction)
            withAnimation(transaction.animation) { box.value = value }
        })
    }

    public init(wrappedValue: Value, reset: @escaping (Value, inout Transaction) -> Void) {
        self.init(wrappedValue: wrappedValue, transaction: Transaction(), reset: { box, value, transaction in
            var transaction = transaction
            reset(value, &transaction)
            withAnimation(transaction.animation) { box.value = value }
        })
    }

    public init(initialValue: Value, reset: @escaping (Value, inout Transaction) -> Void) where Value : Equatable {
        self.init(wrappedValue: initialValue, reset: reset)
    }

    public init(initialValue: Value, reset: @escaping (Value, inout Transaction) -> Void) {
        self.init(wrappedValue: initialValue, reset: reset)
    }

    public var wrappedValue: Value {
        get {
            return _valueBox.value
        }
        nonmutating set {
            _valueBox.value = newValue
        }
    }

    public var projectedValue: GestureState<Value> {
        return self
    }

    /// Reset state to initial value.
    let reset: () -> Void

    /// Internal value box for syncing with Compose.
    ///
    /// This is optional so that we can treat it consistently with `Binding.valueBox` in generated code.
    public var valueBox: BridgedStateBox<Value>? {
        return _valueBox
    }
}

//extension GestureState : Sendable where Value : Sendable {
//}

extension GestureState where Value : ExpressibleByNilLiteral {
    public init(resetTransaction: Transaction = Transaction()) where Value : Equatable {
        self.init(wrappedValue: nil)
    }

    public init(resetTransaction: Transaction = Transaction()) {
        self.init(wrappedValue: nil)
    }

    public init(reset: @escaping (Value, inout Transaction) -> Void) where Value : Equatable {
        self.init(wrappedValue: nil, reset: reset)
    }

    public init(reset: @escaping (Value, inout Transaction) -> Void) {
        self.init(wrappedValue: nil, reset: reset)
    }
}

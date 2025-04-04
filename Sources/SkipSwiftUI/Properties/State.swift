// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge

@frozen @propertyWrapper public struct State<Value> : DynamicProperty {
    private let valueBox: BridgedStateBox<Value>

    public init(wrappedValue value: Value) where Value : Equatable {
        self.valueBox = BridgedStateBox(value, comparator: { $0 == $1 })
    }

    public init(wrappedValue value: Value) {
        let comparator: (Value, Value) -> Bool
        if Value.self is AnyObject.Type {
            comparator = { ($0 as AnyObject) === ($1 as AnyObject) }
        } else {
            comparator = { _, _ in false }
        }
        self.valueBox = BridgedStateBox(value, comparator: comparator)
    }

    public init(initialValue value: Value) where Value : Equatable {
        self.init(wrappedValue: value)
    }

    public init(initialValue value: Value) {
        self.init(wrappedValue: value)
    }

    public var wrappedValue: Value {
        get {
            return valueBox.value
        }
        nonmutating set {
            valueBox.value = newValue
        }
    }

    public var projectedValue: Binding<Value> {
        return Binding(valueBox: valueBox, get: { wrappedValue }, set: { wrappedValue = $0 })
    }
}

//extension State : Sendable where Value : Sendable {
//}

extension State where Value : ExpressibleByNilLiteral {
    public init() {
        self.init(wrappedValue: nil)
    }
}

@_cdecl("Java_skip_ui_StateSupport_Swift_1release")
public func StateSupport_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_valueHolder: SwiftObjectPointer) -> SwiftObjectPointer {
    Swift_valueHolder.release(as: Box<Any>.self)
    return SwiftObjectNil
}

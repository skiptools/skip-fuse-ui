// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

/* @frozen */ @propertyWrapper public struct Environment<Value> : DynamicProperty {
    private let defaultValue: /* @Sendable */ () -> Value
    private let valueBox: Box<Box<Value>?> = Box(nil)

    /* @inlinable */ public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.key = EnvironmentValues.key(for: keyPath)
        self.defaultValue = { EnvironmentValues.shared[keyPath: keyPath] }
    }

    /* @inlinable */ public var wrappedValue: Value {
        return valueBox.value!.value
    }

    public var projectedValue: Self {
        return self
    }

    public let key: String

    public func Java_syncEnvironmentSupport(_ support: EnvironmentSupport?) {
        if let support {
            let valueHolder = support.valueHolder
            if valueHolder != SwiftObjectNil {
                valueBox.value = valueHolder.pointee()!
            } else {
                valueBox.value = Box(EnvironmentValues.builtin(key: key, bridgedValue: support.builtinValue) as! Value)
            }
        } else {
            valueBox.value = Box(defaultValue())
        }
    }
}

//extension Environment : Sendable where Value : Sendable {
//}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Environment {
    public init(_ objectType: Value.Type) where Value : AnyObject, Value : Observable {
        self.key = EnvironmentValues.key(for: objectType)
        self.defaultValue = { EnvironmentValues.shared[objectType]! }
    }

    public init<T>(_ objectType: T.Type) where Value == T?, T : AnyObject, T : Observable {
        self.key = EnvironmentValues.key(for: objectType)
        self.defaultValue = { EnvironmentValues.shared[objectType] }
    }
}

@_cdecl("Java_skip_ui_EnvironmentSupport_Swift_1release")
public func EnvironmentSupport_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_valueHolder: SwiftObjectPointer) -> SwiftObjectPointer {
    Swift_valueHolder.release(as: Box<Any>.self)
    return SwiftObjectNil
}

// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

public protocol PreferenceKey {
    associatedtype Value

    static var defaultValue: Self.Value { get }

    static func reduce(value: inout Self.Value, nextValue: () -> Self.Value)
}

extension PreferenceKey where Self.Value : ExpressibleByNilLiteral {
    public static var defaultValue: Self.Value {
        return nil
    }
}

extension View {
    /* @inlinable */ nonisolated public func preference<K>(key: K.Type = K.self, value: K.Value) -> some View where K : PreferenceKey {
        return ModifierView(target: self) {
            let javaKey = String(describing: key)
            let ptr = SwiftObjectPointer.pointer(to: Box(value), retain: true)
            let javaValue = EnvironmentSupport(valueHolder: ptr)
            return $0.Java_viewOrEmpty.preference(key: javaKey, value: javaValue)
        }
    }

    /* @inlinable */ nonisolated public func onPreferenceChange<K>(_ key: K.Type = K.self, perform action: @escaping (K.Value) -> Void) -> some View where K : PreferenceKey, K.Value : Equatable {
        return ModifierView(target: self) {
            // We have to bundle up native preference values in opaque, bridgable environment supports objects so that
            // the Compose runtime can manage their lifecycles. Then we un-bundle them when passing back to native code
            let javaKey = String(describing: key)
            let defaultValuePtr = SwiftObjectPointer.pointer(to: Box(key.defaultValue), retain: true)
            let javaDefaultValue = EnvironmentSupport(valueHolder: defaultValuePtr)
            let javaReducer: (Any?, Any?) -> Any? = { value, nextValue in
                let envValue = value as! EnvironmentSupport
                let envNextValue = nextValue as! EnvironmentSupport
                let boxValue: Box<K.Value> = envValue.valueHolder.pointee()!
                let boxNextValue: Box<K.Value> = envNextValue.valueHolder.pointee()!
                var swiftValue = boxValue.value
                let swiftNextValue = boxNextValue.value
                key.reduce(value: &swiftValue, nextValue: { swiftNextValue })
                let ptr = SwiftObjectPointer.pointer(to: Box(swiftValue), retain: true)
                return EnvironmentSupport(valueHolder: ptr)
            }
            let javaAction: (Any?) -> Void = { value in
                let envValue = value as! EnvironmentSupport
                let boxValue: Box<K.Value> = envValue.valueHolder.pointee()!
                let swiftValue = boxValue.value
                action(swiftValue)
            }
            return $0.Java_viewOrEmpty.onPreferenceChange(key: javaKey, defaultValue: javaDefaultValue, reducer: javaReducer, action: javaAction)
        }
    }
}

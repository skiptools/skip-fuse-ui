// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipUI

public final class BridgedAppStorageBox<Value> {
    private let create: () -> AppStorageSupport
    private let get: (AppStorageSupport) -> Value
    private let set: (AppStorageSupport, Value) -> Void

    init(_ value: Bool, key: String, store: UserDefaults?) where Value == Bool {
        self._value = value
        self.create = { AppStorageSupport(value, key: key, store: store) }
        self.get = { $0.boolValue }
        self.set = { $0.boolValue = $1 }
    }

    init(_ value: Double, key: String, store: UserDefaults?) where Value == Double {
        self._value = value
        self.create = { AppStorageSupport(value, key: key, store: store) }
        self.get = { $0.doubleValue }
        self.set = { $0.doubleValue = $1 }
    }

    init(_ value: Int, key: String, store: UserDefaults?) where Value == Int {
        self._value = value
        self.create = { AppStorageSupport(value, key: key, store: store) }
        self.get = { $0.intValue }
        self.set = { $0.intValue = $1 }
    }

    init(_ value: String, key: String, store: UserDefaults?) where Value == String {
        self._value = value
        self.create = { AppStorageSupport(value, key: key, store: store) }
        self.get = { $0.stringValue }
        self.set = { $0.stringValue = $1 }
    }

    init(_ value: URL, key: String, store: UserDefaults?) where Value == URL {
        self._value = value
        self.create = { AppStorageSupport(value, key: key, store: store) }
        self.get = { $0.urlValue }
        self.set = { $0.urlValue = $1 }
    }

    init(_ value: Data, key: String, store: UserDefaults?) where Value == Data {
        self._value = value
        self.create = { AppStorageSupport(value, key: key, store: store) }
        self.get = { $0.dataValue }
        self.set = { $0.dataValue = $1 }
    }

    init(_ value: Date, key: String, store: UserDefaults?) where Value == Date {
        self._value = value
        self.create = { AppStorageSupport(Double(value.timeIntervalSince1970), key: key, store: store) }
        self.get = { Date(timeIntervalSince1970: $0.doubleValue) }
        self.set = { $0.doubleValue = $1.timeIntervalSince1970 }
    }

    init(_ value: Value, key: String, store: UserDefaults?) where Value : RawRepresentable, Value.RawValue == Int {
        self._value = value
        self.create = { AppStorageSupport(value.rawValue, key: key, store: store) }
        self.get = { Value.init(rawValue: $0.intValue)! }
        self.set = { $0.intValue = $1.rawValue }
    }

    init(_ value: Value, key: String, store: UserDefaults?) where Value : RawRepresentable, Value.RawValue == String {
        self._value = value
        self.create = { AppStorageSupport(value.rawValue, key: key, store: store) }
        self.get = { Value.init(rawValue: $0.stringValue)! }
        self.set = { $0.stringValue = $1.rawValue }
    }

    var value: Value {
        get {
            if let Java_stateSupport {
                return get(Java_stateSupport)
            } else {
                return _value
            }
        }
        set {
            _value = newValue
            if let Java_stateSupport {
                set(Java_stateSupport, newValue)
            }
        }
    }
    private var _value: Value

    private var Java_stateSupport: AppStorageSupport?

    public func Java_initStateSupport() -> AppStorageSupport {
        Java_stateSupport = create()
        return Java_stateSupport!
    }

    public func Java_syncStateSupport(_ support: AppStorageSupport) {
        _value = get(support)
        Java_stateSupport = support
    }
}

//extension BridgedAppStorageBox : @unchecked Sendable where Value : Sendable {
//}

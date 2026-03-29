// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SkipUI

public final class BridgedAppStorageBox<Value> {
    private let create: () -> AppStorageSupport
    private let get: (AppStorageSupport) -> Value?
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
        self.get = {
            guard let doubleValue = $0.doubleValue else {
                return nil
            }
            return Date(timeIntervalSince1970: doubleValue)
        }
        self.set = { $0.doubleValue = $1.timeIntervalSince1970 }
    }

    init(_ value: Value, key: String, store: UserDefaults?) where Value : RawRepresentable, Value.RawValue == Int {
        self._value = value
        self.create = { AppStorageSupport(value.rawValue, key: key, store: store) }
        self.get = {
            guard let intValue = $0.intValue else {
                return nil
            }
            return Value.init(rawValue: intValue)
        }
        self.set = { $0.intValue = $1.rawValue }
    }

    init(_ value: Value, key: String, store: UserDefaults?) where Value : RawRepresentable, Value.RawValue == String {
        self._value = value
        self.create = { AppStorageSupport(value.rawValue, key: key, store: store) }
        self.get = {
            guard let stringValue = $0.stringValue else {
                return nil
            }
            return Value.init(rawValue: stringValue)
        }
        self.set = { $0.stringValue = $1.rawValue }
    }

    var value: Value {
        get {
            if let Java_stateSupport {
                return get(Java_stateSupport) ?? _value
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
        if let stateValue = get(support) {
            _value = stateValue
        }
        Java_stateSupport = support
    }
}

//extension BridgedAppStorageBox : @unchecked Sendable where Value : Sendable {
//}

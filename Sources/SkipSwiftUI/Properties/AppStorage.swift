// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation

@frozen @propertyWrapper public struct AppStorage<Value> : DynamicProperty {
    private let valueBox: BridgedAppStorageBox<Value>

    public var wrappedValue: Value {
        get {
            return valueBox.value
        }
        nonmutating set {
            valueBox.value = newValue
        }
    }

    public var projectedValue: Binding<Value> {
        return Binding(appStorageBox: valueBox, get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
    }
}

extension AppStorage {
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Bool {
        self.valueBox = BridgedAppStorageBox(wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Int {
        self.valueBox = BridgedAppStorageBox(wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Double {
        self.valueBox = BridgedAppStorageBox(wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == String {
        self.valueBox = BridgedAppStorageBox(wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == URL {
        self.valueBox = BridgedAppStorageBox(wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Date {
        self.valueBox = BridgedAppStorageBox(wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Data {
        self.valueBox = BridgedAppStorageBox(wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == Int {
        self.valueBox = BridgedAppStorageBox(wrappedValue, key: key, store: store)
    }

    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == String {
        self.valueBox = BridgedAppStorageBox(wrappedValue, key: key, store: store)
    }
}

// We can't track changes to nil values on the Compose side, so we don't support nils yet

//extension AppStorage where Value : ExpressibleByNilLiteral {
//    public init(_ key: String, store: UserDefaults? = nil) where Value == Bool?
//
//    public init(_ key: String, store: UserDefaults? = nil) where Value == Int?
//
//    public init(_ key: String, store: UserDefaults? = nil) where Value == Double?
//
//    public init(_ key: String, store: UserDefaults? = nil) where Value == String?
//
//    public init(_ key: String, store: UserDefaults? = nil) where Value == URL?
//
//    public init(_ key: String, store: UserDefaults? = nil) where Value == Date?
//
//    public init(_ key: String, store: UserDefaults? = nil) where Value == Data?
//}
//
//extension AppStorage {
//    public init<R>(_ key: String, store: UserDefaults? = nil) where Value == R?, R : RawRepresentable, R.RawValue == String
//
//    public init<R>(_ key: String, store: UserDefaults? = nil) where Value == R?, R : RawRepresentable, R.RawValue == Int
//}

//extension AppStorage : Sendable where Value : Sendable {
//}

//extension AppStorage {
//    public init<RowValue>(wrappedValue: Value = TableColumnCustomization<RowValue>(), _ key: String, store: UserDefaults? = nil) where Value == TableColumnCustomization<RowValue>, RowValue : Identifiable
//}

//extension AppStorage {
//    public init(wrappedValue: Value = ToolbarLabelStyle.automatic, _ key: String, store: UserDefaults? = nil) where Value == ToolbarLabelStyle
//}
//
//extension AppStorage {
//    public init(wrappedValue: Value = TabViewCustomization(), _ key: String, store: UserDefaults? = nil) where Value == TabViewCustomization
//}

extension View {
    @available(*, unavailable)
    /* nonisolated */ public func defaultAppStorage(_ store: UserDefaults) -> some View {
        stubView()
    }
}

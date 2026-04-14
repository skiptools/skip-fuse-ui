// Copyright 2025-2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

@frozen @propertyWrapper public struct ScaledMetric<Value> : DynamicProperty where Value : BinaryFloatingPoint {
    private let value: Value

    public init(wrappedValue value: Value) {
        self.value = value
    }

    public init(wrappedValue value: Value, relativeTo textStyle: Font.TextStyle) {
        _ = textStyle
        self.value = value
    }

    public var wrappedValue: Value {
        #if os(Android)
        let scaled = SkipUI.ScaledMetricBridge.scaledValue(for: Double(value))
        return Value(scaled)
        #else
        return value
        #endif
    }
}

// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipFuse
import SkipUI

public struct Stepper<Label> where Label : View {
    private let value: Binding<Double>?
    private let step: Double
    private let minValue: Double?
    private let maxValue: Double?
    private let onIncrement: (() -> Void)?
    private let onDecrement: (() -> Void)?
    private let onEditingChanged: ((Bool) -> Void)?
    private let label: Label
}

extension Stepper : View {
    public typealias Body = Never
}

extension Stepper : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        if onIncrement != nil || onDecrement != nil {
            return SkipUI.Stepper(bridgedOnIncrement: onIncrement, bridgedOnDecrement: onDecrement, bridgedOnEditingChanged: onEditingChanged, bridgedLabel: label.Java_viewOrEmpty)
        } else {
            return SkipUI.Stepper(getValue: { value?.wrappedValue ?? 0.0 }, setValue: { value?.wrappedValue = $0 }, step: step, minValue: minValue, maxValue: maxValue, bridgedOnEditingChanged: onEditingChanged, bridgedLabel: label.Java_viewOrEmpty)
        }
    }
}

// MARK: - Custom increment/decrement initializers

extension Stepper {
    public init(@ViewBuilder label: () -> Label, onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = nil
        self.step = 1.0
        self.minValue = nil
        self.maxValue = nil
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
        self.onEditingChanged = onEditingChanged
        self.label = label()
    }
}

extension Stepper where Label == Text {
    public init(_ titleKey: LocalizedStringKey, onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(label: { Text(titleKey) }, onIncrement: onIncrement, onDecrement: onDecrement, onEditingChanged: onEditingChanged)
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(label: { Text(titleResource) }, onIncrement: onIncrement, onDecrement: onDecrement, onEditingChanged: onEditingChanged)
    }

    @_disfavoredOverload public init<S>(_ title: S, onIncrement: (() -> Void)?, onDecrement: (() -> Void)?, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where S : StringProtocol {
        self.init(label: { Text(title) }, onIncrement: onIncrement, onDecrement: onDecrement, onEditingChanged: onEditingChanged)
    }
}

// MARK: - Value binding initializers (no bounds)

extension Stepper {
    public init(value: Binding<Int>, step: Int = 1, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = Binding(get: { Double(value.wrappedValue) }, set: { value.wrappedValue = Int($0) })
        self.step = Double(step)
        self.minValue = nil
        self.maxValue = nil
        self.onIncrement = nil
        self.onDecrement = nil
        self.onEditingChanged = onEditingChanged
        self.label = label()
    }

    public init(value: Binding<Double>, step: Double = 1.0, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = value
        self.step = step
        self.minValue = nil
        self.maxValue = nil
        self.onIncrement = nil
        self.onDecrement = nil
        self.onEditingChanged = onEditingChanged
        self.label = label()
    }
}

extension Stepper where Label == Text {
    // Int value initializers (no bounds)
    public init(_ titleKey: LocalizedStringKey, value: Binding<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(titleKey) }, onEditingChanged: onEditingChanged)
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, value: Binding<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(titleResource) }, onEditingChanged: onEditingChanged)
    }

    @_disfavoredOverload public init<S>(_ title: S, value: Binding<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where S : StringProtocol {
        self.init(value: value, step: step, label: { Text(title) }, onEditingChanged: onEditingChanged)
    }

    // Double value initializers (no bounds)
    public init(_ titleKey: LocalizedStringKey, value: Binding<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(titleKey) }, onEditingChanged: onEditingChanged)
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, value: Binding<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, step: step, label: { Text(titleResource) }, onEditingChanged: onEditingChanged)
    }

    @_disfavoredOverload public init<S>(_ title: S, value: Binding<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where S : StringProtocol {
        self.init(value: value, step: step, label: { Text(title) }, onEditingChanged: onEditingChanged)
    }
}

// MARK: - Value binding initializers (with bounds)

extension Stepper {
    public init(value: Binding<Int>, in bounds: ClosedRange<Int>, step: Int = 1, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = Binding(get: { Double(value.wrappedValue) }, set: { value.wrappedValue = Int($0) })
        self.step = Double(step)
        self.minValue = Double(bounds.lowerBound)
        self.maxValue = Double(bounds.upperBound)
        self.onIncrement = nil
        self.onDecrement = nil
        self.onEditingChanged = onEditingChanged
        self.label = label()
    }

    public init(value: Binding<Double>, in bounds: ClosedRange<Double>, step: Double = 1.0, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = value
        self.step = step
        self.minValue = bounds.lowerBound
        self.maxValue = bounds.upperBound
        self.onIncrement = nil
        self.onDecrement = nil
        self.onEditingChanged = onEditingChanged
        self.label = label()
    }
}

extension Stepper where Label == Text {
    // Int value initializers (with bounds)
    public init(_ titleKey: LocalizedStringKey, value: Binding<Int>, in bounds: ClosedRange<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, in: bounds, step: step, label: { Text(titleKey) }, onEditingChanged: onEditingChanged)
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, value: Binding<Int>, in bounds: ClosedRange<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, in: bounds, step: step, label: { Text(titleResource) }, onEditingChanged: onEditingChanged)
    }

    @_disfavoredOverload public init<S>(_ title: S, value: Binding<Int>, in bounds: ClosedRange<Int>, step: Int = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where S : StringProtocol {
        self.init(value: value, in: bounds, step: step, label: { Text(title) }, onEditingChanged: onEditingChanged)
    }

    // Double value initializers (with bounds)
    public init(_ titleKey: LocalizedStringKey, value: Binding<Double>, in bounds: ClosedRange<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, in: bounds, step: step, label: { Text(titleKey) }, onEditingChanged: onEditingChanged)
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, value: Binding<Double>, in bounds: ClosedRange<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.init(value: value, in: bounds, step: step, label: { Text(titleResource) }, onEditingChanged: onEditingChanged)
    }

    @_disfavoredOverload public init<S>(_ title: S, value: Binding<Double>, in bounds: ClosedRange<Double>, step: Double = 1.0, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where S : StringProtocol {
        self.init(value: value, in: bounds, step: step, label: { Text(title) }, onEditingChanged: onEditingChanged)
    }
}

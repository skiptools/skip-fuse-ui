// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

public struct Slider<Label, ValueLabel> where Label : View, ValueLabel : View {
    private let value: Binding<Double>
    private let min: Double
    private let max: Double
    private let step: Double?
    private let onEditingChanged: ((Bool) -> Void)?
    private let label: Label?
}

extension Slider : View {
    public typealias Body = Never
}

extension Slider : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Slider(getValue: { value.wrappedValue }, setValue: { value.wrappedValue = $0 }, min: min, max: max, step: step, bridgedOnEditingChanged: onEditingChanged, bridgedLabel: label?.Java_viewOrEmpty)
    }
}

extension Slider {
    @available(*, unavailable)
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        fatalError()
    }

    @available(*, unavailable)
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        fatalError()
    }
}

extension Slider where ValueLabel == EmptyView {
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        self.value = Binding(get: { Double(value.wrappedValue) }, set: { value.wrappedValue = V($0) })
        self.min = Double(bounds.lowerBound)
        self.max = Double(bounds.upperBound)
        self.step = nil
        self.onEditingChanged = onEditingChanged
        self.label = label()
    }

    public init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        self.value = Binding(get: { Double(value.wrappedValue) }, set: { value.wrappedValue = V($0) })
        self.min = Double(bounds.lowerBound)
        self.max = Double(bounds.upperBound)
        self.step = nil
        self.onEditingChanged = nil
        self.label = label()
    }

    public init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        self.value = Binding(get: { Double(value.wrappedValue) }, set: { value.wrappedValue = V($0) })
        self.min = Double(bounds.lowerBound)
        self.max = Double(bounds.upperBound)
        self.step = Double(step)
        self.onEditingChanged = onEditingChanged
        self.label = label()
    }

    public init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, @ViewBuilder label: () -> Label) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        self.value = Binding(get: { Double(value.wrappedValue) }, set: { value.wrappedValue = V($0) })
        self.min = Double(bounds.lowerBound)
        self.max = Double(bounds.upperBound)
        self.step = Double(step)
        self.onEditingChanged = nil
        self.label = label()
    }
}

extension Slider where Label == EmptyView, ValueLabel == EmptyView {
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, onEditingChanged: @escaping (Bool) -> Void) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        self.value = Binding(get: { Double(value.wrappedValue) }, set: { value.wrappedValue = V($0) })
        self.min = Double(bounds.lowerBound)
        self.max = Double(bounds.upperBound)
        self.step = nil
        self.onEditingChanged = onEditingChanged
        self.label = nil
    }

    public init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        self.value = Binding(get: { Double(value.wrappedValue) }, set: { value.wrappedValue = V($0) })
        self.min = Double(bounds.lowerBound)
        self.max = Double(bounds.upperBound)
        self.step = nil
        self.onEditingChanged = nil
        self.label = nil
    }

    public init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, onEditingChanged: @escaping (Bool) -> Void) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        self.value = Binding(get: { Double(value.wrappedValue) }, set: { value.wrappedValue = V($0) })
        self.min = Double(bounds.lowerBound)
        self.max = Double(bounds.upperBound)
        self.step = Double(step)
        self.onEditingChanged = onEditingChanged
        self.label = nil
    }

    public init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        self.value = Binding(get: { Double(value.wrappedValue) }, set: { value.wrappedValue = V($0) })
        self.min = Double(bounds.lowerBound)
        self.max = Double(bounds.upperBound)
        self.step = Double(step)
        self.onEditingChanged = nil
        self.label = nil
    }
}

extension Slider {
    @available(*, unavailable)
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in }, minimumValueLabel: ValueLabel, maximumValueLabel: ValueLabel, @ViewBuilder label: () -> Label) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        fatalError()
    }

    @available(*, unavailable)
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }, minimumValueLabel: ValueLabel, maximumValueLabel: ValueLabel, @ViewBuilder label: () -> Label) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        fatalError()
    }
}

extension Slider where ValueLabel == EmptyView {
    @available(*, unavailable)
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in }, @ViewBuilder label: () -> Label) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        fatalError()
    }

    @available(*, unavailable)
    public init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }, @ViewBuilder label: () -> Label) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        fatalError()
    }
}

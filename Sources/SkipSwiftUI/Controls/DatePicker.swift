// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipFuse
import SkipUI

public struct DatePicker<Label> where Label : View {
    private let selection: Binding<Date>
    private let displayedComponents: DatePicker<Label>.Components
    private let label: Label
    private let minDate: Date?
    private let maxDate: Date?

    public typealias Components = DatePickerComponents
}

extension DatePicker : View {
    public typealias Body = Never
}

extension DatePicker : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        if minDate != nil || maxDate != nil {
            let min = minDate ?? Date.distantPast
            let max = maxDate ?? Date.distantFuture
            return SkipUI.DatePicker(getSelection: { selection.wrappedValue }, setSelection: { selection.wrappedValue = $0 }, bridgedMinDate: min, bridgedMaxDate: max, bridgedDisplayedComponents: Int(displayedComponents.rawValue), bridgedLabel: label.Java_viewOrEmpty)
        } else {
            return SkipUI.DatePicker(getSelection: { selection.wrappedValue }, setSelection: { selection.wrappedValue = $0 }, bridgedDisplayedComponents: Int(displayedComponents.rawValue), bridgedLabel: label.Java_viewOrEmpty)
        }
    }
}

extension DatePicker {
    public init(selection: Binding<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) {
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.label = label()
        self.minDate = nil
        self.maxDate = nil
    }

    public init(selection: Binding<Date>, in range: ClosedRange<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) {
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.label = label()
        self.minDate = range.lowerBound
        self.maxDate = range.upperBound
    }

    @available(*, unavailable)
    public init(selection: Binding<Date>, in range: Range<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) {
        fatalError()
    }

    @available(*, unavailable)
    public init(selection: Binding<Date>, in range: PartialRangeFrom<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) {
        fatalError()
    }

    @available(*, unavailable)
    public init(selection: Binding<Date>, in range: PartialRangeThrough<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) {
        fatalError()
    }
}

extension DatePicker where Label == Text {
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.label = Text(titleKey)
        self.minDate = nil
        self.maxDate = nil
    }

    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, in range: ClosedRange<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.label = Text(titleKey)
        self.minDate = range.lowerBound
        self.maxDate = range.upperBound
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, in range: Range<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        fatalError()
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, in range: PartialRangeFrom<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        fatalError()
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, in range: PartialRangeThrough<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        fatalError()
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, selection: Binding<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.label = Text(titleResource)
        self.minDate = nil
        self.maxDate = nil
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, selection: Binding<Date>, in range: ClosedRange<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.label = Text(titleResource)
        self.minDate = range.lowerBound
        self.maxDate = range.upperBound
    }

    @available(*, unavailable)
    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, selection: Binding<Date>, in range: Range<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, selection: Binding<Date>, in range: PartialRangeFrom<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, selection: Binding<Date>, in range: PartialRangeThrough<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        fatalError()
    }

    @_disfavoredOverload public init<S>(_ title: S, selection: Binding<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol {
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.label = Text(title)
        self.minDate = nil
        self.maxDate = nil
    }

    @_disfavoredOverload public init<S>(_ title: S, selection: Binding<Date>, in range: ClosedRange<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol {
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.label = Text(title)
        self.minDate = range.lowerBound
        self.maxDate = range.upperBound
    }

    @available(*, unavailable)
    @_disfavoredOverload public init<S>(_ title: S, selection: Binding<Date>, in range: Range<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init<S>(_ title: S, selection: Binding<Date>, in range: PartialRangeFrom<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init<S>(_ title: S, selection: Binding<Date>, in range: PartialRangeThrough<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol {
        fatalError()
    }
}

public struct DatePickerComponents : OptionSet, Sendable {
    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static let hourAndMinute =  DatePickerComponents(rawValue: 1 << 0) // For bridging
    public static let date = DatePickerComponents(rawValue: 1 << 1) // For bridging
}

@MainActor @preconcurrency public protocol DatePickerStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = DatePickerStyleConfiguration

    nonisolated var identifier: Int { get } // For bridging
}

extension DatePickerStyle {
    nonisolated public var identifier: Int {
        return -1
    }
}

public struct WheelDatePickerStyle : DatePickerStyle {
    @available(*, unavailable)
    public init() {
        fatalError()
    }

    @MainActor @preconcurrency public func makeBody(configuration: WheelDatePickerStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 2 // For bridging
}

extension DatePickerStyle where Self == WheelDatePickerStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var wheel: WheelDatePickerStyle {
        fatalError()
    }
}

public struct DefaultDatePickerStyle : DatePickerStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: WheelDatePickerStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 0 // For bridging
}

extension DatePickerStyle where Self == DefaultDatePickerStyle {
    @MainActor @preconcurrency public static var automatic: DefaultDatePickerStyle {
        return DefaultDatePickerStyle()
    }
}

public struct GraphicalDatePickerStyle : DatePickerStyle {
    @available(*, unavailable)
    public init() {
        fatalError()
    }

    @MainActor @preconcurrency public func makeBody(configuration: WheelDatePickerStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 1 // For bridging
}

extension DatePickerStyle where Self == GraphicalDatePickerStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var graphical: GraphicalDatePickerStyle {
        fatalError()
    }
}

public struct CompactDatePickerStyle : DatePickerStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: WheelDatePickerStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 3 // For bridging
}

extension DatePickerStyle where Self == CompactDatePickerStyle {
    @MainActor @preconcurrency public static var compact: CompactDatePickerStyle {
        return CompactDatePickerStyle()
    }
}

public struct DatePickerStyleConfiguration {
    public struct Label : View {
        public typealias Body = Never
    }

    public let label: DatePickerStyleConfiguration.Label

    @Binding public var selection: Date

    public var minimumDate: Date?
    public var maximumDate: Date?

    public var displayedComponents: DatePickerComponents
}

extension View {
    nonisolated public func datePickerStyle<S>(_ style: S) -> some View where S : DatePickerStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.datePickerStyle(bridgedStyle: style.identifier)
        }
    }
}

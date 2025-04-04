// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipUI

/* @MainActor @preconcurrency */ public struct DatePicker<Label> : View where Label : View {
    private let selection: Binding<Date>
    private let displayedComponents: DatePicker<Label>.Components
    private let label: Label

    public typealias Components = DatePickerComponents

    public typealias Body = Never
}

extension DatePicker : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.DatePicker(getSelection: { selection.wrappedValue }, setSelection: { selection.wrappedValue = $0 }, bridgedDisplayedComponents: Int(displayedComponents.rawValue), bridgedLabel: label.Java_viewOrEmpty)
    }
}

extension DatePicker {
    /* nonisolated */ public init(selection: Binding<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) {
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.label = label()
    }

    @available(*, unavailable)
    /* nonisolated */ public init(selection: Binding<Date>, in range: ClosedRange<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) {
        fatalError()
    }

    @available(*, unavailable)
    /* nonisolated */ public init(selection: Binding<Date>, in range: PartialRangeFrom<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) {
        fatalError()
    }

    @available(*, unavailable)
    /* nonisolated */ public init(selection: Binding<Date>, in range: PartialRangeThrough<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date], @ViewBuilder label: () -> Label) {
        fatalError()
    }
}

extension DatePicker where Label == Text {
    /* nonisolated */ public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.label = Text(titleKey)
    }

    @available(*, unavailable)
    /* nonisolated */ public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, in range: ClosedRange<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        fatalError()
    }

    @available(*, unavailable)
    /* nonisolated */ public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, in range: PartialRangeFrom<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, in range: PartialRangeThrough<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) {
        fatalError()
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, selection: Binding<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol {
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.label = Text(title)
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<S>(_ title: S, selection: Binding<Date>, in range: ClosedRange<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<S>(_ title: S, selection: Binding<Date>, in range: PartialRangeFrom<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<S>(_ title: S, selection: Binding<Date>, in range: PartialRangeThrough<Date>, displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]) where S : StringProtocol {
        fatalError()
    }
}

public struct DatePickerComponents : OptionSet /*, Sendable */ {
    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static let hourAndMinute =  DatePickerComponents(rawValue: 0 << 1) // For bridging
    public static let date = DatePickerComponents(rawValue: 1 << 1) // For bridging
}

/* @MainActor @preconcurrency */ public protocol DatePickerStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor /* @preconcurrency */ func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = DatePickerStyleConfiguration

    var identifier: Int { get } // For bridging
}

extension DatePickerStyle {
    public var identifier: Int {
        return -1
    }
}

/* @MainActor @preconcurrency */ public struct WheelDatePickerStyle : DatePickerStyle {
    @available(*, unavailable)
    /* @MainActor @preconcurrency */ public init() {
        fatalError()
    }

    @MainActor /* @preconcurrency */ public func makeBody(configuration: WheelDatePickerStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 2 // For bridging
}

extension DatePickerStyle where Self == WheelDatePickerStyle {
    @available(*, unavailable)
    /* @MainActor @preconcurrency */ public static var wheel: WheelDatePickerStyle {
        fatalError()
    }
}

/* @MainActor @preconcurrency */ public struct DefaultDatePickerStyle : DatePickerStyle {
    /* @MainActor @preconcurrency */ public init() {
    }

    @MainActor /* @preconcurrency */ public func makeBody(configuration: WheelDatePickerStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 0 // For bridging
}

extension DatePickerStyle where Self == DefaultDatePickerStyle {
    /* @MainActor @preconcurrency */ public static var automatic: DefaultDatePickerStyle {
        return DefaultDatePickerStyle()
    }
}

/* @MainActor @preconcurrency */ public struct GraphicalDatePickerStyle : DatePickerStyle {
    @available(*, unavailable)
    /* @MainActor @preconcurrency */ public init() {
        fatalError()
    }

    @MainActor /* @preconcurrency */ public func makeBody(configuration: WheelDatePickerStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 1 // For bridging
}

extension DatePickerStyle where Self == GraphicalDatePickerStyle {
    @available(*, unavailable)
    /* @MainActor @preconcurrency */ public static var graphical: GraphicalDatePickerStyle {
        fatalError()
    }
}

/* @MainActor @preconcurrency */ public struct CompactDatePickerStyle : DatePickerStyle {
    /* @MainActor @preconcurrency */ public init() {
    }

    @MainActor /* @preconcurrency */ public func makeBody(configuration: WheelDatePickerStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 3 // For bridging
}

extension DatePickerStyle where Self == CompactDatePickerStyle {
    /* @MainActor @preconcurrency */ public static var compact: CompactDatePickerStyle {
        return CompactDatePickerStyle()
    }
}

public struct DatePickerStyleConfiguration {
    /* @MainActor @preconcurrency */ public struct Label : View {
        public typealias Body = Never
    }

    public let label: DatePickerStyleConfiguration.Label

    @Binding public var selection: Date

    public var minimumDate: Date?
    public var maximumDate: Date?

    public var displayedComponents: DatePickerComponents
}

extension View {
    /* nonisolated */ public func datePickerStyle<S>(_ style: S) -> some View where S : DatePickerStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.datePickerStyle(bridgedStyle: style.identifier)
        }
    }
}

// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipUI

@MainActor @preconcurrency public struct ProgressView<Label, CurrentValueLabel> : View where Label : View, CurrentValueLabel : View {
    private let value: Double?
    private let total: Double?
    private let label: UncheckedSendableBox<Label>?

    public typealias Body = Never
}

extension ProgressView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ProgressView(value: value, total: total, bridgedLabel: label?.wrappedValue.Java_viewOrEmpty)
    }
}

extension ProgressView {
    @available(*, unavailable)
    nonisolated public init(timerInterval: ClosedRange<Date>, countsDown: Bool = true, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> CurrentValueLabel) {
        fatalError()
    }
}

extension ProgressView where CurrentValueLabel == DefaultDateProgressLabel {
    @available(*, unavailable)
    nonisolated public init(timerInterval: ClosedRange<Date>, countsDown: Bool = true, @ViewBuilder label: () -> Label) {
        fatalError()
    }
}

extension ProgressView where Label == EmptyView, CurrentValueLabel == DefaultDateProgressLabel {
    @available(*, unavailable)
    nonisolated public init(timerInterval: ClosedRange<Date>, countsDown: Bool = true) {
        fatalError()
    }
}

extension ProgressView where CurrentValueLabel == EmptyView {
    nonisolated public init() where Label == EmptyView {
        self.value = nil
        self.total = nil
        self.label = nil
    }

    nonisolated public init(@ViewBuilder label: () -> Label) {
        self.value = nil
        self.total = nil
        self.label = UncheckedSendableBox(label())
    }

    nonisolated public init(_ titleKey: LocalizedStringKey) where Label == Text {
        self.init(label: { Text(titleKey) })
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S) where Label == Text, S : StringProtocol {
        self.init(label: { Text(title) })
    }
}

extension ProgressView {
    nonisolated public init<V>(value: V?, total: V = 1.0) where Label == EmptyView, CurrentValueLabel == EmptyView, V : BinaryFloatingPoint {
        self.value = value == nil ? nil : Double(value!)
        self.total = Double(total)
        self.label = nil
    }

    nonisolated public init<V>(value: V?, total: V = 1.0, @ViewBuilder label: () -> Label) where CurrentValueLabel == EmptyView, V : BinaryFloatingPoint {
        self.value = value == nil ? nil : Double(value!)
        self.total = Double(total)
        self.label = UncheckedSendableBox(label())
    }

    @available(*, unavailable)
    nonisolated public init<V>(value: V?, total: V = 1.0, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> CurrentValueLabel) where V : BinaryFloatingPoint {
        fatalError()
    }

    nonisolated public init<V>(_ titleKey: LocalizedStringKey, value: V?, total: V = 1.0) where Label == Text, CurrentValueLabel == EmptyView, V : BinaryFloatingPoint {
        self.init(value: value, total: total, label: { Text(titleKey) })
    }

    @_disfavoredOverload nonisolated public init<S, V>(_ title: S, value: V?, total: V = 1.0) where Label == Text, CurrentValueLabel == EmptyView, S : StringProtocol, V : BinaryFloatingPoint {
        self.init(value: value, total: total, label: { Text(title) })
    }
}

extension ProgressView {
    nonisolated public init(_ progress: Progress) where Label == EmptyView, CurrentValueLabel == EmptyView {
        self.value = progress.fractionCompleted
        self.total = 1.0
        self.label = nil
    }
}

extension ProgressView {
    @available(*, unavailable)
    nonisolated public init(_ configuration: ProgressViewStyleConfiguration) where Label == ProgressViewStyleConfiguration.Label, CurrentValueLabel == ProgressViewStyleConfiguration.CurrentValueLabel {
        fatalError()
    }
}

@MainActor @preconcurrency public protocol ProgressViewStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = ProgressViewStyleConfiguration

    nonisolated var identifier: Int { get } // For bridging
}

extension ProgressViewStyle {
    nonisolated public var identifier: Int {
        return -1
    }
}

@MainActor @preconcurrency public struct LinearProgressViewStyle : ProgressViewStyle {
    @MainActor @preconcurrency public init() {
    }

    @available(*, unavailable)
    @MainActor @preconcurrency public init(tint: Color) {
        fatalError()
    }

    @MainActor @preconcurrency public func makeBody(configuration: LinearProgressViewStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 1 // For bridging
}

extension ProgressViewStyle where Self == LinearProgressViewStyle {
    @MainActor @preconcurrency public static var linear: LinearProgressViewStyle {
        return LinearProgressViewStyle()
    }
}

@MainActor @preconcurrency public struct CircularProgressViewStyle : ProgressViewStyle {
    @MainActor @preconcurrency public init() {
    }

    @available(*, unavailable)
    @MainActor @preconcurrency public init(tint: Color) {
        fatalError()
    }

    @MainActor @preconcurrency public func makeBody(configuration: LinearProgressViewStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 2 // For bridging
}

extension ProgressViewStyle where Self == CircularProgressViewStyle {
    @MainActor @preconcurrency public static var circular: CircularProgressViewStyle {
        return CircularProgressViewStyle()
    }
}

@MainActor @preconcurrency public struct DefaultProgressViewStyle : ProgressViewStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: DefaultProgressViewStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 0 // For bridging
}

extension ProgressViewStyle where Self == DefaultProgressViewStyle {
    @MainActor @preconcurrency public static var automatic: DefaultProgressViewStyle {
        return DefaultProgressViewStyle()
    }
}

public struct ProgressViewStyleConfiguration {
    @MainActor @preconcurrency public struct Label : View {
        public typealias Body = Never
    }

    @MainActor @preconcurrency public struct CurrentValueLabel : View {
        public typealias Body = Never
    }

    public let fractionCompleted: Double?
    public var label: ProgressViewStyleConfiguration.Label?
    public var currentValueLabel: ProgressViewStyleConfiguration.CurrentValueLabel?
}

@MainActor @preconcurrency public struct DefaultDateProgressLabel : View {
    public typealias Body = Never
}

extension View {
    nonisolated public func progressViewStyle<S>(_ style: S) -> some View where S : ProgressViewStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.progressViewStyle(bridgedStyle: style.identifier)
        }
    }
}

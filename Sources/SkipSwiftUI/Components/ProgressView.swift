// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipFuse
import SkipUI

public struct ProgressView<Label, CurrentValueLabel> where Label : View, CurrentValueLabel : View {
    private let value: Double?
    private let total: Double?
    private let label: Label?
}

extension ProgressView : View {
    public typealias Body = Never
}

extension ProgressView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ProgressView(value: value, total: total, bridgedLabel: label?.Java_viewOrEmpty)
    }
}

extension ProgressView {
    @available(*, unavailable)
    public init(timerInterval: ClosedRange<Date>, countsDown: Bool = true, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> CurrentValueLabel) {
        fatalError()
    }
}

extension ProgressView where CurrentValueLabel == DefaultDateProgressLabel {
    @available(*, unavailable)
    public init(timerInterval: ClosedRange<Date>, countsDown: Bool = true, @ViewBuilder label: () -> Label) {
        fatalError()
    }
}

extension ProgressView where Label == EmptyView, CurrentValueLabel == DefaultDateProgressLabel {
    @available(*, unavailable)
    public init(timerInterval: ClosedRange<Date>, countsDown: Bool = true) {
        fatalError()
    }
}

extension ProgressView where CurrentValueLabel == EmptyView {
    public init() where Label == EmptyView {
        self.value = nil
        self.total = nil
        self.label = nil
    }

    public init(@ViewBuilder label: () -> Label) {
        self.value = nil
        self.total = nil
        self.label = label()
    }

    public init(_ titleKey: LocalizedStringKey) where Label == Text {
        self.init(label: { Text(titleKey) })
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource) where Label == Text {
        self.init(label: { Text(titleResource) })
    }

    @_disfavoredOverload public init<S>(_ title: S) where Label == Text, S : StringProtocol {
        self.init(label: { Text(title) })
    }
}

extension ProgressView {
    public init<V>(value: V?, total: V = 1.0) where Label == EmptyView, CurrentValueLabel == EmptyView, V : BinaryFloatingPoint {
        self.value = value == nil ? nil : Double(value!)
        self.total = Double(total)
        self.label = nil
    }

    public init<V>(value: V?, total: V = 1.0, @ViewBuilder label: () -> Label) where CurrentValueLabel == EmptyView, V : BinaryFloatingPoint {
        self.value = value == nil ? nil : Double(value!)
        self.total = Double(total)
        self.label = label()
    }

    @available(*, unavailable)
    public init<V>(value: V?, total: V = 1.0, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> CurrentValueLabel) where V : BinaryFloatingPoint {
        fatalError()
    }

    public init<V>(_ titleKey: LocalizedStringKey, value: V?, total: V = 1.0) where Label == Text, CurrentValueLabel == EmptyView, V : BinaryFloatingPoint {
        self.init(value: value, total: total, label: { Text(titleKey) })
    }

    @_disfavoredOverload public init<V>(_ titleResource: AndroidLocalizedStringResource, value: V?, total: V = 1.0) where Label == Text, CurrentValueLabel == EmptyView, V : BinaryFloatingPoint {
        self.init(value: value, total: total, label: { Text(titleResource) })
    }

    @_disfavoredOverload public init<S, V>(_ title: S, value: V?, total: V = 1.0) where Label == Text, CurrentValueLabel == EmptyView, S : StringProtocol, V : BinaryFloatingPoint {
        self.init(value: value, total: total, label: { Text(title) })
    }
}

extension ProgressView {
    public init(_ progress: Progress) where Label == EmptyView, CurrentValueLabel == EmptyView {
        self.value = progress.fractionCompleted
        self.total = 1.0
        self.label = nil
    }
}

extension ProgressView {
    @available(*, unavailable)
    public init(_ configuration: ProgressViewStyleConfiguration) where Label == ProgressViewStyleConfiguration.Label, CurrentValueLabel == ProgressViewStyleConfiguration.CurrentValueLabel {
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

public struct LinearProgressViewStyle : ProgressViewStyle {
    public init() {
    }

    @available(*, unavailable)
    public init(tint: Color) {
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

public struct CircularProgressViewStyle : ProgressViewStyle {
    public init() {
    }

    @available(*, unavailable)
    public init(tint: Color) {
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

public struct DefaultProgressViewStyle : ProgressViewStyle {
    public init() {
    }

    public func makeBody(configuration: DefaultProgressViewStyle.Configuration) -> some View {
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
    public struct Label : View {
        public typealias Body = Never
    }

    public struct CurrentValueLabel : View {
        public typealias Body = Never
    }

    public let fractionCompleted: Double?
    public var label: ProgressViewStyleConfiguration.Label?
    public var currentValueLabel: ProgressViewStyleConfiguration.CurrentValueLabel?
}

public struct DefaultDateProgressLabel : View {
    public typealias Body = Never
}

extension View {
    nonisolated public func progressViewStyle<S>(_ style: S) -> some View where S : ProgressViewStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.progressViewStyle(bridgedStyle: style.identifier)
        }
    }
}

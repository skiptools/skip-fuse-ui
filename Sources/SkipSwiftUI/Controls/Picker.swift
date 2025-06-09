// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

@MainActor @preconcurrency public struct Picker<Label, SelectionValue, Content> : View where Label : View, SelectionValue : Hashable, Content : View {
    private let selection: UncheckedSendableBox<Binding<SelectionValue>>
    private let content: UncheckedSendableBox<Content>
    private let label: UncheckedSendableBox<Label>

    public typealias Body = Never
}

extension Picker : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let getSelection: () -> SwiftHashable = { Java_swiftHashable(for: selection.wrappedValue.wrappedValue) }
        let setSelection: (SwiftHashable) -> Void = { selection.wrappedValue.wrappedValue = $0.base as! SelectionValue }
        return SkipUI.Picker(getSelection: getSelection, setSelection: setSelection, bridgedContent: content.wrappedValue.Java_viewOrEmpty, bridgedLabel: label.wrappedValue.Java_viewOrEmpty)
    }
}

extension Picker {
    @available(*, unavailable)
    nonisolated public init<C>(sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) where C : RandomAccessCollection {
        fatalError()
    }

    nonisolated public init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.selection = UncheckedSendableBox(selection)
        self.content = UncheckedSendableBox(content())
        self.label = UncheckedSendableBox(label())
    }
}

extension Picker where Label == Text {
    nonisolated public init(_ titleKey: LocalizedStringKey, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
        self.init(selection: selection, content: content, label: { Text(titleKey) })
    }

    @available(*, unavailable)
    nonisolated public init<C>(_ titleKey: LocalizedStringKey, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection {
        fatalError()
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.init(selection: selection, content: content, label: { Text(title) })
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<C, S>(_ title: S, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection, S : StringProtocol {
        fatalError()
    }
}

extension Picker where Label == SkipSwiftUI.Label<Text, Image> {
    nonisolated public init(_ titleKey: LocalizedStringKey, systemImage: String, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
        self.init(selection: selection, content: content, label: { SkipSwiftUI.Label(titleKey, systemImage: systemImage) })
    }

    @available(*, unavailable)
    nonisolated public init<C>(_ titleKey: LocalizedStringKey, systemImage: String, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection, C.Element == Binding<SelectionValue> {
        fatalError()
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, systemImage: String, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.init(selection: selection, content: content, label: { SkipSwiftUI.Label(title, systemImage: systemImage) })
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<C, S>(_ title: S, systemImage: String, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection, S : StringProtocol, C.Element == Binding<SelectionValue> {
        fatalError()
    }
}

//extension Picker where Label == Label<Text, Image> {
//    nonisolated public init(_ titleKey: LocalizedStringKey, image: ImageResource, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content)
//
//    nonisolated public init<C>(_ titleKey: LocalizedStringKey, image: ImageResource, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection, C.Element == Binding<SelectionValue>
//
//    nonisolated public init<S>(_ title: S, image: ImageResource, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) where S : StringProtocol
//
//    nonisolated public init<C, S>(_ title: S, image: ImageResource, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection, S : StringProtocol, C.Element == Binding<SelectionValue>
//}

extension Picker {
    @available(*, unavailable)
    nonisolated public init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> some View) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<C>(sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label, @ViewBuilder currentValueLabel: () -> some View) where C : RandomAccessCollection {
        fatalError()
    }
}

extension Picker where Label == Text {
    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<C>(_ titleKey: LocalizedStringKey, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where C : RandomAccessCollection {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<S>(_ title: S, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<C, S>(_ title: S, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where C : RandomAccessCollection, S : StringProtocol {
        fatalError()
    }
}

extension Picker where Label == SkipSwiftUI.Label<Text, Image> {
    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, systemImage: String, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<C>(_ titleKey: LocalizedStringKey, systemImage: String, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where C : RandomAccessCollection, C.Element == Binding<SelectionValue> {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<S>(_ title: S, systemImage: String, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<C, S>(_ title: S, systemImage: String, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where C : RandomAccessCollection, S : StringProtocol, C.Element == Binding<SelectionValue> {
        fatalError()
    }
}

//extension Picker where Label == Label<Text, Image> {
//    nonisolated public init(_ titleKey: LocalizedStringKey, image: ImageResource, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View)
//
//    nonisolated public init<C>(_ titleKey: LocalizedStringKey, image: ImageResource, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where C : RandomAccessCollection, C.Element == Binding<SelectionValue>
//
//    nonisolated public init<S>(_ title: S, image: ImageResource, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where S : StringProtocol
//
//    nonisolated public init<C, S>(_ title: S, image: ImageResource, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where C : RandomAccessCollection, S : StringProtocol, C.Element == Binding<SelectionValue>
//}

extension Picker {
    nonisolated public init(selection: Binding<SelectionValue>, label: Label, @ViewBuilder content: () -> Content) {
        self.init(selection: selection, content: content, label: { label })
    }
}

public protocol PickerStyle {
    nonisolated var identifier: Int { get } // For bridging
}

extension PickerStyle {
    nonisolated public var identifier: Int {
        return -1
    }
}

public struct RadioGroupPickerStyle : PickerStyle {
    @available(*, unavailable)
    public init() {
    }

    public let identifier = -1 // For bridging
}

extension PickerStyle where Self == RadioGroupPickerStyle {
    @available(*, unavailable)
    public static var radioGroup: RadioGroupPickerStyle {
        fatalError()
    }
}

public struct InlinePickerStyle : PickerStyle {
    @available(*, unavailable)
    public init() {
    }

    public let identifier = 4 // For bridging
}

extension PickerStyle where Self == InlinePickerStyle {
    @available(*, unavailable)
    public static var inline: InlinePickerStyle {
        fatalError()
    }
}

public struct DefaultPickerStyle : PickerStyle {
    public init() {
    }

    public let identifier = 1 // For bridging
}

extension PickerStyle where Self == DefaultPickerStyle {
    public static var automatic: DefaultPickerStyle {
        return DefaultPickerStyle()
    }
}

public struct SegmentedPickerStyle : PickerStyle {
    public init() {
    }

    public let identifier = 3 // For bridging
}

extension PickerStyle where Self == SegmentedPickerStyle {
    public static var segmented: SegmentedPickerStyle {
        return SegmentedPickerStyle()
    }
}

public struct PalettePickerStyle : PickerStyle {
    @available(*, unavailable)
    public init() {
    }

    public let identifier = 7 // For bridging
}

extension PickerStyle where Self == PalettePickerStyle {
    @available(*, unavailable)
    public static var palette: PalettePickerStyle {
        fatalError()
    }
}

public struct MenuPickerStyle : PickerStyle {
    public init() {
    }

    public let identifier = 6 // For bridging
}

extension PickerStyle where Self == MenuPickerStyle {
    public static var menu: MenuPickerStyle {
        return MenuPickerStyle()
    }
}

public struct NavigationLinkPickerStyle : PickerStyle {
    public init() {
    }

    public let identifier = 2 // For bridging
}

extension PickerStyle where Self == NavigationLinkPickerStyle {
    public static var navigationLink: NavigationLinkPickerStyle {
        return NavigationLinkPickerStyle()
    }
}

public struct WheelPickerStyle : PickerStyle {
    @available(*, unavailable)
    public init() {
    }

    public let identifier = 5 // For bridging
}

extension PickerStyle where Self == WheelPickerStyle {
    @available(*, unavailable)
    public static var wheel: WheelPickerStyle {
        fatalError()
    }
}

extension View {
    nonisolated public func pickerStyle<S>(_ style: S) -> some View where S : PickerStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.pickerStyle(bridgedStyle: style.identifier)
        }
    }

}

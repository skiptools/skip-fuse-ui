// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

extension View {
    nonisolated public func accessibilityValue(_ valueDescription: Text, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.accessibilityValue(valueDescription.Java_view as? SkipUI.Text ?? SkipUI.Text(verbatim: ""), isEnabled: isEnabled)
        }
    }

    nonisolated public func accessibilityValue(_ valueKey: LocalizedStringKey, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        return accessibilityValue(Text(valueKey), isEnabled: isEnabled)
    }

    @_disfavoredOverload nonisolated public func accessibilityValue<S>(_ value: S, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ where S : StringProtocol {
        return accessibilityValue(Text(value), isEnabled: isEnabled)
    }

    nonisolated public func accessibility(value: Text) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        return accessibilityValue(value)
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityShowsLargeContentViewer<V>(@ViewBuilder _ largeContentView: () -> V) -> some View where V : View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityShowsLargeContentViewer() -> some View {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityLinkedGroup<ID>(id: ID, in namespace: Namespace.ID) -> some View where ID : Hashable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityLabeledPair<ID>(role: Any /* AccessibilityLabeledPairRole */, id: ID, in namespace: Namespace.ID) -> some View where ID : Hashable {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityActions<Content>(category: AccessibilityActionCategory, @ViewBuilder _ content: () -> Content) -> some View where Content : View {
        stubView()
    }
}

extension View {
    nonisolated public func accessibilityLabel(_ label: Text, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.accessibilityLabel(label.Java_view as? SkipUI.Text ?? SkipUI.Text(verbatim: ""), isEnabled: isEnabled)
        }
    }

    nonisolated public func accessibilityLabel(_ labelKey: LocalizedStringKey, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        return accessibilityLabel(Text(labelKey), isEnabled: isEnabled)
    }

    @_disfavoredOverload nonisolated public func accessibilityLabel<S>(_ label: S, isEnabled: Bool) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ where S : StringProtocol {
        return accessibilityLabel(Text(label), isEnabled: isEnabled)
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityLabel<V>(@ViewBuilder content: (_ label: Any /* PlaceholderContentView<Self> */) -> V) -> some View where V : View {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityAdjustableAction(_ handler: @escaping (Any /* AccessibilityAdjustmentDirection */) -> Void) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityHint(_ hint: Text, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityHint(_ hintKey: LocalizedStringKey, isEnabled: Bool) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityHint<S>(_ hint: S, isEnabled: Bool) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ where S : StringProtocol {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibility(hidden: Bool) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    nonisolated public func accessibility(label: Text) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        return accessibilityLabel(label)
    }

    @available(*, unavailable)
    nonisolated public func accessibility(hint: Text) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibility(inputLabels: [Text]) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    nonisolated public func accessibility(identifier: String) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        return accessibilityIdentifier(identifier)
    }

    @available(*, unavailable)
    nonisolated public func accessibility(selectionIdentifier: AnyHashable) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibility(sortPriority: Double) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibility(activationPoint: CGPoint) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibility(activationPoint: UnitPoint) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }
}

extension View {
    nonisolated public func accessibilityHidden(_ hidden: Bool, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.accessibilityHidden(hidden, isEnabled: isEnabled)
        }
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityInputLabels(_ inputLabels: [Text], isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityInputLabels(_ inputLabelKeys: [LocalizedStringKey], isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityInputLabels<S>(_ inputLabels: [S], isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ where S : StringProtocol {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityRotorEntry<ID>(id: ID, in namespace: Namespace.ID) -> some View where ID : Hashable {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityRotor<Content>(_ label: Text, /* @AccessibilityRotorContentBuilder */ entries: @escaping () -> Content) -> some View where Content : AccessibilityRotorContent {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor<Content>(_ systemRotor: Any /* AccessibilitySystemRotor */, /* @AccessibilityRotorContentBuilder */ entries: @escaping () -> Content) -> some View where Content : AccessibilityRotorContent {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor<EntryModel>(_ rotorLabel: Text, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View where EntryModel : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor<EntryModel, ID>(_ rotorLabel: Text, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View where ID : Hashable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor<EntryModel>(_ systemRotor: Any /* AccessibilitySystemRotor */, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View where EntryModel : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor<EntryModel, ID>(_ systemRotor: Any /* AccessibilitySystemRotor */, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View where ID : Hashable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor(_ label: Text, textRanges: [Range<String.Index>]) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor(_ systemRotor: Any /* AccessibilitySystemRotor */, textRanges: [Range<String.Index>]) -> some View {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityRotor<Content>(_ labelKey: LocalizedStringKey, /* @AccessibilityRotorContentBuilder */ entries: @escaping () -> Content) -> some View where Content : AccessibilityRotorContent {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor<L, Content>(_ label: L, /* @AccessibilityRotorContentBuilder */ entries: @escaping () -> Content) -> some View where L : StringProtocol, Content : AccessibilityRotorContent {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor<EntryModel>(_ rotorLabelKey: LocalizedStringKey, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View where EntryModel : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor<L, EntryModel>(_ rotorLabel: L, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View where L : StringProtocol, EntryModel : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor<EntryModel, ID>(_ rotorLabelKey: LocalizedStringKey, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View where ID : Hashable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor<L, EntryModel, ID>(_ rotorLabel: L, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View where L : StringProtocol, ID : Hashable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor(_ labelKey: LocalizedStringKey, textRanges: [Range<String.Index>]) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRotor<L>(_ label: L, textRanges: [Range<String.Index>]) -> some View where L : StringProtocol {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    /* @inlinable */ nonisolated public func accessibilityIgnoresInvertColors(_ active: Bool = true) -> some View {
        stubView()
    }
}

extension View {
    nonisolated public func accessibilityIdentifier(_ identifier: String, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.accessibilityIdentifier(identifier, isEnabled: isEnabled)
        }
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityRepresentation<V>(@ViewBuilder representation: () -> V) -> some View where V : View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityChildren<V>(@ViewBuilder children: () -> V) -> some View where V : View {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityChartDescriptor<R>(_ representable: R) -> some View /* where R : AXChartDescriptorRepresentable */ {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityCustomContent(_ key: AccessibilityCustomContentKey, _ value: Text?, importance: Any? = nil /* AXCustomContent.Importance = .default */) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityCustomContent(_ key: AccessibilityCustomContentKey, _ valueKey: LocalizedStringKey, importance: Any? = nil /* AXCustomContent.Importance = .default */) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityCustomContent<V>(_ key: AccessibilityCustomContentKey, _ value: V, importance: Any? = nil /* AXCustomContent.Importance = .default */) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ where V : StringProtocol {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityCustomContent(_ label: Text, _ value: Text, importance: Any? = nil /* AXCustomContent.Importance = .default */) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityCustomContent(_ labelKey: LocalizedStringKey, _ value: Text, importance: Any? = nil /* AXCustomContent.Importance = .default */) ->  some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityCustomContent(_ labelKey: LocalizedStringKey, _ valueKey: LocalizedStringKey, importance: Any? = nil /* AXCustomContent.Importance = .default */) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityCustomContent<V>(_ labelKey: LocalizedStringKey, _ value: V, importance: Any? = nil /* AXCustomContent.Importance = .default */) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ where V : StringProtocol {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityFocused<Value>(_ binding: Any /* AccessibilityFocusState<Value>.Binding */, equals value: Value) -> some View where Value : Hashable {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityFocused(_ condition: Any /* AccessibilityFocusState<Bool>.Binding */) -> some View {
        stubView()
    }
}

extension View {
    nonisolated public func accessibilityAddTraits(_ traits: AccessibilityTraits) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.accessibilityAddTraits(bridgedTraits: traits.rawValue)
        }
    }

    @available(*, unavailable)
    nonisolated public func accessibilityRemoveTraits(_ traits: AccessibilityTraits) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }
}

extension View {
    nonisolated public func accessibility(addTraits traits: AccessibilityTraits) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        return accessibilityAddTraits(traits)
    }

    @available(*, unavailable)
    nonisolated public func accessibility(removeTraits traits: AccessibilityTraits) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityElement(children: AccessibilityChildBehavior = .ignore) -> some View {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityZoomAction(_ handler: @escaping (Any /* AccessibilityZoomGestureAction */) -> Void) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityActivationPoint(_ activationPoint: CGPoint, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityActivationPoint(_ activationPoint: UnitPoint, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityDragPoint(_ point: UnitPoint, description: Text, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityDragPoint(_ point: UnitPoint, description: LocalizedStringKey, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityDragPoint<S>(_ point: UnitPoint, description: S, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ where S : StringProtocol {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityDropPoint(_ point: UnitPoint, description: Text, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityDropPoint(_ point: UnitPoint, description: LocalizedStringKey, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public func accessibilityDropPoint<S>(_ point: UnitPoint, description: S, isEnabled: Bool = true) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ where S : StringProtocol {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityActivationPoint(_ activationPoint: CGPoint) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityActivationPoint(_ activationPoint: UnitPoint) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityAction(_ actionKind: AccessibilityActionKind = .default, _ handler: @escaping () -> Void) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityAction(named name: Text, _ handler: @escaping () -> Void) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityAction<Label>(action: @escaping () -> Void, @ViewBuilder label: () -> Label) -> some View where Label : View {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityActions<Content>(@ViewBuilder _ content: () -> Content) -> some View where Content : View {
        stubView()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func accessibilityAction(named nameKey: LocalizedStringKey, _ handler: @escaping () -> Void) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func accessibilityAction<S>(named name: S, _ handler: @escaping () -> Void) -> some View /* ModifiedContent<Self, AccessibilityAttachmentModifier> */ where S : StringProtocol {
        stubView()
    }
}

public struct AccessibilityActionCategory : Equatable, Sendable {
    public static let `default` = AccessibilityActionCategory("_default")

    public static let edit = AccessibilityActionCategory("_edit")

    public init(_ name: Text) {
    }

    public init(_ nameKey: LocalizedStringKey) {
        self.init(Text(nameKey))
    }

    @_disfavoredOverload public init(_ name: some StringProtocol) {
        self.init(Text(name))
    }
}

public struct AccessibilityActionKind : Equatable, Sendable {
    public static let `default` = AccessibilityActionKind(named: Text("_default"))

    public static let escape = AccessibilityActionKind(named: Text("_escape"))

    public static let magicTap = AccessibilityActionKind(named: Text("_magicTap"))

    public init(named name: Text) {
    }
}

public enum AccessibilityAdjustmentDirection : Hashable, Sendable {
    case increment
    case decrement
}

//@MainActor @preconcurrency public struct AccessibilityAttachmentModifier : ViewModifier {
//
//    /// The type of view representing the body.
//    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
//    public typealias Body = Never
//}

public struct AccessibilityChildBehavior : Hashable, Sendable {
    public static let ignore = AccessibilityChildBehavior()

    public static let contain = AccessibilityChildBehavior()

    public static let combine = AccessibilityChildBehavior()
}

public struct AccessibilityCustomContentKey : Equatable {
    public init(_ label: Text, id: String) {
    }

    public init(_ labelKey: LocalizedStringKey, id: String) {
    }

    public init(_ labelKey: LocalizedStringKey) {
    }
}

public struct AccessibilityDirectTouchOptions : OptionSet, Sendable {
    public typealias RawValue = UInt

    public let rawValue: AccessibilityDirectTouchOptions.RawValue

    public init(rawValue: AccessibilityDirectTouchOptions.RawValue) {
        self.rawValue = rawValue
    }

    public static let silentOnTouch = AccessibilityDirectTouchOptions(rawValue: 1 << 0)
    public static let requiresActivation = AccessibilityDirectTouchOptions(rawValue: 1 << 1)
}

@frozen public enum AccessibilityHeadingLevel : UInt {
    case unspecified = 0 // For bridging
    case h1 = 1 // For bridging
    case h2 = 2 // For bridging
    case h3 = 3 // For bridging
    case h4 = 4 // For bridging
    case h5 = 5 // For bridging
    case h6 = 6 // For bridging
}

@available(*, unavailable)
@propertyWrapper @frozen public struct AccessibilityFocusState<Value> : DynamicProperty where Value : Hashable {

//    @propertyWrapper @frozen public struct Binding {
//
//        /// The underlying value referenced by the bound property.
//        public var wrappedValue: Value { get nonmutating set }
//
//        /// The currently focused element.
//        public var projectedValue: AccessibilityFocusState<Value>.Binding { get }
//    }

    public var wrappedValue: Value {
        get {
            fatalError()
        }
        nonmutating set {
            fatalError()
        }
    }

    public var projectedValue: Any /* AccessibilityFocusState<Value>.Binding { get } */

    public init() where Value == Bool {
        fatalError()
    }

    public init(for technologies: AccessibilityTechnologies) where Value == Bool {
        fatalError()
    }

    public init<T>() where Value == T?, T : Hashable {
        fatalError()
    }

    public init<T>(for technologies: AccessibilityTechnologies) where Value == T?, T : Hashable {
        fatalError()
    }
}

//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension AccessibilityFocusState : Sendable where Value : Sendable {
//}

@frozen public enum AccessibilityLabeledPairRole : Hashable, Sendable, BitwiseCopyable {
    case label
    case content
}

@MainActor @preconcurrency public protocol AccessibilityRotorContent {
    associatedtype Body : AccessibilityRotorContent

    /* @AccessibilityRotorContentBuilder */ @MainActor @preconcurrency var body: Self.Body { get }
}
//
///// Result builder you use to generate rotor entry content.
//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//@resultBuilder public struct AccessibilityRotorContentBuilder {
//
//    /// Builds an expression within the builder.
//    public static func buildExpression<Content>(_ content: Content) -> Content where Content : AccessibilityRotorContent
//
//    public static func buildBlock<Content>(_ content: Content) -> some AccessibilityRotorContent where Content : AccessibilityRotorContent
//
//
//    public static func buildIf<Content>(_ content: Content?) -> some AccessibilityRotorContent where Content : AccessibilityRotorContent
//
//}
//
//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension AccessibilityRotorContentBuilder {
//
//    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent
//
//}
//
//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension AccessibilityRotorContentBuilder {
//
//    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent
//
//}
//
//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension AccessibilityRotorContentBuilder {
//
//    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent
//
//}
//
//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension AccessibilityRotorContentBuilder {
//
//    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent, C4 : AccessibilityRotorContent
//
//}
//
//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension AccessibilityRotorContentBuilder {
//
//    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent, C4 : AccessibilityRotorContent, C5 : AccessibilityRotorContent
//
//}
//
//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension AccessibilityRotorContentBuilder {
//
//    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent, C4 : AccessibilityRotorContent, C5 : AccessibilityRotorContent, C6 : AccessibilityRotorContent
//
//}
//
//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension AccessibilityRotorContentBuilder {
//
//    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent, C4 : AccessibilityRotorContent, C5 : AccessibilityRotorContent, C6 : AccessibilityRotorContent, C7 : AccessibilityRotorContent
//
//}
//
//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension AccessibilityRotorContentBuilder {
//
//    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent, C4 : AccessibilityRotorContent, C5 : AccessibilityRotorContent, C6 : AccessibilityRotorContent, C7 : AccessibilityRotorContent, C8 : AccessibilityRotorContent
//
//}
//
//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension AccessibilityRotorContentBuilder {
//
//    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> some AccessibilityRotorContent where C0 : AccessibilityRotorContent, C1 : AccessibilityRotorContent, C2 : AccessibilityRotorContent, C3 : AccessibilityRotorContent, C4 : AccessibilityRotorContent, C5 : AccessibilityRotorContent, C6 : AccessibilityRotorContent, C7 : AccessibilityRotorContent, C8 : AccessibilityRotorContent, C9 : AccessibilityRotorContent
//
//}

public struct AccessibilityRotorEntry<ID> where ID : Hashable {
    public init(_ label: Text, id: ID, textRange: Range<String.Index>? = nil, prepare: @escaping (() -> Void) = {}) {
    }

    public init(_ label: Text, id: ID, in namespace: Namespace.ID, textRange: Range<String.Index>? = nil, prepare: @escaping (() -> Void) = {}) {
    }

    public init(_ label: Text? = nil, textRange: Range<String.Index>, prepare: @escaping (() -> Void) = {}) where ID == Never {
    }

    public init(_ labelKey: LocalizedStringKey, id: ID, textRange: Range<String.Index>? = nil, prepare: @escaping (() -> Void) = {}) {
    }

    @_disfavoredOverload public init<L>(_ label: L, id: ID, textRange: Range<String.Index>? = nil, prepare: @escaping (() -> Void) = {}) where L : StringProtocol {
    }

    public init(_ labelKey: LocalizedStringKey, id: ID, in namespace: Namespace.ID, textRange: Range<String.Index>? = nil, prepare: @escaping (() -> Void) = {}) {
    }

    @_disfavoredOverload public init<L>(_ label: L, _ id: ID, in namespace: Namespace.ID, textRange: Range<String.Index>? = nil, prepare: @escaping (() -> Void) = {}) where L : StringProtocol {

    }

    public init(_ labelKey: LocalizedStringKey, textRange: Range<String.Index>, prepare: @escaping (() -> Void) = {}) {
    }

    @_disfavoredOverload public init<L>(_ label: L, textRange: Range<String.Index>, prepare: @escaping (() -> Void) = {}) where ID == Never, L : StringProtocol {

    }
}

//extension AccessibilityRotorEntry : AccessibilityRotorContent {
//
//    /// The internal content of this `AccessibilityRotorContent`.
//    @MainActor @preconcurrency public var body: Never { get }
//
//    /// The type for the internal content of this `AccessibilityRotorContent`.
//    @available(iOS 15.0, tvOS 15.0, watchOS 8.0, macOS 12.0, *)
//    public typealias Body = Never
//}

public struct AccessibilitySystemRotor : Sendable {
    public static func links(visited: Bool) -> AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static var links: AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static func headings(level: AccessibilityHeadingLevel) -> AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static var headings: AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static var boldText: AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static var italicText: AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static var underlineText: AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static var misspelledWords: AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static var images: AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static var textFields: AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static var tables: AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static var lists: AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }

    public static var landmarks: AccessibilitySystemRotor {
        return AccessibilitySystemRotor()
    }
}

public struct AccessibilityTechnologies : SetAlgebra, Sendable, OptionSet /* Added OptionSet conformance */ {
    public static let voiceOver = AccessibilityTechnologies(rawValue: 1 << 0)
    public static let switchControl = AccessibilityTechnologies(rawValue: 1 << 1)

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init() {
        self = []
    }
}

public struct AccessibilityTextContentType : Sendable {
    public static let plain = AccessibilityTextContentType()
    public static let console = AccessibilityTextContentType()
    public static let fileSystem = AccessibilityTextContentType()
    public static let messaging = AccessibilityTextContentType()
    public static let narrative = AccessibilityTextContentType()
    public static let sourceCode = AccessibilityTextContentType()
    public static let spreadsheet = AccessibilityTextContentType()
    public static let wordProcessing = AccessibilityTextContentType()
}

public struct AccessibilityTraits : SetAlgebra, OptionSet /* Added OptionSet conformance */, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init() {
        self = []
    }

    public static let isButton = AccessibilityTraits(rawValue: 1 << 0) // For bridging
    public static let isHeader = AccessibilityTraits(rawValue: 1 << 1) // For bridging
    public static let isSelected = AccessibilityTraits(rawValue: 1 << 2) // For bridging
    public static let isLink = AccessibilityTraits(rawValue: 1 << 3) // For bridging
    public static let isSearchField = AccessibilityTraits(rawValue: 1 << 4) // For bridging
    public static let isImage = AccessibilityTraits(rawValue: 1 << 5) // For bridging
    public static let playsSound = AccessibilityTraits(rawValue: 1 << 6) // For bridging
    public static let isKeyboardKey = AccessibilityTraits(rawValue: 1 << 7) // For bridging
    public static let isStaticText = AccessibilityTraits(rawValue: 1 << 8) // For bridging
    public static let isSummaryElement = AccessibilityTraits(rawValue: 1 << 9) // For bridging
    public static let updatesFrequently = AccessibilityTraits(rawValue: 1 << 10) // For bridging
    public static let startsMediaSession = AccessibilityTraits(rawValue: 1 << 11) // For bridging
    public static let allowsDirectInteraction = AccessibilityTraits(rawValue: 1 << 12) // For bridging
    public static let causesPageTurn = AccessibilityTraits(rawValue: 1 << 13) // For bridging
    public static let isModal = AccessibilityTraits(rawValue: 1 << 14) // For bridging
    public static let isToggle = AccessibilityTraits(rawValue: 1 << 15) // For bridging
    public static let isTabBar = AccessibilityTraits(rawValue: 1 << 16) // For bridging
}

public struct AccessibilityZoomGestureAction {
    @frozen public enum Direction : Hashable, Sendable, BitwiseCopyable {
        case zoomIn
        case zoomOut
    }

    public let direction: AccessibilityZoomGestureAction.Direction
    public let location: UnitPoint
    public let point: CGPoint
}

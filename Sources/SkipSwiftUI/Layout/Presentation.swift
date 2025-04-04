// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import Foundation
import SkipUI

public struct PresentationAdaptation /* : Sendable */ {
    public static var automatic: PresentationAdaptation {
        return PresentationAdaptation()
    }

    @available(*, unavailable)
    public static var none: PresentationAdaptation {
        fatalError()
    }

    @available(*, unavailable)
    public static var popover: PresentationAdaptation {
        fatalError()
    }

    @available(*, unavailable)
    public static var sheet: PresentationAdaptation {
        fatalError()
    }

    @available(*, unavailable)
    public static var fullScreenCover: PresentationAdaptation {
        fatalError()
    }
}

public struct PresentationBackgroundInteraction /* : Sendable */ {
    public static var automatic: PresentationBackgroundInteraction {
        return PresentationBackgroundInteraction()
    }

    @available(*, unavailable)
    public static var enabled: PresentationBackgroundInteraction {
        fatalError()
    }

    @available(*, unavailable)
    public static func enabled(upThrough detent: PresentationDetent) -> PresentationBackgroundInteraction {
        fatalError()
    }

    public static var disabled: PresentationBackgroundInteraction {
        return PresentationBackgroundInteraction()
    }
}

public struct PresentationContentInteraction : Equatable /*, Sendable */ {
    public static var automatic: PresentationContentInteraction {
        return PresentationContentInteraction()
    }

    @available(*, unavailable)
    public static var resizes: PresentationContentInteraction {
        fatalError()
    }

    public static var scrolls: PresentationContentInteraction {
        return PresentationContentInteraction()
    }
}

public struct PresentationDetent : Hashable /*, Sendable */ {
    let identifier: Int // For bridging
    let value: CGFloat

    public static let medium = PresentationDetent(identifier: 0, value: 0) // For bridging

    public static let large = PresentationDetent(identifier: 1, value: 0) // For bridging

    public static func fraction(_ fraction: CGFloat) -> PresentationDetent {
        return PresentationDetent(identifier: 2, value: fraction) // For bridging
    }

    public static func height(_ height: CGFloat) -> PresentationDetent {
        return PresentationDetent(identifier: 3, value: height) // For bridging
    }

    @available(*, unavailable)
    public static func custom<D>(_ type: D.Type) -> PresentationDetent where D : CustomPresentationDetent {
        fatalError()
    }

    @dynamicMemberLookup public struct Context {
        @available(*, unavailable)
        public var maxDetentValue: CGFloat {
            fatalError()
        }

        public subscript<T>(dynamicMember keyPath: KeyPath<EnvironmentValues, T>) -> T {
            return EnvironmentValues.shared[keyPath: keyPath]
        }
    }
}

public protocol CustomPresentationDetent {
    static func height(in context: Self.Context) -> CGFloat?
}

extension CustomPresentationDetent {
    public typealias Context = PresentationDetent.Context
}

extension View {
    @available(*, unavailable)
    /* nonisolated */ public func alert<Item>(item: Binding<Item?>, content: (Item) -> Any /* Alert */) -> some View where Item : Identifiable {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func alert(isPresented: Binding<Bool>, content: () -> Any /* Alert */) -> some View {
        stubView()
    }
}

extension View {
    /* nonisolated */ public func alert<A>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A) -> some View where A : View {
        return alert(Text(titleKey), isPresented: isPresented, actions: actions)
    }

    @_disfavoredOverload /* nonisolated */ public func alert<S, A>(_ title: S, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A) -> some View where S : StringProtocol, A : View {
        return alert(Text(title), isPresented: isPresented, actions: actions)
    }

    /* nonisolated */ public func alert<A>(_ title: Text, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A) -> some View where A : View {
        let actions = actions()
        return ModifierView(target: self) {
            let javaTitle = title.Java_view as? SkipUI.Text ?? SkipUI.Text(verbatim: "")
            return $0.Java_viewOrEmpty.alert(javaTitle, getIsPresented: { isPresented.wrappedValue }, setIsPresented: { isPresented.wrappedValue = $0 }, bridgedActions: actions.Java_viewOrEmpty)
        }
    }
}

extension View {
    /* nonisolated */ public func alert<A, M>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where A : View, M : View {
        return alert(Text(titleKey), isPresented: isPresented, actions: actions, message: message)
    }

    @_disfavoredOverload /* nonisolated */ public func alert<S, A, M>(_ title: S, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where S : StringProtocol, A : View, M : View {
        return alert(Text(title), isPresented: isPresented, actions: actions, message: message)
    }

    /* nonisolated */ public func alert<A, M>(_ title: Text, isPresented: Binding<Bool>, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where A : View, M : View {
        let actions = actions()
        let message = message()
        return ModifierView(target: self) {
            let javaTitle = title.Java_view as? SkipUI.Text ?? SkipUI.Text(verbatim: "")
            return $0.Java_viewOrEmpty.alert(javaTitle, getIsPresented: { isPresented.wrappedValue }, setIsPresented: { isPresented.wrappedValue = $0 }, bridgedActions: actions.Java_viewOrEmpty, bridgedMessage: message.Java_viewOrEmpty)
        }
    }
}

extension View {
    /* nonisolated */ public func alert<A, T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where A : View {
        return alert(Text(titleKey), isPresented: isPresented, presenting: data, actions: actions)
    }

    @_disfavoredOverload /* nonisolated */ public func alert<S, A, T>(_ title: S, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where S : StringProtocol, A : View {
        return alert(Text(title), isPresented: isPresented, presenting: data, actions: actions)
    }

    /* nonisolated */ public func alert<A, T>(_ title: Text, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where A : View {
        let actionsView: any View
        if let data {
            actionsView = actions(data)
        } else {
            actionsView = EmptyView()
        }
        return ModifierView(target: self) {
            let javaTitle = title.Java_view as? SkipUI.Text ?? SkipUI.Text(verbatim: "")
            return $0.Java_viewOrEmpty.alert(javaTitle, getIsPresented: { isPresented.wrappedValue }, setIsPresented: { isPresented.wrappedValue = $0 }, bridgedActions: actionsView.Java_viewOrEmpty)
        }
    }
}

extension View {
    /* nonisolated */ public func alert<A, M, T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where A : View, M : View {
        return alert(Text(titleKey), isPresented: isPresented, presenting: data, actions: actions, message: message)
    }

    @_disfavoredOverload /* nonisolated */ public func alert<S, A, M, T>(_ title: S, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where S : StringProtocol, A : View, M : View {
        return alert(Text(title), isPresented: isPresented, presenting: data, actions: actions, message: message)
    }

    /* nonisolated */ public func alert<A, M, T>(_ title: Text, isPresented: Binding<Bool>, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where A : View, M : View {
        let actionsView: any View
        let messageView: any View
        if let data {
            actionsView = actions(data)
            messageView = message(data)
        } else {
            actionsView = EmptyView()
            messageView = EmptyView()
        }
        return ModifierView(target: self) {
            let javaTitle = title.Java_view as? SkipUI.Text ?? SkipUI.Text(verbatim: "")
            return $0.Java_viewOrEmpty.alert(javaTitle, getIsPresented: { isPresented.wrappedValue }, setIsPresented: { isPresented.wrappedValue = $0 }, bridgedActions: actionsView.Java_viewOrEmpty, bridgedMessage: messageView.Java_viewOrEmpty)
        }
    }
}

extension View {
    /* nonisolated */ public func alert<E, A>(isPresented: Binding<Bool>, error: E?, @ViewBuilder actions: () -> A) -> some View where E : LocalizedError, A : View {
        if let error {
            return AnyView(alert(Text(error.localizedDescription), isPresented: isPresented, actions: actions))
        } else {
            return AnyView(self)
        }
    }

    /* nonisolated */ public func alert<E, A, M>(isPresented: Binding<Bool>, error: E?, @ViewBuilder actions: (E) -> A, @ViewBuilder message: (E) -> M) -> some View where E : LocalizedError, A : View, M : View {
        if let error {
            return AnyView(alert(Text(error.localizedDescription), isPresented: isPresented, actions: { actions(error) }, message: { message(error) }))
        } else {
            return AnyView(self)
        }
    }
}

extension View {
    /* nonisolated */ public func confirmationDialog<A>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> A) -> some View where A : View {
        return confirmationDialog(Text(titleKey), isPresented: isPresented, titleVisibility: titleVisibility, actions: actions)
    }

    @_disfavoredOverload /* nonisolated */ public func confirmationDialog<S, A>(_ title: S, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> A) -> some View where S : StringProtocol, A : View {
        return confirmationDialog(Text(title), isPresented: isPresented, titleVisibility: titleVisibility, actions: actions)
    }

    /* nonisolated */ public func confirmationDialog<A>(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> A) -> some View where A : View {
        let actions = actions()
        return ModifierView(target: self) {
            let javaTitle = title.Java_view as? SkipUI.Text ?? SkipUI.Text(verbatim: "")
            return $0.Java_viewOrEmpty.confirmationDialog(javaTitle, getIsPresented: { isPresented.wrappedValue }, setIsPresented: { isPresented.wrappedValue = $0 }, bridgedTitleVisibility: titleVisibility.rawValue, bridgedActions: actions.Java_viewOrEmpty)
        }
    }
}

extension View {
    /* nonisolated */ public func confirmationDialog<A, M>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where A : View, M : View {
        return confirmationDialog(Text(titleKey), isPresented: isPresented, titleVisibility: titleVisibility, actions: actions, message: message)
    }

    @_disfavoredOverload /* nonisolated */ public func confirmationDialog<S, A, M>(_ title: S, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where S : StringProtocol, A : View, M : View {
        return confirmationDialog(Text(title), isPresented: isPresented, titleVisibility: titleVisibility, actions: actions, message: message)
    }

    /* nonisolated */ public func confirmationDialog<A, M>(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, @ViewBuilder actions: () -> A, @ViewBuilder message: () -> M) -> some View where A : View, M : View {
        let actions = actions()
        let message = message()
        return ModifierView(target: self) {
            let javaTitle = title.Java_view as? SkipUI.Text ?? SkipUI.Text(verbatim: "")
            return $0.Java_viewOrEmpty.confirmationDialog(javaTitle, getIsPresented: { isPresented.wrappedValue }, setIsPresented: { isPresented.wrappedValue = $0 }, bridgedTitleVisibility: titleVisibility.rawValue, bridgedActions: actions.Java_viewOrEmpty, bridgedMessage: message.Java_viewOrEmpty)
        }
    }
}

extension View {
    /* nonisolated */ public func confirmationDialog<A, T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where A : View {
        return confirmationDialog(Text(titleKey), isPresented: isPresented, titleVisibility: titleVisibility, presenting: data, actions: actions)
    }

    @_disfavoredOverload /* nonisolated */ public func confirmationDialog<S, A, T>(_ title: S, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where S : StringProtocol, A : View {
        return confirmationDialog(Text(title), isPresented: isPresented, titleVisibility: titleVisibility, presenting: data, actions: actions)
    }

    /* nonisolated */ public func confirmationDialog<A, T>(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: (T) -> A) -> some View where A : View {
        let actionsView: any View
        if let data {
            actionsView = actions(data)
        } else {
            actionsView = EmptyView()
        }
        return ModifierView(target: self) {
            let javaTitle = title.Java_view as? SkipUI.Text ?? SkipUI.Text(verbatim: "")
            return $0.Java_viewOrEmpty.confirmationDialog(javaTitle, getIsPresented: { isPresented.wrappedValue }, setIsPresented: { isPresented.wrappedValue = $0 }, bridgedTitleVisibility: titleVisibility.rawValue, bridgedActions: actionsView.Java_viewOrEmpty)
        }
    }
}

extension View {
    /* nonisolated */ public func confirmationDialog<A, M, T>(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where A : View, M : View {
        return confirmationDialog(Text(titleKey), isPresented: isPresented, titleVisibility: titleVisibility, presenting: data, actions: actions, message: message)
    }

    @_disfavoredOverload /* nonisolated */ public func confirmationDialog<S, A, M, T>(_ title: S, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where S : StringProtocol, A : View, M : View {
        return confirmationDialog(Text(title), isPresented: isPresented, titleVisibility: titleVisibility, presenting: data, actions: actions, message: message)
    }

    /* nonisolated */ public func confirmationDialog<A, M, T>(_ title: Text, isPresented: Binding<Bool>, titleVisibility: Visibility = .automatic, presenting data: T?, @ViewBuilder actions: (T) -> A, @ViewBuilder message: (T) -> M) -> some View where A : View, M : View {
        let actionsView: any View
        let messageView: any View
        if let data {
            actionsView = actions(data)
            messageView = message(data)
        } else {
            actionsView = EmptyView()
            messageView = EmptyView()
        }
        return ModifierView(target: self) {
            let javaTitle = title.Java_view as? SkipUI.Text ?? SkipUI.Text(verbatim: "")
            return $0.Java_viewOrEmpty.confirmationDialog(javaTitle, getIsPresented: { isPresented.wrappedValue }, setIsPresented: { isPresented.wrappedValue = $0 }, bridgedTitleVisibility: titleVisibility.rawValue, bridgedActions: actionsView.Java_viewOrEmpty, bridgedMessage: messageView.Java_viewOrEmpty)
        }
    }
}

extension View {
    /* nonisolated */ public func fullScreenCover<Item, Content>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Identifiable, Content : View {
        let isPresented = Binding<Bool>(
            get: {
                return item.wrappedValue != nil
            },
            set: { newValue in
                if !newValue {
                    item.wrappedValue = nil
                }
            }
        )
        return fullScreenCover(isPresented: isPresented, onDismiss: onDismiss) {
            if let unwrappedItem = item.wrappedValue {
                content(unwrappedItem)
            }
        }
    }

    /* nonisolated */ public func fullScreenCover<Content>(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        let content = content()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.fullScreenCover(getIsPresented: { isPresented.wrappedValue }, setIsPresented: { isPresented.wrappedValue = $0 }, onDismiss: onDismiss, bridgedContent: content.Java_viewOrEmpty)
        }
    }
}

extension View {
    /* nonisolated */ public func sheet<Item, Content>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Identifiable, Content : View {
        let isPresented = Binding<Bool>(
            get: {
                return item.wrappedValue != nil
            },
            set: { newValue in
                if !newValue {
                    item.wrappedValue = nil
                }
            }
        )
        return sheet(isPresented: isPresented, onDismiss: onDismiss) {
            if let unwrappedItem = item.wrappedValue {
                content(unwrappedItem)
            }
        }
    }

    /* nonisolated */ public func sheet<Content>(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        let content = content()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.sheet(getIsPresented: { isPresented.wrappedValue }, setIsPresented: { isPresented.wrappedValue = $0 }, onDismiss: onDismiss, bridgedContent: content.Java_viewOrEmpty)
        }
    }
}

extension View {
    /* nonisolated */ public func interactiveDismissDisabled(_ isDisabled: Bool = true) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.interactiveDismissDisabled(isDisabled)
        }
    }
}

extension View {
    /// Android-only modifier to disable the hardware back button.
    public func backDismissDisabled(_ isDisabled: Bool = true) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.backDismissDisabled(isDisabled)
        }
    }
}

extension View {
    /* nonisolated */ public func presentationDetents(_ detents: Set<PresentationDetent>) -> some View {
        var detentIdentifiers: [Int] = []
        var detentValues: [CGFloat] = []
        for detent in detents {
            detentIdentifiers.append(detent.identifier)
            detentValues.append(detent.value)
        }
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.presentationDetents(bridgedDetents: detentIdentifiers, values: detentValues)
        }
    }

    @available(*, unavailable)
    /* nonisolated */ public func presentationDetents(_ detents: Set<PresentationDetent>, selection: Binding<PresentationDetent>) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* nonisolated */ public func presentationDragIndicator(_ visibility: Visibility) -> some View {
        stubView()
    }
}

extension View {
    /* nonisolated */ public func presentationBackgroundInteraction(_ interaction: PresentationBackgroundInteraction) -> some View {
        // Only .automatic is @available, so we can return self
        return self
    }

    /* nonisolated */ public func presentationCompactAdaptation(_ adaptation: PresentationAdaptation) -> some View {
        // Only .automatic is @available, so we can return self
        return self
    }

    /* nonisolated */ public func presentationCompactAdaptation(horizontal horizontalAdaptation: PresentationAdaptation, vertical verticalAdaptation: PresentationAdaptation) -> some View {
        // Only .automatic is @available, so we can return self
        return self
    }

    @available(*, unavailable)
    /* nonisolated */ public func presentationCornerRadius(_ cornerRadius: CGFloat?) -> some View {
        stubView()
    }

    /* nonisolated */ public func presentationContentInteraction(_ behavior: PresentationContentInteraction) -> some View {
        // Only .automatic is @available, so we can return self
        return self
    }
}

extension View {
    @available(*, unavailable)
    /* nonisolated */ public func presentationBackground<S>(_ style: S) -> some View where S : ShapeStyle {
        stubView()
    }

    /* nonisolated */ public func presentationBackground<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View {
        stubView()
    }
}

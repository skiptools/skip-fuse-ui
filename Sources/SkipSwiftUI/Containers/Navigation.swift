// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import Foundation
import SkipFuse
import SkipUI

public struct NavigationStack<Data, Root> where Root : View {
    private let root: Root
    private let getData: (() -> [Any /* SwiftHashable */])?
    private let setData: (([Any /* SwiftHashable */]) -> Void)?

    public init(@ViewBuilder root: () -> Root) where Data == NavigationPath {
        self.root = root()
        getData = nil
        setData = nil
    }

    public init(path: Binding<NavigationPath>, @ViewBuilder root: () -> Root) where Data == NavigationPath {
        self.root = root()
        self.getData = {
            let boundPath = path.wrappedValue
            return (0..<boundPath.count).map {
                Java_swiftHashable(for: boundPath[$0])
            }
        }
        self.setData = { array in
            var boundPath = NavigationPath()
            array.forEach { boundPath.append(($0 as! SwiftHashable).base as! AnyHashable) }
            path.wrappedValue = boundPath
        }
    }

    public init(path: Binding<Data>, @ViewBuilder root: () -> Root) where Data : MutableCollection, Data : RandomAccessCollection, Data : RangeReplaceableCollection, Data.Element : Hashable {
        self.root = root()
        self.getData = {
            return path.wrappedValue.map { Java_swiftHashable(for: $0) }
        }
        self.setData = { array in
            var boundPath = path.wrappedValue
            boundPath.replaceSubrange(boundPath.startIndex..<boundPath.endIndex, with: array.map { ($0 as! SwiftHashable).base as! Data.Element })
            path.wrappedValue = boundPath
        }
    }
}

extension NavigationStack : View {
    public typealias Body = Never
}

extension NavigationStack : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        // When bridging we key destination functions on string rather than KClass
        let destinationKeyTransformer: (Any) -> String = {
            let value = ($0 as! SwiftHashable).base
            return String(describing: type(of: value))
        }
        return SkipUI.NavigationStack(getData: getData, setData: setData, bridgedRoot: root.Java_viewOrEmpty, destinationKeyTransformer: destinationKeyTransformer)
    }
}

public struct NavigationLink<Label, Destination> where Label : View, Destination : View {
    private let destination: Destination?
    private let value: AnyHashable?
    private let label: Label

    public init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination()
        self.value = nil
        self.label = label()
    }

    public init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.init(destination: { destination }, label: label)
    }
}

extension NavigationLink : View {
    public typealias Body = Never
}

extension NavigationLink : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let bridgedValue = value == nil ? nil : Java_swiftHashable(for: value!)
        return SkipUI.NavigationLink(bridgedDestination: destination?.Java_viewOrEmpty, value: bridgedValue, bridgedLabel: label.Java_viewOrEmpty)
    }
}

extension NavigationLink where Destination == Never {
    public init<P>(value: P?, @ViewBuilder label: () -> Label) where P : Hashable {
        self.value = value
        self.label = label()
        self.destination = nil
    }

    public init<P>(_ titleKey: LocalizedStringKey, value: P?) where Label == Text, P : Hashable {
        self.init(value: value, label: { Text(titleKey) })
    }

    @_disfavoredOverload public init<P>(_ titleResource: AndroidLocalizedStringResource, value: P?) where Label == Text, P : Hashable {
        self.init(value: value, label: { Text(titleResource) })
    }

    @_disfavoredOverload public init<S, P>(_ title: S, value: P?) where Label == Text, S : StringProtocol, P : Hashable {
        self.init(value: value, label: { Text(title) })
    }

//    public init<P>(value: P?, @ViewBuilder label: () -> Label) where P : Decodable, P : Encodable, P : Hashable
//
//    public init<P>(_ titleKey: LocalizedStringKey, value: P?) where Label == Text, P : Decodable, P : Encodable, P : Hashable
//
//    public init<S, P>(_ title: S, value: P?) where Label == Text, S : StringProtocol, P : Decodable, P : Encodable, P : Hashable
}

extension NavigationLink where Label == Text {
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder destination: () -> Destination) {
        self.init(destination: destination, label: { Text(titleKey) })
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, @ViewBuilder destination: () -> Destination) {
        self.init(destination: destination, label: { Text(titleResource) })
    }

    @_disfavoredOverload public init<S>(_ title: S, @ViewBuilder destination: () -> Destination) where S : StringProtocol {
        self.init(destination: destination, label: { Text(title) })
    }

    public init(_ titleKey: LocalizedStringKey, destination: Destination) {
        self.init(destination: { destination }, label: { Text(titleKey) })
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, destination: Destination) {
        self.init(destination: { destination }, label: { Text(titleResource) })
    }

    @_disfavoredOverload public init<S>(_ title: S, destination: Destination) where S : StringProtocol {
        self.init(title, destination: { destination })
    }
}

extension NavigationLink {
    @available(*, unavailable)
    @MainActor @preconcurrency public func isDetailLink(_ isDetailLink: Bool) -> some View {
        stubView()
    }
}

public struct NavigationPath {
    private var elements: [AnyHashable]

    public var count: Int {
        return elements.count
    }

    public var isEmpty: Bool {
        return elements.isEmpty
    }

    public subscript(index: Int) -> AnyHashable {
        return elements[index]
    }

    @available(*, unavailable)
    public var codable: NavigationPath.CodableRepresentation? {
        fatalError()
    }

    public init() {
        self.elements = []
    }

    public init<S>(_ elements: S) where S : Sequence, S.Element : Hashable {
        self.elements = Array(elements)
    }

    public init<S>(_ elements: S) where S : Sequence, S.Element : Decodable, S.Element : Encodable, S.Element : Hashable {
        self.elements = Array(elements)
    }

    @available(*, unavailable)
    public init(_ codable: NavigationPath.CodableRepresentation) {
        fatalError()
    }

    public mutating func append<V>(_ value: V) where V : Hashable {
        elements.append(value)
    }

    public mutating func append<V>(_ value: V) where V : Decodable, V : Encodable, V : Hashable {
        elements.append(value)
    }

    public mutating func removeLast(_ k: Int = 1) {
        elements.removeLast(k)
    }

    public struct CodableRepresentation : Codable {
        public init(from decoder: any Decoder) throws {
            fatalError()
        }

        public func encode(to encoder: any Encoder) throws {
            fatalError()
        }
    }
}

extension NavigationPath : Equatable {
    public static func == (lhs: NavigationPath, rhs: NavigationPath) -> Bool {
        return lhs.elements == rhs.elements
    }
}

extension NavigationPath.CodableRepresentation : Equatable {
    public static func == (lhs: NavigationPath.CodableRepresentation, rhs: NavigationPath.CodableRepresentation) -> Bool {
        fatalError()
    }
}

extension View {
    nonisolated public func navigationDestination<D, C>(for data: D.Type, @ViewBuilder destination: @escaping (D) -> C) -> some View where D : Hashable, C : View {
        return ModifierView(target: self) {
            let bridgedDestination: (Any) -> any SkipUI.View = {
                let data = ($0 as! SwiftHashable).base as! D
                return destination(data).Java_viewOrEmpty
            }
            return $0.Java_viewOrEmpty.navigationDestination(destinationKey: String(describing: data), bridgedDestination: bridgedDestination)
        }
    }

    nonisolated public func navigationDestination<V>(isPresented: Binding<Bool>, @ViewBuilder destination: () -> V) -> some View where V : View {
        let destinationView = destination()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.navigationDestination(getIsPresented: { isPresented.wrappedValue }, setIsPresented: { isPresented.wrappedValue = $0 }, bridgedDestination: destinationView.Java_viewOrEmpty)
        }
    }
}

public struct NavigationBarItem : Sendable {
    public enum TitleDisplayMode : Int, Hashable, Sendable {
        case automatic = 0 // For bridging
        case inline = 1 // For bridging
        case large = 2 // For bridging
    }
}

extension View {
    nonisolated public func navigationTitle(_ title: Text) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.navigationTitle(title.Java_view as? SkipUI.Text ?? SkipUI.Text(verbatim: ""))
        }
    }

    nonisolated public func navigationTitle(_ titleKey: LocalizedStringKey) -> some View {
        return navigationTitle(Text(titleKey))
    }

    @_disfavoredOverload nonisolated public func navigationTitle(_ titleResource: AndroidLocalizedStringResource) -> some View {
        return navigationTitle(Text(titleResource))
    }

    @_disfavoredOverload nonisolated public func navigationTitle<S>(_ title: S) -> some View where S : StringProtocol {
        return navigationTitle(Text(title))
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func navigationTitle(_ title: Binding<String>) -> some View {
        stubView()
    }
}

extension View {
    nonisolated public func navigationBarTitleDisplayMode(_ displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.navigationBarTitleDisplayMode(bridgedDisplayMode: displayMode.rawValue)
        }
    }
}

extension View {
    nonisolated public func navigationDestination<D, C>(item: Binding<D?>, @ViewBuilder destination: @escaping (D) -> C) -> some View where D : Hashable, C : View {
        return ModifierView(target: self) {
            let bridgedDestination: (Any) -> any SkipUI.View = {
                let data = ($0 as! SwiftHashable).base as! D
                return destination(data).Java_viewOrEmpty
            }
            let getItem: () -> Any? = {
                if let value = item.wrappedValue {
                    return Java_swiftHashable(for: value)
                }
                return nil
            }
            let setItem: (Any?) -> Void = {
                if let value = $0 {
                    item.wrappedValue = (value as! SwiftHashable).base as? D
                } else {
                    item.wrappedValue = nil
                }
            }
            return $0.Java_viewOrEmpty.navigationDestination(getItem: getItem, setItem: setItem, bridgedDestination: bridgedDestination)
        }
    }
}

public struct NavigationSplitView<Sidebar, Content, Detail> where Sidebar : View, Content : View, Detail : View {
    @available(*, unavailable)
    public init(@ViewBuilder sidebar: () -> Sidebar, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail) {
        fatalError()
    }

    @available(*, unavailable)
    public init(columnVisibility: Binding<NavigationSplitViewVisibility>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail) {
        fatalError()
    }

    @available(*, unavailable)
    public init(@ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) where Content == EmptyView {
        fatalError()
    }

    @available(*, unavailable)
    public init(columnVisibility: Binding<NavigationSplitViewVisibility>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) where Content == EmptyView {
        fatalError()
    }
}

extension NavigationSplitView : View {
    public typealias Body = Never
}

extension NavigationSplitView {
    @available(*, unavailable)
    public init(preferredCompactColumn: Binding<NavigationSplitViewColumn>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail) {
        fatalError()
    }

    @available(*, unavailable)
    public init(columnVisibility: Binding<NavigationSplitViewVisibility>, preferredCompactColumn: Binding<NavigationSplitViewColumn>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail) {
        fatalError()
    }

    @available(*, unavailable)
    public init(preferredCompactColumn: Binding<NavigationSplitViewColumn>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) where Content == EmptyView {
        fatalError()
    }

    @available(*, unavailable)
    public init(columnVisibility: Binding<NavigationSplitViewVisibility>, preferredCompactColumn: Binding<NavigationSplitViewColumn>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) where Content == EmptyView {
        fatalError()
    }
}

public struct NavigationSplitViewColumn : Hashable, Sendable {
    @available(*, unavailable)
    public static var sidebar: NavigationSplitViewColumn {
        fatalError()
    }

    @available(*, unavailable)
    public static var content: NavigationSplitViewColumn {
        fatalError()
    }

    @available(*, unavailable)
    public static var detail: NavigationSplitViewColumn {
        fatalError()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func navigationSplitViewColumnWidth(_ width: CGFloat) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func navigationSplitViewColumnWidth(min: CGFloat? = nil, ideal: CGFloat, max: CGFloat? = nil) -> some View {
        stubView()
    }
}

@MainActor @preconcurrency public protocol NavigationSplitViewStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = NavigationSplitViewStyleConfiguration
}

extension View {
    @available(*, unavailable)
    nonisolated public func navigationSplitViewStyle<S>(_ style: S) -> some View where S : NavigationSplitViewStyle {
        stubView()
    }
}

public struct AutomaticNavigationSplitViewStyle : NavigationSplitViewStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: AutomaticNavigationSplitViewStyle.Configuration) -> some View {
        stubView()
    }
}

extension NavigationSplitViewStyle where Self == AutomaticNavigationSplitViewStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var automatic: AutomaticNavigationSplitViewStyle {
        fatalError()
    }
}

public struct BalancedNavigationSplitViewStyle : NavigationSplitViewStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: AutomaticNavigationSplitViewStyle.Configuration) -> some View {
        stubView()
    }
}

extension NavigationSplitViewStyle where Self == BalancedNavigationSplitViewStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var balanced: BalancedNavigationSplitViewStyle {
        fatalError()
    }
}

public struct ProminentDetailNavigationSplitViewStyle : NavigationSplitViewStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: AutomaticNavigationSplitViewStyle.Configuration) -> some View {
        stubView()
    }
}

extension NavigationSplitViewStyle where Self == ProminentDetailNavigationSplitViewStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var prominentDetail: ProminentDetailNavigationSplitViewStyle {
        fatalError()
    }
}

public struct NavigationSplitViewStyleConfiguration {
}

public struct NavigationSplitViewVisibility : Equatable, Codable, Sendable {
    @available(*, unavailable)
    public static var detailOnly: NavigationSplitViewVisibility {
        fatalError()
    }

    @available(*, unavailable)
    public static var doubleColumn: NavigationSplitViewVisibility {
        fatalError()
    }

    @available(*, unavailable)
    public static var all: NavigationSplitViewVisibility {
        fatalError()
    }

    @available(*, unavailable)
    public static var automatic: NavigationSplitViewVisibility {
        fatalError()
    }
}

public protocol NavigationTransition {
}

extension View {
    @available(*, unavailable)
    nonisolated public func navigationTransition(_ style: some NavigationTransition) -> some View {
        stubView()
    }
}

public struct AutomaticNavigationTransition : NavigationTransition {
    @available(*, unavailable)
    public init() {
    }
}

extension NavigationTransition where Self == AutomaticNavigationTransition {
    @available(*, unavailable)
    public static var automatic: AutomaticNavigationTransition {
        fatalError()
    }
}

extension NavigationTransition where Self == ZoomNavigationTransition {
    @available(*, unavailable)
    public static func zoom(sourceID: some Hashable, in namespace: Namespace.ID) -> ZoomNavigationTransition {
        fatalError()
    }
}

public struct ZoomNavigationTransition : NavigationTransition {
    @available(*, unavailable)
    public init() {
    }
}

extension View {
    nonisolated public func navigationBarItems<L, T>(leading: L, trailing: T) -> some View where L : View, T : View {
        return toolbar {
            ToolbarItem(placement: .navigationBarLeading) { leading }
            ToolbarItem(placement: .navigationBarTrailing) { trailing }
        }
    }

    nonisolated public func navigationBarItems<L>(leading: L) -> some View where L : View {
        return toolbar {
            ToolbarItem(placement: .navigationBarLeading) { leading }
        }
    }

    nonisolated public func navigationBarItems<T>(trailing: T) -> some View where T : View {
        return toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { trailing }
        }
    }

    nonisolated public func navigationBarHidden(_ hidden: Bool) -> some View {
        return toolbarVisibility(.hidden, for: .navigationBar)
    }
}

extension View {
    nonisolated public func navigationBarTitle(_ title: Text) -> some View {
        return navigationTitle(title)
    }

    nonisolated public func navigationBarTitle(_ titleKey: LocalizedStringKey) -> some View {
        return navigationTitle(titleKey)
    }

    @_disfavoredOverload nonisolated public func navigationBarTitle(_ titleResource: AndroidLocalizedStringResource) -> some View {
        return navigationTitle(titleResource)
    }

    @_disfavoredOverload nonisolated public func navigationBarTitle<S>(_ title: S) -> some View where S : StringProtocol {
        return navigationTitle(title)
    }

    nonisolated public func navigationBarTitle(_ title: Text, displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        return navigationTitle(title).navigationBarTitleDisplayMode(displayMode)
    }

    nonisolated public func navigationBarTitle(_ titleKey: LocalizedStringKey, displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        return navigationBarTitle(Text(titleKey), displayMode: displayMode)
    }

    @_disfavoredOverload nonisolated public func navigationBarTitle(_ titleResource: AndroidLocalizedStringResource, displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        return navigationBarTitle(Text(titleResource), displayMode: displayMode)
    }

    @_disfavoredOverload nonisolated public func navigationBarTitle<S>(_ title: S, displayMode: NavigationBarItem.TitleDisplayMode) -> some View where S : StringProtocol {
        return navigationBarTitle(Text(title), displayMode: displayMode)
    }

    nonisolated public func navigationBarBackButtonHidden(_ hidesBackButton: Bool = true) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.navigationBarBackButtonHidden(hidesBackButton)
        }
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func navigationDocument /* <D> */(_ document: Any /* D */) -> some View /* where D : Transferable */ {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func navigationDocument /* <D> */(_ document: Any /* D */, preview: Any /* SharePreview<Never, Never> */) -> some View /* where D : Transferable */ {
        stubView()
    }

//    nonisolated public func navigationDocument<D, I>(_ document: D, preview: SharePreview<Never, I>) -> some View where D : Transferable, I : Transferable
//
//    nonisolated public func navigationDocument<D, I>(_ document: D, preview: SharePreview<I, Never>) -> some View where D : Transferable, I : Transferable
//
//    nonisolated public func navigationDocument<D, I1, I2>(_ document: D, preview: SharePreview<I1, I2>) -> some View where D : Transferable, I1 : Transferable, I2 : Transferable

    @available(*, unavailable)
    nonisolated public func navigationDocument(_ url: URL) -> some View {
        stubView()
    }
}

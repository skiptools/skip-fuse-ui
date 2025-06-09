// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipBridge
import SkipUI

@MainActor @preconcurrency public struct List<SelectionValue, Content> : View where SelectionValue : Hashable, Content : View {
    private let content: UncheckedSendableBox<Content>

    @available(*, unavailable)
    nonisolated public init(selection: Binding<Set<SelectionValue>>?, @ViewBuilder content: () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(selection: Binding<SelectionValue?>?, @ViewBuilder content: () -> Content) {
        fatalError()
    }

    public typealias body = Never
}

extension List : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.List(bridgedContent: content.wrappedValue.Java_viewOrEmpty)
    }
}

extension List {
    @available(*, unavailable)
    nonisolated public init<Data, RowContent>(_ data: Data, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where /* Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where /* Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<RowContent>(_ data: Range<Int>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>, RowContent : View {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, RowContent>(_ data: Data, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where /* Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where /* Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<RowContent>(_ data: Range<Int>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, RowContent>, RowContent : View {
        fatalError()
    }
}

extension List where SelectionValue == Never {
    nonisolated public init(@ViewBuilder content: () -> Content) {
        self.content = UncheckedSendableBox(content())
    }

    nonisolated public init<Data, RowContent>(_ data: Data, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        self.content = UncheckedSendableBox(ForEach(data, content: rowContent))
    }

    @available(*, unavailable)
    nonisolated public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where /* Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        fatalError()
    }

    nonisolated public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        self.content = UncheckedSendableBox(ForEach(data, id: id, content: rowContent))
    }

    @available(*, unavailable)
    nonisolated public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where /* Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        fatalError()
    }

    nonisolated public init<RowContent>(_ data: Range<Int>, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, RowContent>, RowContent : View {
        self.content = UncheckedSendableBox(ForEach(data, content: rowContent))
    }
}

extension List {
    @available(*, unavailable)
    nonisolated public init<Data, RowContent>(_ data: Binding<Data>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, RowContent>(_ data: Binding<Data>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable {
        fatalError()
    }
}

extension List where SelectionValue == Never {
    nonisolated public init<Data, RowContent>(_ data: Binding<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable {
        self.content = UncheckedSendableBox(ForEach(data, content: rowContent))
    }

    nonisolated public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable {
        self.content = UncheckedSendableBox(ForEach(data, id: id, content: rowContent))
    }
}

extension List {
    @available(*, unavailable)
    nonisolated public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        fatalError()
    }
}

extension List where SelectionValue == Never {
    @available(*, unavailable)
    nonisolated public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        fatalError()
    }
}

extension List {
    @available(*, unavailable)
    nonisolated public init<Data, RowContent>(_ data: Binding<Data>, editActions: Any /* EditActions<Data> */, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, */ Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: Any /* EditActions<Data> */, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, */ Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable {
        fatalError()
    }
}

extension List {
    @available(*, unavailable)
    nonisolated public init<Data, RowContent>(_ data: Binding<Data>, editActions: Any /* EditActions<Data> */, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, */ Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: Any /* EditActions<Data> */, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, */ Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable {
        fatalError()
    }
}

extension List where SelectionValue == Never {
//    nonisolated public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable
    nonisolated public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, Data : RangeReplaceableCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable {
        self.content = UncheckedSendableBox(ForEach(data, editActions: editActions, content: rowContent))
    }

//    nonisolated public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable
    nonisolated public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, Data : RangeReplaceableCollection, RowContent : View, Data.Index : Hashable {
        self.content = UncheckedSendableBox(ForEach(data, id: id, editActions: editActions, content: rowContent))
    }
}

public struct ListSectionSpacing : Sendable {
    public static let `default` = ListSectionSpacing()

    public static let compact = ListSectionSpacing()

    public static func custom(_ spacing: CGFloat) -> ListSectionSpacing {
        return ListSectionSpacing()
    }
}

public struct ListItemTint : Sendable {
    public static func fixed(_ tint: Color) -> ListItemTint {
        return ListItemTint()
    }

    public static func preferred(_ tint: Color) -> ListItemTint {
        return ListItemTint()
    }

    public static let monochrome = ListItemTint()
}

public protocol ListStyle {
    nonisolated var identifier: Int { get } // For bridging
}

extension ListStyle {
    nonisolated public var identifier: Int {
        return -1
    }
}

public struct DefaultListStyle : ListStyle {
    public init() {
    }

    public let identifier = 0 // For bridging
}

extension ListStyle where Self == DefaultListStyle {
    public static var automatic: DefaultListStyle {
        return DefaultListStyle()
    }
}

public struct SidebarListStyle : ListStyle {
    @available(*, unavailable)
    public init() {
        fatalError()
    }
}

extension ListStyle where Self == SidebarListStyle {
    @available(*, unavailable)
    public static var sidebar: SidebarListStyle {
        fatalError()
    }
}

public struct InsetListStyle : ListStyle {
    @available(*, unavailable)
    public init() {
        fatalError()
    }

    @available(*, unavailable)
    public init(alternatesRowBackgrounds: Bool) {
        fatalError()
    }
}

extension ListStyle where Self == InsetListStyle {
    @available(*, unavailable)
    public static var inset: InsetListStyle {
        fatalError()
    }

    @available(*, unavailable)
    public static func inset(alternatesRowBackgrounds: Bool) -> InsetListStyle {
        fatalError()
    }
}

public struct PlainListStyle : ListStyle {
    public init() {
    }

    public let identifier = 5 // For bridging
}

extension ListStyle where Self == PlainListStyle {
    public static var plain: PlainListStyle {
        return PlainListStyle()
    }
}

public struct BorderedListStyle : ListStyle {
    @available(*, unavailable)
    public init() {
        fatalError()
    }

    @available(*, unavailable)
    public init(alternatesRowBackgrounds: Bool) {
        fatalError()
    }
}

extension ListStyle where Self == BorderedListStyle {
    @available(*, unavailable)
    public static var bordered: BorderedListStyle {
        fatalError()
    }

    @available(*, unavailable)
    public static func bordered(alternatesRowBackgrounds: Bool) -> BorderedListStyle {
        fatalError()
    }
}

extension View {
    /* @inlinable */ nonisolated public func listRowBackground<V>(_ view: V?) -> some View where V : View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listRowBackground(view?.Java_viewOrEmpty)
        }
    }

    nonisolated public func listRowSeparator(_ visibility: Visibility, edges: VerticalEdge.Set = .all) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listRowSeparator(bridgedVisibility: visibility.rawValue, bridgedEdges: Int(edges.rawValue))
        }
    }

    @available(*, unavailable)
    nonisolated public func listRowSeparatorTint(_ color: Color?, edges: VerticalEdge.Set = .all) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func listSectionSeparator(_ visibility: Visibility, edges: VerticalEdge.Set = .all) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func listSectionSeparatorTint(_ color: Color?, edges: VerticalEdge.Set = .all) -> some View {
        stubView()
    }

    nonisolated public func listStyle<S>(_ style: S) -> some View where S : ListStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listStyle(bridgedStyle: style.identifier)
        }
    }

    @available(*, unavailable)
    /* @inlinable */ nonisolated public func listItemTint(_ tint: ListItemTint?) -> some View {
        stubView()
    }

    /* @inlinable */ nonisolated public func listItemTint(_ tint: Color?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listItemTint(tint?.Java_view as? SkipUI.Color)
        }
    }

    @available(*, unavailable)
    /* @inlinable */ nonisolated public func listRowInsets(_ insets: EdgeInsets?) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* @inlinable */ nonisolated public func listRowSpacing(_ spacing: CGFloat?) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* @inlinable */ nonisolated public func listSectionSpacing(_ spacing: ListSectionSpacing) -> some View {
        stubView()
    }

    @available(*, unavailable)
    /* @inlinable */ nonisolated public func listSectionSpacing(_ spacing: CGFloat) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func swipeActions<T>(edge: HorizontalEdge = .trailing, allowsFullSwipe: Bool = true, @ViewBuilder content: () -> T) -> some View where T : View {
        stubView()
    }
}

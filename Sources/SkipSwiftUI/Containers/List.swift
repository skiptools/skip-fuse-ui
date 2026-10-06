// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipBridge
import SkipUI

public struct List<SelectionValue, Content> where SelectionValue : Hashable, Content : View {
    private let content: Content
    private var getSelection: (() -> Any?)? = nil
    private var setSelection: ((Any?) -> Void)? = nil

    public init(selection: Binding<Set<SelectionValue>>?, @ViewBuilder content: () -> Content) {
        self.content = content()
        bindSelection(selection)
    }

    public init(selection: Binding<SelectionValue?>?, @ViewBuilder content: () -> Content) {
        self.content = content()
        bindSelection(selection)
    }

    /// Bridge a `Set` selection as a `Set` of row tags.
    private mutating func bindSelection(_ selection: Binding<Set<SelectionValue>>?) {
        guard let selection else {
            return
        }
        getSelection = { Set(selection.wrappedValue.map { Java_swiftHashable(for: $0) }) }
        setSelection = { selection.wrappedValue = Java_bridgedTagValues($0) }
    }

    /// Bridge a single selection as its row tag.
    private mutating func bindSelection(_ selection: Binding<SelectionValue?>?) {
        guard let selection else {
            return
        }
        getSelection = { selection.wrappedValue.map { Java_swiftHashable(for: $0) } }
        setSelection = { selection.wrappedValue = Java_bridgedTagValue($0) }
    }
}

/// Unwrap a row tag bridged back from Compose.
func Java_bridgedTagValue<T>(_ tag: Any?) -> T? {
    let base = (tag as? AnyHashable)?.base ?? tag
    return (base as? SwiftHashable)?.base as? T ?? base as? T
}

/// Unwrap a `Set` of row tags bridged back from Compose.
func Java_bridgedTagValues<T>(_ tags: Any?) -> Set<T> where T : Hashable {
    let tags = tags as? Set<AnyHashable> ?? Set(tags as? [AnyHashable] ?? [])
    return Set(tags.compactMap { Java_bridgedTagValue($0) })
}

extension List : View {
    public typealias body = Never
}

extension List : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.List(bridgedContent: content.Java_viewOrEmpty, getSelection: getSelection, setSelection: setSelection)
    }
}

extension List {
    public init<Data, RowContent>(_ data: Data, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        self.init(selection: selection) { ForEach(data, content: rowContent) }
    }

    public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        self.init(selection: selection) { OutlineGroup(data, children: children, content: rowContent) }
    }

    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        self.init(selection: selection) { ForEach(data, id: id, content: rowContent) }
    }

    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        self.init(selection: selection) { OutlineGroup(data, id: id, children: children, content: rowContent) }
    }

    public init<RowContent>(_ data: Range<Int>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>, RowContent : View {
        self.init(selection: selection) { ForEach(data) { index in HStack { rowContent(index) } } }
    }

    public init<Data, RowContent>(_ data: Data, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        self.init(selection: selection) { ForEach(data, content: rowContent) }
    }

    public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        self.init(selection: selection) { OutlineGroup(data, children: children, content: rowContent) }
    }

    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        self.init(selection: selection) { ForEach(data, id: id, content: rowContent) }
    }

    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        self.init(selection: selection) { OutlineGroup(data, id: id, children: children, content: rowContent) }
    }

    public init<RowContent>(_ data: Range<Int>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, RowContent>, RowContent : View {
        self.init(selection: selection) { ForEach(data, content: rowContent) }
    }
}

extension List where SelectionValue == Never {
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public init<Data, RowContent>(_ data: Data, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        self.content = ForEach(data, content: rowContent)
    }

    public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        self.content = OutlineGroup(data, children: children, content: rowContent)
    }

    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        self.content = ForEach(data, id: id, content: rowContent)
    }

    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        self.content = OutlineGroup(data, id: id, children: children, content: rowContent)
    }

    public init<RowContent>(_ data: Range<Int>, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, RowContent>, RowContent : View {
        self.content = ForEach(data, content: rowContent)
    }
}

extension List {
    @available(*, unavailable)
    public init<Data, RowContent>(_ data: Binding<Data>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable {
        fatalError()
    }

    @available(*, unavailable)
    public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable {
        fatalError()
    }

    @available(*, unavailable)
    public init<Data, RowContent>(_ data: Binding<Data>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable {
        fatalError()
    }

    @available(*, unavailable)
    public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable {
        fatalError()
    }
}

extension List where SelectionValue == Never {
    public init<Data, RowContent>(_ data: Binding<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable {
        self.content = ForEach(data, content: rowContent)
    }

    public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable {
        self.content = ForEach(data, id: id, content: rowContent)
    }
}

extension List {
    @available(*, unavailable)
    public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        fatalError()
    }

    @available(*, unavailable)
    public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        fatalError()
    }

    @available(*, unavailable)
    public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        fatalError()
    }

    @available(*, unavailable)
    public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        fatalError()
    }
}

extension List where SelectionValue == Never {
    @available(*, unavailable)
    public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        fatalError()
    }

    @available(*, unavailable)
    public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, */ Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        fatalError()
    }
}

extension List {
    @available(*, unavailable)
    public init<Data, RowContent>(_ data: Binding<Data>, editActions: Any /* EditActions<Data> */, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, */ Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable {
        fatalError()
    }

    @available(*, unavailable)
    public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: Any /* EditActions<Data> */, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, */ Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable {
        fatalError()
    }
}

extension List {
    @available(*, unavailable)
    public init<Data, RowContent>(_ data: Binding<Data>, editActions: Any /* EditActions<Data> */, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, */ Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable {
        fatalError()
    }

    @available(*, unavailable)
    public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: Any /* EditActions<Data> */, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where /* Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, */ Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable {
        fatalError()
    }
}

extension List where SelectionValue == Never {
//    public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable
    public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, Data : RangeReplaceableCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable {
        self.content = ForEach(data, editActions: editActions, content: rowContent)
    }

//    public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable
    public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, Data : RangeReplaceableCollection, RowContent : View, Data.Index : Hashable {
        self.content = ForEach(data, id: id, editActions: editActions, content: rowContent)
    }
}

public struct ListSectionSpacing : Sendable {
    let spacing: CGFloat? // nil for the default

    public static let `default` = ListSectionSpacing(spacing: nil)

    public static let compact = ListSectionSpacing(spacing: 8.0)

    public static func custom(_ spacing: CGFloat) -> ListSectionSpacing {
        return ListSectionSpacing(spacing: spacing)
    }
}

public struct ListItemTint : Sendable {
    let color: Color?

    public static func fixed(_ tint: Color) -> ListItemTint {
        return ListItemTint(color: tint)
    }

    public static func preferred(_ tint: Color) -> ListItemTint {
        return ListItemTint(color: tint)
    }

    public static let monochrome = ListItemTint(color: .secondary)
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
    public init() {
    }

    public let identifier = 1 // For bridging
}

extension ListStyle where Self == SidebarListStyle {
    public static var sidebar: SidebarListStyle {
        return SidebarListStyle()
    }
}

public struct InsetGroupedListStyle : ListStyle {
    public init() {
    }

    public let identifier = 2 // For bridging
}

extension ListStyle where Self == InsetGroupedListStyle {
    public static var insetGrouped: InsetGroupedListStyle {
        return InsetGroupedListStyle()
    }
}

public struct GroupedListStyle : ListStyle {
    public init() {
    }

    public let identifier = 3 // For bridging
}

extension ListStyle where Self == GroupedListStyle {
    public static var grouped: GroupedListStyle {
        return GroupedListStyle()
    }
}

public struct InsetListStyle : ListStyle {
    public init() {
    }

    /// - Note: Alternating row backgrounds are macOS-only and ignored.
    public init(alternatesRowBackgrounds: Bool) {
    }

    public let identifier = 4 // For bridging
}

extension ListStyle where Self == InsetListStyle {
    public static var inset: InsetListStyle {
        return InsetListStyle()
    }

    public static func inset(alternatesRowBackgrounds: Bool) -> InsetListStyle {
        return InsetListStyle(alternatesRowBackgrounds: alternatesRowBackgrounds)
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

    nonisolated public func listRowSeparatorTint(_ color: Color?, edges: VerticalEdge.Set = .all) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listRowSeparatorTint(color?.Java_view as? SkipUI.Color, bridgedEdges: Int(edges.rawValue))
        }
    }

    nonisolated public func listSectionSeparator(_ visibility: Visibility, edges: VerticalEdge.Set = .all) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listSectionSeparator(bridgedVisibility: visibility.rawValue, bridgedEdges: Int(edges.rawValue))
        }
    }

    nonisolated public func listSectionSeparatorTint(_ color: Color?, edges: VerticalEdge.Set = .all) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listSectionSeparatorTint(color?.Java_view as? SkipUI.Color, bridgedEdges: Int(edges.rawValue))
        }
    }

    nonisolated public func listSectionIndexVisibility(_ visibility: Visibility) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listSectionIndexVisibility(bridgedVisibility: visibility.rawValue)
        }
    }

    nonisolated public func sectionIndexLabel(_ label: Text?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.sectionIndexLabel(label?.Java_view as? SkipUI.Text)
        }
    }

    nonisolated public func sectionIndexLabel(_ label: LocalizedStringKey?) -> some View {
        return sectionIndexLabel(label.map { Text($0) })
    }

    @_disfavoredOverload nonisolated public func sectionIndexLabel<S>(_ label: S?) -> some View where S : StringProtocol {
        return sectionIndexLabel(label.map { Text($0) })
    }

    nonisolated public func listStyle<S>(_ style: S) -> some View where S : ListStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listStyle(bridgedStyle: style.identifier)
        }
    }

    /* @inlinable */ nonisolated public func listItemTint(_ tint: ListItemTint?) -> some View {
        return listItemTint(tint?.color)
    }

    /* @inlinable */ nonisolated public func listItemTint(_ tint: Color?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listItemTint(tint?.Java_view as? SkipUI.Color)
        }
    }

    /* @inlinable */ nonisolated public func listRowInsets(_ insets: EdgeInsets?) -> some View {
        return ModifierView(target: self) {
            // nil keeps the default insets
            guard let insets else {
                return $0.Java_viewOrEmpty
            }
            return $0.Java_viewOrEmpty.listRowInsets(top: insets.top, leading: insets.leading, bottom: insets.bottom, trailing: insets.trailing)
        }
    }

    /* @inlinable */ nonisolated public func listRowSpacing(_ spacing: CGFloat?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listRowSpacing(spacing)
        }
    }

    /* @inlinable */ nonisolated public func listSectionSpacing(_ spacing: ListSectionSpacing) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listSectionSpacingValue(spacing.spacing)
        }
    }

    /* @inlinable */ nonisolated public func listSectionSpacing(_ spacing: CGFloat) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.listSectionSpacingValue(spacing)
        }
    }

    nonisolated public func swipeActions<T>(edge: HorizontalEdge = .trailing, allowsFullSwipe: Bool = true, @ViewBuilder content: () -> T) -> some View where T : View {
        let actions = content()
        return ModifierView(target: self) {
            return $0.Java_viewOrEmpty.swipeActions(bridgedEdge: Int(edge.rawValue), allowsFullSwipe: allowsFullSwipe, bridgedActions: actions.Java_viewOrEmpty)
        }
    }
}

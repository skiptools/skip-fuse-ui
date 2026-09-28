// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipFuse
import SkipUI

/// Computes rows and disclosure groups on demand from tree-structured data; a `List` expands them into indented rows.
public struct OutlineGroup<Data, ID, Parent, Leaf, Subgroup> where Data : RandomAccessCollection, ID : Hashable {
    private let roots: [Data.Element]
    private let id: (Data.Element) -> ID
    private let children: (Data.Element) -> Data?
    private let content: (Data.Element) -> Leaf
}

extension OutlineGroup where ID == Data.Element.ID, Parent : View, Parent == Leaf, Subgroup == DisclosureGroup<Parent, OutlineSubgroupChildren>, Data.Element : Identifiable {
    public init<DataElement>(_ root: DataElement, children: KeyPath<DataElement, Data?>, @ViewBuilder content: @escaping (DataElement) -> Leaf) where ID == DataElement.ID, DataElement : Identifiable, DataElement == Data.Element {
        self.init(roots: [root], id: { $0.id }, children: { $0[keyPath: children] }, content: content)
    }

    public init<DataElement>(_ data: Data, children: KeyPath<DataElement, Data?>, @ViewBuilder content: @escaping (DataElement) -> Leaf) where ID == DataElement.ID, DataElement : Identifiable, DataElement == Data.Element {
        self.init(roots: Array(data), id: { $0.id }, children: { $0[keyPath: children] }, content: content)
    }
}

extension OutlineGroup where Parent : View, Parent == Leaf, Subgroup == DisclosureGroup<Parent, OutlineSubgroupChildren> {
    public init<DataElement>(_ root: DataElement, id: KeyPath<DataElement, ID>, children: KeyPath<DataElement, Data?>, @ViewBuilder content: @escaping (DataElement) -> Leaf) where DataElement == Data.Element {
        self.init(roots: [root], id: { $0[keyPath: id] }, children: { $0[keyPath: children] }, content: content)
    }

    public init<DataElement>(_ data: Data, id: KeyPath<DataElement, ID>, children: KeyPath<DataElement, Data?>, @ViewBuilder content: @escaping (DataElement) -> Leaf) where DataElement == Data.Element {
        self.init(roots: Array(data), id: { $0[keyPath: id] }, children: { $0[keyPath: children] }, content: content)
    }
}

extension OutlineGroup : View where Parent : View, Leaf : View, Subgroup : View {
    public typealias Body = Never
}

extension OutlineGroup : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        // Nodes cross the bridge as index paths, resolved here against the native data
        return SkipUI.OutlineGroup(bridgedRootCount: roots.count, childCount: { path in
            return children(element(at: path)).map { $0.count }
        }, identifier: { path in
            return Java_swiftHashable(for: id(element(at: path)))
        }, bridgedContent: { path in
            return (content(element(at: path)) as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
        })
    }

    private func element(at path: [Int]) -> Data.Element {
        var element = roots[path[0]]
        for index in path.dropFirst() {
            let subgroup = children(element)!
            element = subgroup[subgroup.index(subgroup.startIndex, offsetBy: index)]
        }
        return element
    }
}

/// The children of an outline group's subgroup.
public struct OutlineSubgroupChildren : View {
    public typealias Body = Never
}

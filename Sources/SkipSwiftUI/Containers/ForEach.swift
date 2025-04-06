// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipBridge
import SkipUI

public struct ForEach<Data, ID, Content> : ForEachProtocol where Data : RandomAccessCollection, ID : Hashable {
    public let data: Data
    public let content : (Data.Element) -> Content
    private let id: ((Data.Element) -> SwiftHashable)?

    var onDelete: ((IndexSet) -> Void)?
    var onMove: ((IndexSet, Int) -> Void)?
}

extension ForEach : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        //~~~
        logger.error("Java_view WITH START: \(data.startIndex as! Int), END: \(data.endIndex as! Int)")
        let indexedIdentifier: ((Int) -> SwiftHashable)?
        if let id {
            indexedIdentifier = { Java_swiftHashable(for: id(data[$0 as! Data.Index])) }
        } else {
            indexedIdentifier = nil
        }
        var forEach = SkipUI.ForEach(startIndex: { data.startIndex as! Int }, endIndex: { data.endIndex as! Int }, identifier: indexedIdentifier, bridgedContent: {
            let view = content(data[$0 as! Data.Index])
            return (view as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
        })
        if let onDelete {
            forEach = forEach.onDeleteArray(bridgedAction: { onDelete(IndexSet($0)) })
        }
        if let onMove {
            forEach = forEach.onMoveArray(bridgedAction: { onMove(IndexSet($0), $1) })
        }
        return forEach
    }
}

protocol ForEachProtocol {
    var onDelete: ((IndexSet) -> Void)? { get set }
    var onMove: ((IndexSet, Int) -> Void)? { get set }
}

extension ForEach : DynamicViewContent where Content : View {
}

extension ForEach : View where Content : View {
    public typealias Body = Never
}

extension ForEach where ID == Data.Element.ID, Content : View, Data.Element : Identifiable {
    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
        self.id = { Java_swiftHashable(for: $0.id) }
        self.onDelete = nil
        self.onMove = nil
    }
}

extension ForEach where Content : View {
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
        self.id = { Java_swiftHashable(for: $0[keyPath: id]) }
        self.onDelete = nil
        self.onMove = nil
    }
}

extension ForEach where Content : View {
    public init<C>(_ data: Binding<C>, @ViewBuilder content: @escaping (Binding<C.Element>) -> Content) where Data == LazyMapSequence<C.Indices, (C.Index, ID)>, ID == C.Element.ID, C : MutableCollection, C : RandomAccessCollection, C.Element : Identifiable, C.Index : Hashable {
        self.data = data.indices.lazy.map { ($0, data.wrappedValue[$0].id) }
        self.content = { content(data[$0.0]) }
        self.id = { Java_swiftHashable(for: $0.1) }
        self.onDelete = nil
        self.onMove = nil
    }

    public init<C>(_ data: Binding<C>, id: KeyPath<C.Element, ID>, @ViewBuilder content: @escaping (Binding<C.Element>) -> Content) where Data == LazyMapSequence<C.Indices, (C.Index, ID)>, C : MutableCollection, C : RandomAccessCollection, C.Index : Hashable {
        self.data = data.indices.lazy.map { ($0, data.wrappedValue[$0][keyPath: id]) }
        self.content = { content(data[$0.0]) }
        self.id = { Java_swiftHashable(for: $0.1) }
        self.onDelete = nil
        self.onMove = nil
    }
}

extension ForEach where Data == Range<Int>, ID == Int, Content : View {
    public init(_ data: Range<Int>, @ViewBuilder content: @escaping (Int) -> Content) {
        self.data = data
        self.content = content
        self.id = nil
        self.onDelete = nil
        self.onMove = nil
    }
}

extension ForEach {
//    public init<C, R>(_ data: Binding<C>, editActions: EditActions<C>, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, ID == C.Element.ID, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Element : Identifiable, C.Index : Hashable
    public init<C>(_ data: Binding<C>, editActions: EditActions<C>, @ViewBuilder content: @escaping (Binding<C.Element>) -> Content) where Data == IndexedIdentifierCollection<C, ID>, ID == C.Element.ID, C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, C.Element : Identifiable, C.Index : Hashable {
        self.data = IndexedIdentifierCollection(base: data, id: { $0.id })
        self.content = { content(data[$0.index]) }
        self.id = { Java_swiftHashable(for: $0.identifier) }
        if editActions.contains(.delete) {
            self.onDelete = { data.wrappedValue.remove(atOffsets: $0) }
        } else {
            self.onDelete = nil
        }
        if editActions.contains(.move) {
            self.onMove = { data.wrappedValue.move(fromOffsets: $0, toOffset: $1) }
        } else {
            self.onMove = nil
        }
    }

//    public init<C, R>(_ data: Binding<C>, id: KeyPath<C.Element, ID>, editActions: EditActions<C>, @ViewBuilder content: @escaping (Binding<C.Element>) -> R) where Data == IndexedIdentifierCollection<C, ID>, Content == EditableCollectionContent<R, C>, C : MutableCollection, C : RandomAccessCollection, R : View, C.Index : Hashable
    public init<C>(_ data: Binding<C>, id: KeyPath<C.Element, ID>, editActions: EditActions<C>, @ViewBuilder content: @escaping (Binding<C.Element>) -> Content) where Data == IndexedIdentifierCollection<C, ID>, C : MutableCollection, C : RandomAccessCollection, C : RangeReplaceableCollection, C.Index : Hashable {
        self.data = IndexedIdentifierCollection(base: data, id: { $0[keyPath: id] })
        self.content = { content(data[$0.index]) }
        self.id = { Java_swiftHashable(for: $0.identifier) }
        if editActions.contains(.delete) {
            self.onDelete = { data.wrappedValue.remove(atOffsets: $0) }
        } else {
            self.onDelete = nil
        }
        if editActions.contains(.move) {
            self.onMove = { data.wrappedValue.move(fromOffsets: $0, toOffset: $1) }
        } else {
            self.onMove = nil
        }
    }
}

extension DynamicViewContent {
    /* @inlinable nonisolated */ public func onMove(perform action: ((IndexSet, Int) -> Void)?) -> some DynamicViewContent {
        if var forEach = self as? any ForEachProtocol {
            forEach.onMove = action
            return forEach as! Self
        } else {
            return self
        }
    }
}

extension View {
    /* @inlinable nonisolated */ public func moveDisabled(_ isDisabled: Bool) -> some View {
        return ModifierView(target: self) {
            return $0.Java_viewOrEmpty.moveDisabled(isDisabled)
        }
    }
}

extension DynamicViewContent {
    /* @inlinable nonisolated */ public func onDelete(perform action: ((IndexSet) -> Void)?) -> some DynamicViewContent {
        if var forEach = self as? any ForEachProtocol {
            forEach.onDelete = action
            return forEach as! Self
        } else {
            return self
        }
    }
}

extension View {
    /* @inlinable nonisolated */ public func deleteDisabled(_ isDisabled: Bool) -> some View {
        return ModifierView(target: self) {
            return $0.Java_viewOrEmpty.deleteDisabled(isDisabled)
        }
    }
}

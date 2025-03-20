// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

public struct ForEach<Data, ID, Content> where Data : RandomAccessCollection, ID : Hashable {
    public let data: Data
    public let content : (Data.Element) -> Content
    private let id: (Data.Element) -> String
}

extension ForEach : SkipUIBridging {
}

extension ForEach {
    public var Java_view: any SkipUI.View {
        let indexedIdentifier: (Int) -> String = { Java_composeBundleString(for: id(data[$0 as! Data.Index])) }
        return SkipUI.ForEach(startIndex: data.startIndex as! Int, endIndex: data.endIndex as! Int, identifier: indexedIdentifier, bridgedContent: {
            let view = content(data[$0 as! Data.Index])
            return (view as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
        })
    }
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
        self.id = { Java_composeBundleString(for: $0.id) }
    }
}

extension ForEach where Content : View {
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
        self.id = { Java_composeBundleString(for: $0[keyPath: id]) }
    }
}

extension ForEach where Content : View {
    public init<C>(_ data: Binding<C>, @ViewBuilder content: @escaping (Binding<C.Element>) -> Content) where Data == LazyMapSequence<C.Indices, (C.Index, ID)>, ID == C.Element.ID, C : MutableCollection, C : RandomAccessCollection, C.Element : Identifiable, C.Index : Hashable {
        self.data = data.indices.lazy.map { ($0, data.wrappedValue[$0].id) }
        self.content = { content(data[$0.0]) }
        self.id = { Java_composeBundleString(for: $0.1) }
    }

    public init<C>(_ data: Binding<C>, id: KeyPath<C.Element, ID>, @ViewBuilder content: @escaping (Binding<C.Element>) -> Content) where Data == LazyMapSequence<C.Indices, (C.Index, ID)>, C : MutableCollection, C : RandomAccessCollection, C.Index : Hashable {
        self.data = data.indices.lazy.map { ($0, data.wrappedValue[$0][keyPath: id]) }
        self.content = { content(data[$0.0]) }
        self.id = { Java_composeBundleString(for: $0.1) }
    }
}

extension ForEach where Data == Range<Int>, ID == Int, Content : View {
    public init(_ data: Range<Int>, @ViewBuilder content: @escaping (Int) -> Content) {
        self.data = data
        self.content = content
        self.id = { Java_composeBundleString(for: $0) }
    }
}

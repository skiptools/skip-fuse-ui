// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public struct IndexedIdentifierCollection<Base, ID> : Collection where Base : Collection, ID : Hashable {
    let base: Binding<Base>
    let id: (Base.Element) -> ID

    init(base: Binding<Base>, id: @escaping (Base.Element) -> ID) {
        self.base = base
        self.id = id
    }

    public struct Element {
        let index: Base.Index
        let identifier: ID
    }

    public typealias Index = Base.Index

    public var startIndex: IndexedIdentifierCollection<Base, ID>.Index {
        return base.wrappedValue.startIndex
    }

    public var endIndex: IndexedIdentifierCollection<Base, ID>.Index {
        return base.wrappedValue.endIndex
    }

    public subscript(position: IndexedIdentifierCollection<Base, ID>.Index) -> IndexedIdentifierCollection<Base, ID>.Element {
        return Element(index: position, identifier: id(base.wrappedValue[position]))
    }

    public func index(after i: IndexedIdentifierCollection<Base, ID>.Index) -> IndexedIdentifierCollection<Base, ID>.Index {
        return base.wrappedValue.index(after: i)
    }
}

extension IndexedIdentifierCollection : BidirectionalCollection where Base : BidirectionalCollection {
    public func index(before i: IndexedIdentifierCollection<Base, ID>.Index) -> IndexedIdentifierCollection<Base, ID>.Index {
        return base.wrappedValue.index(before: i)
    }
}

extension IndexedIdentifierCollection : RandomAccessCollection where Base : RandomAccessCollection {
}

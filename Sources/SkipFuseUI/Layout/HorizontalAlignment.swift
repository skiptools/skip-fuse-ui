// Copyright 2025 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public struct HorizontalAlignment : Equatable /*, Sendable */ {
    let key: String

    init(key: String) {
        self.key = key
    }

    @available(*, unavailable)
    public init(_ id: Any /* AlignmentID.Type */) {
        key = ""
    }

    @available(*, unavailable)
    public func combineExplicit(_ values: any Sequence<CGFloat?>) -> CGFloat? {
        fatalError()
    }

    // NOTE: These keys must be the same as those in SkipFuseUI.HorizontalAlignment
    public static let center: HorizontalAlignment = HorizontalAlignment(key: "center")
    public static let leading: HorizontalAlignment = HorizontalAlignment(key: "leading")
    public static let trailing: HorizontalAlignment = HorizontalAlignment(key: "trailing")
    public static let listRowSeparatorLeading = HorizontalAlignment(key: "listRowSeparatorLeading")
    public static let listRowSeparatorTrailing = HorizontalAlignment(key: "listRowSeparatorTrailing")
}

// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif

@frozen public struct VerticalAlignment : Equatable, Sendable {
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

    public static let center = VerticalAlignment(key: "center")
    public static let top = VerticalAlignment(key: "top")
    public static let bottom = VerticalAlignment(key: "bottom")
    public static let firstTextBaseline = VerticalAlignment(key: "firstTextBaseline")
    public static let lastTextBaseline = VerticalAlignment(key: "lastTextBaseline")
}

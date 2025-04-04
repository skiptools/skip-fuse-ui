// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@frozen public struct Alignment : Equatable /*, Sendable */ {
    public var horizontal: HorizontalAlignment
    public var vertical: VerticalAlignment

    public static let center = Alignment(horizontal: .center, vertical: .center)
    public static let leading = Alignment(horizontal: .leading, vertical: .center)
    public static let trailing = Alignment(horizontal: .trailing, vertical: .center)
    public static let top = Alignment(horizontal: .center, vertical: .top)
    public static let bottom = Alignment(horizontal: .center, vertical: .bottom)
    public static let topLeading = Alignment(horizontal: .leading, vertical: .top)
    public static let topTrailing = Alignment(horizontal: .trailing, vertical: .top)
    public static let bottomLeading = Alignment(horizontal: .leading, vertical: .bottom)
    public static let bottomTrailing = Alignment(horizontal: .trailing, vertical: .bottom)

    public static var centerFirstTextBaseline = Alignment(horizontal: .center, vertical: .firstTextBaseline)
    public static var centerLastTextBaseline = Alignment(horizontal: .center, vertical: .lastTextBaseline)
    public static var leadingFirstTextBaseline = Alignment(horizontal: .leading, vertical: .firstTextBaseline)
    public static var leadingLastTextBaseline = Alignment(horizontal: .leading, vertical: .lastTextBaseline)
    public static var trailingFirstTextBaseline = Alignment(horizontal: .trailing, vertical: .firstTextBaseline)
    public static var trailingLastTextBaseline = Alignment(horizontal: .trailing, vertical: .lastTextBaseline)
}

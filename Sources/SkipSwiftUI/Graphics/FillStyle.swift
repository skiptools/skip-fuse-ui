// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@frozen public struct FillStyle : Equatable /*, BitwiseCopyable, Sendable */ {
    public var isEOFilled: Bool
    public var isAntialiased: Bool

    @inlinable public init(eoFill: Bool = false, antialiased: Bool = true) {
        self.isEOFilled = eoFill
        self.isAntialiased = antialiased
    }
}

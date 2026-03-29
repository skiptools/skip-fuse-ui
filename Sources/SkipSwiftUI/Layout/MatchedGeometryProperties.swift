// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0

@frozen public struct MatchedGeometryProperties : OptionSet {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static let position = MatchedGeometryProperties(rawValue: 1 << 0)
    public static let size = MatchedGeometryProperties(rawValue: 1 << 1)
    public static let frame = MatchedGeometryProperties(rawValue: 1 << 2)
}

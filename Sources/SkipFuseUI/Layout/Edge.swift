// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@frozen public enum Edge : Int8, Hashable, CaseIterable /*, BitwiseCopyable, Sendable */ {
    case top = 1 // For bridging
    case leading = 2 // For bridging
    case bottom = 4 // For bridging
    case trailing = 8 // For bridging

    @frozen public struct Set : OptionSet /*, BitwiseCopyable, Sendable */ {
        public let rawValue: Int8

        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }

        public static let top = Edge.Set(rawValue: Edge.top.rawValue)
        public static let leading = Edge.Set(rawValue: Edge.leading.rawValue)
        public static let bottom = Edge.Set(rawValue: Edge.bottom.rawValue)
        public static let trailing = Edge.Set(rawValue: Edge.trailing.rawValue)

        public static let all: Edge.Set = [.top, .leading, .bottom, .trailing]
        public static let horizontal: Edge.Set = [.leading, .trailing]
        public static let vertical: Edge.Set = [.top, .bottom]

        public init(_ e: Edge) {
            self.init(rawValue: e.rawValue)
        }
    }
}

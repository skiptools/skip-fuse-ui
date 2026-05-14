// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

@frozen public enum HorizontalEdge : Int8, Hashable, CaseIterable, BitwiseCopyable, Sendable {
    case leading = 1 // For bridging
    case trailing = 2 // For bridging

    @frozen public struct Set : OptionSet, BitwiseCopyable, Sendable {
        public let rawValue: Int8

        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }

        public static let leading = HorizontalEdge.Set(rawValue: HorizontalEdge.leading.rawValue)
        public static let trailing = HorizontalEdge.Set(rawValue: HorizontalEdge.trailing.rawValue)

        public static let all: HorizontalEdge.Set = [.leading, .trailing]

        public init(_ e: HorizontalEdge) {
            self.init(rawValue: e.rawValue)
        }
    }
}


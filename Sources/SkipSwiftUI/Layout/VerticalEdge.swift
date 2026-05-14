// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

@frozen public enum VerticalEdge : Int8, Hashable, CaseIterable, BitwiseCopyable, Sendable {
    case top = 1 // For bridging
    case bottom = 2 // For bridging

    @frozen public struct Set : OptionSet, BitwiseCopyable, Sendable {
        public let rawValue: Int8

        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }

        public static let top = VerticalEdge.Set(rawValue: VerticalEdge.top.rawValue)
        public static let bottom = VerticalEdge.Set(rawValue: VerticalEdge.bottom.rawValue)

        public static let all: VerticalEdge.Set = [.top, .bottom]

        public init(_ e: VerticalEdge) {
            self.init(rawValue: e.rawValue)
        }
    }
}


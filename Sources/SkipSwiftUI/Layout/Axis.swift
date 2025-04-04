// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@frozen public enum Axis : Int8, CaseIterable /*, BitwiseCopyable, Sendable */ {
    case horizontal = 1 // For bridging
    case vertical = 2 // For bridging

    @frozen public struct Set : OptionSet /*, BitwiseCopyable, Sendable */ {
        public let rawValue: Int8

        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }

        public static let horizontal = Axis.Set(rawValue: Axis.horizontal.rawValue)
        public static let vertical = Axis.Set(rawValue: Axis.vertical.rawValue)
    }
}

extension Axis : CustomStringConvertible {
    public var description: String {
        switch self {
        case .horizontal:
            return "horizontal"
        case .vertical:
            return "vertical"
        }
    }
}

// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@frozen public struct SafeAreaRegions : OptionSet /*, BitwiseCopyable, Sendable */ {
    public let rawValue: UInt

    @inlinable public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static let container = SafeAreaRegions(rawValue: 1 << 0)

    public static let keyboard = SafeAreaRegions(rawValue: 1 << 1)

    public static let all: SafeAreaRegions = [.container, .keyboard]
}

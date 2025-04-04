// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public struct RedactionReasons : OptionSet /* , Sendable */ {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let placeholder = RedactionReasons(rawValue: 1 << 0)
    public static let privacy = RedactionReasons(rawValue: 1 << 1)
    public static let invalidated = RedactionReasons(rawValue: 1 << 2)
}

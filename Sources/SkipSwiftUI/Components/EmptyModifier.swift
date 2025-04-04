// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

/* @MainActor */ @frozen /* @preconcurrency */ public struct EmptyModifier : ViewModifier /*, BitwiseCopyable, Sendable */ {
    /* @MainActor @preconcurrency */ public static let identity = EmptyModifier()

    public typealias Body = Never
    public typealias Content = Never

    @inlinable /* nonisolated */ public init() {
    }
}

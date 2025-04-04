// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public struct SpringLoadingBehavior : Hashable /*, Sendable */ {
    public static let automatic = SpringLoadingBehavior()

    public static let enabled = SpringLoadingBehavior()

    public static let disabled = SpringLoadingBehavior()
}

extension View {
    @available(*, unavailable)
    /* nonisolated */ public func springLoadingBehavior(_ behavior: SpringLoadingBehavior) -> some View {
        stubView()
    }
}

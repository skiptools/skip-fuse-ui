// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

public struct SpringLoadingBehavior : Hashable, Sendable {
    public static let automatic = SpringLoadingBehavior()

    public static let enabled = SpringLoadingBehavior()

    public static let disabled = SpringLoadingBehavior()
}

extension View {
    @available(*, unavailable)
    nonisolated public func springLoadingBehavior(_ behavior: SpringLoadingBehavior) -> some View {
        stubView()
    }
}

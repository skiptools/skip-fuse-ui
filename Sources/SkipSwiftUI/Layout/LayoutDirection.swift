// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public enum LayoutDirection : Int, Hashable, CaseIterable /*, Sendable */ {
    case leftToRight = 0 // For bridging
    case rightToLeft = 1 // For bridging
}

public enum LayoutDirectionBehavior : Hashable /*, Sendable */ {
    case fixed
    case mirrors(in: LayoutDirection)

    public static var mirrors: LayoutDirectionBehavior {
        return .mirrors(in: .leftToRight)
    }
}

extension View {
    @available(*, unavailable)
    /* @inlinable nonisolated */ public func layoutDirectionBehavior(_ behavior: LayoutDirectionBehavior) -> some View {
        stubView()
    }
}

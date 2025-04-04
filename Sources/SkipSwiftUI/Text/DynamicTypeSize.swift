// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public enum DynamicTypeSize : Hashable, Comparable, CaseIterable /* , Sendable */ {
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case xxLarge
    case xxxLarge
    case accessibility1
    case accessibility2
    case accessibility3
    case accessibility4
    case accessibility5

    public var isAccessibilitySize: Bool {
        switch self {
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            return true
        default:
            return false
        }
    }
}

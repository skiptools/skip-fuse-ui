// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@frozen public enum Visibility : Int, Hashable, CaseIterable /*, BitwiseCopyable, Sendable */ {
    case automatic = 0 // For bridging
    case visible = 1 // For bridging
    case hidden = 2 // For bridging
}

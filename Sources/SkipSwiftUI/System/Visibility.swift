// Copyright 2025–2026 Skip

@frozen public enum Visibility : Int, Hashable, CaseIterable, BitwiseCopyable, Sendable {
    case automatic = 0 // For bridging
    case visible = 1 // For bridging
    case hidden = 2 // For bridging
}

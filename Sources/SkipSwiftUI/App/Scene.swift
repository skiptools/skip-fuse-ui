// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0

public enum ScenePhase : Int, Comparable, Hashable, Sendable {
    case background = 1 // For bridging
    case inactive = 2 // For bridging
    case active = 3 // For bridging

    public static func < (a: ScenePhase, b: ScenePhase) -> Bool {
        return a.rawValue < b.rawValue
    }
}

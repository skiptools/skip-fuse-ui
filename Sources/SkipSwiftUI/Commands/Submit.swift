// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public struct SubmitLabel /* : Sendable */ {
    let identifier: Int

    public static var done: SubmitLabel {
        return SubmitLabel(identifier: 0) // For bridging
    }

    public static var go: SubmitLabel {
        return SubmitLabel(identifier: 1) // For bridging
    }

    public static var send: SubmitLabel {
        return SubmitLabel(identifier: 2) // For bridging
    }

    public static var join: SubmitLabel {
        return SubmitLabel(identifier: 3) // For bridging
    }

    public static var route: SubmitLabel {
        return SubmitLabel(identifier: 4) // For bridging
    }

    public static var search: SubmitLabel {
        return SubmitLabel(identifier: 5) // For bridging
    }

    public static var `return`: SubmitLabel {
        return SubmitLabel(identifier: 6) // For bridging
    }

    public static var next: SubmitLabel {
        return SubmitLabel(identifier: 7) // For bridging
    }

    public static var `continue`: SubmitLabel {
        return SubmitLabel(identifier: 8) // For bridging
    }
}

public struct SubmitTriggers : OptionSet /*, Sendable */ {
    public typealias RawValue = Int

    public let rawValue: SubmitTriggers.RawValue

    public init(rawValue: SubmitTriggers.RawValue) {
        self.rawValue = rawValue
    }

    public static let text = SubmitTriggers(rawValue: 1 << 0) // For bridging
    public static let search = SubmitTriggers(rawValue: 1 << 1) // For bridging
}

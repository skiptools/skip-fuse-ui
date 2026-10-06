// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipFuse
import SkipUI

/// A button that toggles the `editMode` environment value.
public struct EditButton : View {
    public init() {
    }

    public typealias Body = Never
}

extension EditButton : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.EditButton()
    }
}

/// The mode of a view whose content the user can edit.
public enum EditMode : Hashable, Sendable {
    case inactive
    case transient
    case active

    public var isEditing: Bool {
        return self != .inactive
    }
}

extension EditMode {
    /// Case index shared with `SkipUI.EditMode`.
    init(bridgedIndex: Int) {
        switch bridgedIndex {
        case 1: self = .transient
        case 2: self = .active
        default: self = .inactive
        }
    }

    var bridgedIndex: Int {
        switch self {
        case .inactive: return 0
        case .transient: return 1
        case .active: return 2
        }
    }
}

public enum Prominence : Hashable, Sendable {
    case standard
    case increased
}

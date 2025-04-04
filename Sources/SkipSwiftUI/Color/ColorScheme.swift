// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

public enum ColorScheme : Int, CaseIterable, Hashable /*, Sendable */ {
    case light = 0 // For bridging
    case dark = 1 // For bridging
}

extension View {
    /* nonisolated */ public func colorScheme(_ colorScheme: ColorScheme) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.colorScheme(bridgedColorScheme: colorScheme.rawValue)
        }
    }

    /* nonisolated */ public func preferredColorScheme(_ colorScheme: ColorScheme?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.preferredColorScheme(bridgedColorScheme: colorScheme?.rawValue)
        }
    }
}

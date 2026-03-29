// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

public enum ColorScheme : Int, CaseIterable, Hashable, Sendable {
    case light = 0 // For bridging
    case dark = 1 // For bridging
}

extension View {
    nonisolated public func colorScheme(_ colorScheme: ColorScheme) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.colorScheme(bridgedColorScheme: colorScheme.rawValue)
        }
    }

    nonisolated public func preferredColorScheme(_ colorScheme: ColorScheme?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.preferredColorScheme(bridgedColorScheme: colorScheme?.rawValue)
        }
    }
}

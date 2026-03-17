// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

extension View {
    /* @inlinable */ nonisolated public func contextMenu<MenuItems>(@ViewBuilder menuItems: () -> MenuItems) -> some View where MenuItems : View {
        let menuItems = menuItems()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.contextMenu(bridgedMenuItems: menuItems.Java_viewOrEmpty)
        }
    }

    /* @inlinable */ nonisolated public func contextMenu<MenuItems, Preview>(@ViewBuilder menuItems: () -> MenuItems, @ViewBuilder preview: () -> Preview) -> some View where MenuItems : View, Preview : View {
        let menuItems = menuItems()
        let preview = preview()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.contextMenu(bridgedMenuItems: menuItems.Java_viewOrEmpty, bridgedPreview: preview.Java_viewOrEmpty)
        }
    }
}

// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

extension View {
    /// A context menu for a `List`'s selected rows, or the pressed row; `primaryAction` runs on tap outside edit mode.
    nonisolated public func contextMenu<I, M>(forSelectionType itemType: I.Type = I.self, @ViewBuilder menu: @escaping (Set<I>) -> M, primaryAction: ((Set<I>) -> Void)? = nil) -> some View where I : Hashable, M : View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.contextMenu(bridgedMenu: { menu(Java_bridgedTagValues($0)).Java_viewOrEmpty }, bridgedPrimaryAction: primaryAction.map { action in { action(Java_bridgedTagValues($0)) } })
        }
    }

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

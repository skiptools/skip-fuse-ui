// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

/// A SwiftUI modifier.
public struct ModifierView<Target> : View where Target : View {
    private let target: UncheckedSendableBox<Target>
    private let modifier: UncheckedSendableBox<(Target) -> any SkipUI.View>

    nonisolated public init(target: Target, modifier: @escaping (Target) -> any SkipUI.View) {
        self.target = UncheckedSendableBox(target)
        self.modifier = UncheckedSendableBox(modifier)
    }

    public typealias Body = Never
}

extension ModifierView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return modifier.wrappedValue(target.wrappedValue)
    }
}

extension ModifierView : DynamicViewContent where Target : DynamicViewContent {
    public var data: Target.Data {
        return target.wrappedValue.data
    }
}

// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipBridge
import SkipUI

/// A SwiftUI modifier.
public struct ModifierView<Target> where Target : View {
    private let target: Target
    private let modifier: (Target) -> any SkipUI.View

    public init(target: Target, modifier: @escaping (Target) -> any SkipUI.View) {
        self.target = target
        self.modifier = modifier
    }
}

extension ModifierView : View {
    public typealias Body = Never
}

extension ModifierView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return modifier(target)
    }
}

extension ModifierView : DynamicViewContent where Target : DynamicViewContent {
    public var data: Target.Data {
        return target.data
    }
}

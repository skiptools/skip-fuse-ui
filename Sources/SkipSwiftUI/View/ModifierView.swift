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

    /// An animatable modifier whose bridged call participates in per-slot animation provenance.
    ///
    /// Captures the provenance read cursor at entry: arguments are evaluated before the
    /// modifier call, so a stamped `@State` read in the caller's value expression has just
    /// recorded the `withAnimation` scope (if any) that changed it. When the Java view is
    /// materialized, the target chain is materialized first — nested animatable modifiers
    /// prime their own provenance and would clobber ours if we primed before them — and the
    /// captured animation is then primed into the Kotlin read cursor right before the bridged
    /// modifier call, where the SkipUI impl's own entry capture consumes it. A nil capture
    /// primes explicitly, making un-animated inputs snap.
    ///
    /// The `modifier` closure receives the already-materialized and primed bridged target.
    public init(animatableTarget target: Target, modifier: @escaping (any SkipUI.View) -> any SkipUI.View) {
        let primedAnimation = StateProvenance.capturePrimedAnimation()
        self.init(target: target) {
            let Java_target = $0.Java_viewOrEmpty
            SkipUI.Animation.primeBridgedProvenance(primedAnimation)
            return modifier(Java_target)
        }
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

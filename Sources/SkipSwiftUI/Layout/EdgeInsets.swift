// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif

@frozen public struct EdgeInsets : Equatable /*, BitwiseCopyable, Sendable */ {
    public var top: CGFloat = 0.0
    public var leading: CGFloat = 0.0
    public var bottom: CGFloat = 0.0
    public var trailing: CGFloat = 0.0

    @inlinable public init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }

    @inlinable public init() {
    }
}

extension EdgeInsets : Animatable {
//    public typealias AnimatableData = AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>>
//    public var animatableData: EdgeInsets.AnimatableData
}

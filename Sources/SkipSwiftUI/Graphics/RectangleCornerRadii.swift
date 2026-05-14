// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif

@frozen public struct RectangleCornerRadii : Equatable, Animatable, BitwiseCopyable, Sendable {
    public var topLeading: CGFloat
    public var bottomLeading: CGFloat
    public var bottomTrailing: CGFloat
    public var topTrailing: CGFloat

    public init(topLeading: CGFloat = 0, bottomLeading: CGFloat = 0, bottomTrailing: CGFloat = 0, topTrailing: CGFloat = 0) {
        self.topLeading = topLeading
        self.bottomLeading = bottomLeading
        self.bottomTrailing = bottomTrailing
        self.topTrailing = topTrailing
    }

//    public typealias AnimatableData = AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>>
//
//    public var animatableData: RectangleCornerRadii.AnimatableData
}

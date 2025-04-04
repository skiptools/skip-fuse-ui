// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif

@frozen public struct StrokeStyle : Equatable /*, Sendable */ {
    public var lineWidth: CGFloat
    public var lineCap: CGLineCap
    public var lineJoin: CGLineJoin
    public var miterLimit: CGFloat
    public var dash: [CGFloat]
    public var dashPhase: CGFloat

    public init(lineWidth: CGFloat = 1, lineCap: CGLineCap = .butt, lineJoin: CGLineJoin = .miter, miterLimit: CGFloat = 10, dash: [CGFloat] = [], dashPhase: CGFloat = 0) {
        self.lineWidth = lineWidth
        self.lineCap = lineCap
        self.lineJoin = lineJoin
        self.miterLimit = miterLimit
        self.dash = dash
        self.dashPhase = dashPhase
    }
}

extension StrokeStyle : Animatable {
//    public typealias AnimatableData = AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>
//
//    public var animatableData: StrokeStyle.AnimatableData
}

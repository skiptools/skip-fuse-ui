// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

@frozen public struct ViewThatFits<Content> where Content: View {
    private let axes: Axis.Set
    private let content: Content

    /* @inlinable */ public init(in axes: Axis.Set = [.horizontal, .vertical], @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.content = content()
    }
}

extension ViewThatFits: View {
    public typealias Body = Never
}

extension ViewThatFits: SkipUIBridging {
    public var Java_view: any SkipUI.View {
        // Use the bridged initializer so compiled Swift can pass SwiftUI content into SkipUI's Kotlin implementation.
        return SkipUI.ViewThatFits(bridgedAxes: Int(axes.rawValue), bridgedContent: content.Java_viewOrEmpty)
    }
}



// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipFuse
import SkipUI

/// A view's size and alignment guides in its own coordinate space.
public struct ViewDimensions : Equatable {
    public let width: CGFloat
    public let height: CGFloat

    public subscript(guide: HorizontalAlignment) -> CGFloat {
        switch guide.key {
        case HorizontalAlignment.center.key: return width / 2.0
        case HorizontalAlignment.trailing.key, HorizontalAlignment.listRowSeparatorTrailing.key: return width
        default: return 0.0
        }
    }

    public subscript(guide: VerticalAlignment) -> CGFloat {
        switch guide.key {
        case VerticalAlignment.center.key: return height / 2.0
        case VerticalAlignment.bottom.key: return height
        default: return 0.0
        }
    }
}

extension View {
    /// - Note: Only `.listRowSeparatorLeading` and `.listRowSeparatorTrailing` affect layout, positioning a `List` row's separator.
    nonisolated public func alignmentGuide(_ g: HorizontalAlignment, computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.alignmentGuide(horizontalAlignmentKey: g.key, bridgedComputeValue: { computeValue(ViewDimensions(width: $0, height: $1)) })
        }
    }
}

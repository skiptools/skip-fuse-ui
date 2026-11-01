// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif

/// A view's measured size and horizontal alignment guides, in points.
public struct ViewDimensions: Equatable, Sendable {
    public let width: CGFloat
    public let height: CGFloat
    let separatorLeading: CGFloat?
    let separatorTrailing: CGFloat?

    public subscript(guide: HorizontalAlignment) -> CGFloat {
        switch guide {
        case .leading: return 0.0
        case .center: return width / 2.0
        case .trailing: return width
        case .listRowSeparatorLeading: return separatorLeading ?? 0.0
        case .listRowSeparatorTrailing: return separatorTrailing ?? width
        default: return 0.0
        }
    }
}

extension View {
    nonisolated public func alignmentGuide(_ g: HorizontalAlignment, computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {
        precondition(g == .listRowSeparatorLeading || g == .listRowSeparatorTrailing, "Only list row separator alignment guides are supported")
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.alignmentGuide(bridgedGuide: g.key, computeValue: { width, height, leading, trailing in
                computeValue(ViewDimensions(width: width, height: height, separatorLeading: leading, separatorTrailing: trailing))
            })
        }
    }
}

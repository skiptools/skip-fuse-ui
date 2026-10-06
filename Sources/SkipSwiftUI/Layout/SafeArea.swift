// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipFuse
import SkipUI

@frozen public struct SafeAreaRegions : OptionSet, BitwiseCopyable, Sendable {
    public let rawValue: UInt

    @inlinable public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static let container = SafeAreaRegions(rawValue: 1 << 0)

    public static let keyboard = SafeAreaRegions(rawValue: 1 << 1)

    public static let all: SafeAreaRegions = [.container, .keyboard]
}

extension View {
    nonisolated public func safeAreaInset<V>(edge: VerticalEdge, alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> V) -> some View where V : View {
        let content = content()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.safeAreaInset(bridgedEdge: Int(edge == .top ? Edge.top.rawValue : Edge.bottom.rawValue), horizontalAlignmentKey: alignment.key, verticalAlignmentKey: VerticalAlignment.center.key, spacing: spacing, bridgedContent: content.Java_viewOrEmpty)
        }
    }

    nonisolated public func safeAreaInset<V>(edge: HorizontalEdge, alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> V) -> some View where V : View {
        let content = content()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.safeAreaInset(bridgedEdge: Int(edge == .leading ? Edge.leading.rawValue : Edge.trailing.rawValue), horizontalAlignmentKey: HorizontalAlignment.center.key, verticalAlignmentKey: alignment.key, spacing: spacing, bridgedContent: content.Java_viewOrEmpty)
        }
    }

    nonisolated public func safeAreaPadding(_ insets: EdgeInsets) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.safeAreaPadding(top: insets.top, leading: insets.leading, bottom: insets.bottom, trailing: insets.trailing)
        }
    }

    nonisolated public func safeAreaPadding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        let length = length ?? 16.0
        return safeAreaPadding(EdgeInsets(top: edges.contains(.top) ? length : 0.0, leading: edges.contains(.leading) ? length : 0.0, bottom: edges.contains(.bottom) ? length : 0.0, trailing: edges.contains(.trailing) ? length : 0.0))
    }

    nonisolated public func safeAreaPadding(_ length: CGFloat) -> some View {
        return safeAreaPadding(.all, length)
    }
}

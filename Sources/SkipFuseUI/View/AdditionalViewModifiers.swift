// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipBridge
import SkipUI

extension View {
    @_disfavoredOverload @inlinable /* nonisolated */ public func background<Background>(_ background: Background, alignment: Alignment = .center) -> some View where Background : View {
        return self.background(alignment: alignment, content: { background })
    }

    /* @inlinable nonisolated */ public func background<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View {
        let bridgedContent = content()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.background(horizontalAlignmentKey: alignment.horizontal.key, verticalAlignmentKey: alignment.vertical.key, bridgedContent: bridgedContent.Java_viewOrEmpty)
        }
    }

    /// - Warning: The second argument here should default to `.all`. Our implementation is not yet sophisticated enough to auto-detect when it is
    ///     against a safe area boundary, so this would cause problems. Therefore we default to `[]` and rely on ther user to specify the edges.
    @inlinable /* nonisolated */ public func background(ignoresSafeAreaEdges edges: Edge.Set = [] /* .all */) -> some View {
        return background(BackgroundStyle(), ignoresSafeAreaEdges: edges)
    }

    /// - Warning: The second argument here should default to `.all`. Our implementation is not yet sophisticated enough to auto-detect when it is
    ///     against a safe area boundary, so this would cause problems. Therefore we default to `[]` and rely on ther user to specify the edges.
    /* @inlinable nonisolated */ public func background<S>(_ style: S, ignoresSafeAreaEdges edges: Edge.Set = [] /* .all */) -> some View where S : ShapeStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.background(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.Color._clear, bridgedIgnoresSafeAreaEdges: Int(edges.rawValue))
        }
    }

    @inlinable nonisolated public func background<S>(in shape: S, fillStyle: FillStyle = FillStyle()) -> some View where S : Shape {
        return background(BackgroundStyle(), in: shape, fillStyle: fillStyle)
    }

    /* @inlinable nonisolated */ public func background<S, T>(_ style: S, in shape: T, fillStyle: FillStyle = FillStyle()) -> some View where S : ShapeStyle, T : Shape {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.background(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.BackgroundStyle(), in: shape.Java_shape, eoFill: fillStyle.isEOFilled, antialiased: fillStyle.isAntialiased)
        }
    }

    @inlinable nonisolated public func background<S>(in shape: S, fillStyle: FillStyle = FillStyle()) -> some View where S : InsettableShape {
        return background(BackgroundStyle(), in: shape, fillStyle: fillStyle)
    }

    /* @inlinable nonisolated */ public func background<S, T>(_ style: S, in shape: T, fillStyle: FillStyle = FillStyle()) -> some View where S : ShapeStyle, T : InsettableShape {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.background(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.BackgroundStyle(), in: shape.Java_shape, eoFill: fillStyle.isEOFilled, antialiased: fillStyle.isAntialiased)
        }
    }
}

extension View {
    /* @inlinable nonisolated */ public func backgroundStyle<S>(_ style: S) -> some View where S : ShapeStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.backgroundStyle(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.Color._clear)
        }
    }
}

extension View {
    /* nonisolated */ public func border<S>(_ content: S, width: CGFloat = 1) -> some View where S : ShapeStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.border(content.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.Color._clear, width: width)
        }
    }
}

extension View {
    /* nonisolated */ public func colorInvert() -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.colorInvert()
        }
    }
}

extension View {
    /* @inlinable nonisolated */ public func disabled(_ disabled: Bool) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.disabled(disabled)
        }
    }
}

extension View {
    /* nonisolated */ public func foregroundColor(_ color: Color?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.foregroundColor(color?.Java_view as? SkipUI.Color)
        }
    }

    /* nonisolated */ public func foregroundStyle<S>(_ style: S) -> some View where S : ShapeStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.foregroundStyle(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.Color._clear)
        }
    }
}

extension View {
    @inlinable /* nonisolated */ public func edgesIgnoringSafeArea(_ edges: Edge.Set) -> some View {
        return ignoresSafeArea(edges: edges)
    }

    /* @inlinable nonisolated */ public func ignoresSafeArea(_ regions: SafeAreaRegions = .all, edges: Edge.Set = .all) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.ignoresSafeArea(bridgedRegions: Int(regions.rawValue), bridgedEdges: Int(edges.rawValue))
        }
    }
}

extension View {
    /* @inlinable nonisolated */ public func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.frame(width: width, height: height, horizontalAlignmentKey: alignment.horizontal.key, verticalAlignmentKey: alignment.vertical.key)
        }
    }

    @available(*, deprecated, message: "Please pass one or more parameters.")
    /* @inlinable nonisolated */ public func frame() -> some View {
        stubView()
    }

    /* @inlinable nonisolated */ public func frame(minWidth: CGFloat? = nil, idealWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, idealHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.frame(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, horizontalAlignmentKey: alignment.horizontal.key, verticalAlignmentKey: alignment.vertical.key)
        }
    }
}

extension View {
    /* @inlinable nonisolated */ public func hidden() -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.hidden()
        }
    }
}

extension View {
    @inlinable nonisolated public func offset(_ offset: CGSize) -> some View {
        return self.offset(x: offset.width, y: offset.height)
    }

    /* @inlinable nonisolated */ public func offset(x: CGFloat = 0, y: CGFloat = 0) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.offset(x: x, y: y)
        }
    }

}

extension View {
    /* @inlinable nonisolated */ public func onAppear(perform action: (() -> Void)? = nil) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onAppear(perform: action)
        }
    }


    /* @inlinable nonisolated */ public func onDisappear(perform action: (() -> Void)? = nil) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onDisappear(perform: action)
        }
    }

}

extension View {
    /* @inlinable nonisolated */ public func opacity(_ opacity: Double) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.opacity(opacity)
        }
    }
}

extension View {
    /* @inlinable nonisolated */ public func padding(_ insets: EdgeInsets) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.padding(top: insets.top, leading: insets.leading, bottom: insets.bottom, trailing: insets.trailing)
        }
    }

    /* @inlinable nonisolated */ public func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        var padding = EdgeInsets()
        if edges.contains(.top) {
            padding.top = length ?? 16.0
        }
        if edges.contains(.bottom) {
            padding.bottom = length ?? 16.0
        }
        if edges.contains(.leading) {
            padding.leading = length ?? 16.0
        }
        if edges.contains(.trailing) {
            padding.trailing = length ?? 16.0
        }
        return self.padding(padding)
    }


    /* @inlinable nonisolated */ public func padding(_ length: CGFloat) -> some View {
        return padding(.all, length)
    }
}

extension View {
    /* @inlinable nonisolated */ public func rotationEffect(_ angle: Angle, anchor: UnitPoint = .center) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.rotationEffect(bridgedAngle: angle.radians, anchorX: anchor.x, anchorY: anchor.y)
        }
    }
}

extension View {
    /* @inlinable nonisolated */ public func rotation3DEffect(_ angle: Angle, axis: (x: CGFloat, y: CGFloat, z: CGFloat), anchor: UnitPoint = .center, anchorZ: CGFloat = 0, perspective: CGFloat = 1) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.rotation3DEffect(bridgedAngle: angle.radians, axis: axis, anchorX: anchor.x, anchorY: anchor.y, anchorZ: anchorZ, perspective: perspective)
        }
    }
}

extension View {
    @inlinable /* nonisolated */ public func scaleEffect(_ scale: CGSize, anchor: UnitPoint = .center) -> some View {
        return scaleEffect(x: scale.width, y: scale.height, anchor: anchor)
    }

    @inlinable /* nonisolated */ public func scaleEffect(_ s: CGFloat, anchor: UnitPoint = .center) -> some View {
        return scaleEffect(x: s, y: s, anchor: anchor)
    }

    /* @inlinable nonisolated */ public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0, anchor: UnitPoint = .center) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scaleEffect(x: x, y: y, anchorX: anchor.x, anchorY: anchor.y)
        }
    }
}


extension View {
    /* nonisolated */ public func tag<V>(_ tag: V, includeOptional: Bool = true) -> some View where V : Hashable {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.tag(SwiftHashable(tag)) // Tag with bridgable wrapper
        }
    }
}

extension View {
    @available(*, unavailable)
    /* @inlinable nonisolated */ public func tint<S>(_ tint: S?) -> some View where S : ShapeStyle {
        stubView()
    }

    /* @inlinable nonisolated */ public func tint(_ tint: Color?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.tint(tint?.Java_view as? SkipUI.Color)
        }
    }
}

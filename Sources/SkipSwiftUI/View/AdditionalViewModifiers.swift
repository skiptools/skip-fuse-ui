// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipBridge
import SkipUI

extension View {
    /* @inlinable */ nonisolated public func aspectRatio(_ aspectRatio: CGFloat? = nil, contentMode: ContentMode) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.aspectRatio(aspectRatio, bridgedContentMode: contentMode.rawValue)
        }
    }

    @inlinable nonisolated public func aspectRatio(_ aspectRatio: CGSize, contentMode: ContentMode) -> some View {
        return self.aspectRatio(aspectRatio.width / aspectRatio.height, contentMode: contentMode)
    }

    @inlinable nonisolated public func scaledToFit() -> some View {
        return aspectRatio(contentMode: .fit)
    }

    @inlinable nonisolated public func scaledToFill() -> some View {
        return aspectRatio(contentMode: .fill)
    }
}

extension View {
    @_disfavoredOverload @inlinable nonisolated public func background<Background>(_ background: Background, alignment: Alignment = .center) -> some View where Background : View {
        return self.background(alignment: alignment, content: { background })
    }

    /* @inlinable */ nonisolated public func background<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View {
        let bridgedContent = content()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.background(horizontalAlignmentKey: alignment.horizontal.key, verticalAlignmentKey: alignment.vertical.key, bridgedContent: bridgedContent.Java_viewOrEmpty)
        }
    }

    /// - Warning: The second argument here should default to `.all`. Our implementation is not yet sophisticated enough to auto-detect when it is
    ///     against a safe area boundary, so this would cause problems. Therefore we default to `[]` and rely on ther user to specify the edges.
    @inlinable nonisolated public func background(ignoresSafeAreaEdges edges: Edge.Set = [] /* .all */) -> some View {
        return background(BackgroundStyle(), ignoresSafeAreaEdges: edges)
    }

    /// - Warning: The second argument here should default to `.all`. Our implementation is not yet sophisticated enough to auto-detect when it is
    ///     against a safe area boundary, so this would cause problems. Therefore we default to `[]` and rely on ther user to specify the edges.
    /* @inlinable */ nonisolated public func background<S>(_ style: S, ignoresSafeAreaEdges edges: Edge.Set = [] /* .all */) -> some View where S : ShapeStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.background(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.Color._clear, bridgedIgnoresSafeAreaEdges: Int(edges.rawValue))
        }
    }

    @inlinable nonisolated public func background<S>(in shape: S, fillStyle: FillStyle = FillStyle()) -> some View where S : Shape {
        return background(BackgroundStyle(), in: shape, fillStyle: fillStyle)
    }

    /* @inlinable */ nonisolated public func background<S, T>(_ style: S, in shape: T, fillStyle: FillStyle = FillStyle()) -> some View where S : ShapeStyle, T : Shape {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.background(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.BackgroundStyle(), in: shape.Java_shape, eoFill: fillStyle.isEOFilled, antialiased: fillStyle.isAntialiased)
        }
    }

    @inlinable nonisolated public func background<S>(in shape: S, fillStyle: FillStyle = FillStyle()) -> some View where S : InsettableShape {
        return background(BackgroundStyle(), in: shape, fillStyle: fillStyle)
    }

    /* @inlinable */ nonisolated public func background<S, T>(_ style: S, in shape: T, fillStyle: FillStyle = FillStyle()) -> some View where S : ShapeStyle, T : InsettableShape {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.background(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.BackgroundStyle(), in: shape.Java_shape, eoFill: fillStyle.isEOFilled, antialiased: fillStyle.isAntialiased)
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func backgroundStyle<S>(_ style: S) -> some View where S : ShapeStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.backgroundStyle(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.Color._clear)
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func blur(radius: CGFloat, opaque: Bool = false) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.blur(radius: radius, opaque: opaque)
        }
    }
}

extension View {
    nonisolated public func border<S>(_ content: S, width: CGFloat = 1) -> some View where S : ShapeStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.border(content.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.Color._clear, width: width)
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func clipShape<S>(_ shape: S, style: FillStyle = FillStyle()) -> some View where S : Shape {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.clipShape(shape.Java_shape, eoFill: style.isEOFilled, antialiased: style.isAntialiased)
        }
    }

    /* @inlinable */ nonisolated public func clipped(antialiased: Bool = false) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.clipped(antialiased: antialiased)
        }
    }

    @inlinable nonisolated public func cornerRadius(_ radius: CGFloat, antialiased: Bool = true) -> some View {
        return clipShape(RoundedRectangle(cornerRadius: radius), style: FillStyle(antialiased: antialiased))
    }
}

extension View {
    nonisolated public func colorInvert() -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.colorInvert()
        }
    }
}

extension View {
    nonisolated public func brightness(_ amount: Double) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.brightness(amount)
        }
    }
}

extension View {
    nonisolated public func contrast(_ amount: Double) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.contrast(amount)
        }
    }
}

extension View {
    nonisolated public func saturation(_ amount: Double) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.saturation(amount)
        }
    }
}

extension View {
    nonisolated public func hueRotation(_ angle: Angle) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.hueRotation(bridgedAngle: angle.radians)
        }
    }
}

extension View {
    nonisolated public func colorMultiply(_ color: Color) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.colorMultiply(color.Java_view as? SkipUI.Color ?? SkipUI.Color._clear)
        }
    }
}

extension View {
    nonisolated public func blendMode(_ blendMode: BlendMode) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.blendMode(bridgedRawValue: blendMode.rawValue)
        }
    }
}

extension View {
    nonisolated public func allowsHitTesting(_ enabled: Bool) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.allowsHitTesting(enabled)
        }
    }
}

extension View {
    nonisolated public func drawingGroup(opaque: Bool = false, colorMode: ColorRenderingMode = .nonLinear) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.drawingGroup()
        }
    }
}

extension View {
    nonisolated public func luminanceToAlpha() -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.luminanceToAlpha()
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func compositingGroup() -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.compositingGroup()
        }
    }
}

extension View {
    nonisolated public func flipsForRightToLeftLayoutDirection(_ enabled: Bool) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.flipsForRightToLeftLayoutDirection(enabled)
        }
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func controlSize(_ controlSize: ControlSize) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func controlSize<T>(_ range: T) -> some View where T : RangeExpression, T.Bound == ControlSize {
        stubView()
    }
}

extension View {
    /* @inlinable */ nonisolated public func disabled(_ disabled: Bool) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.disabled(disabled)
        }
    }
}

extension View {
    @inlinable nonisolated public func edgesIgnoringSafeArea(_ edges: Edge.Set) -> some View {
        return ignoresSafeArea(edges: edges)
    }

    /* @inlinable */ nonisolated public func ignoresSafeArea(_ regions: SafeAreaRegions = .all, edges: Edge.Set = .all) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.ignoresSafeArea(bridgedRegions: Int(regions.rawValue), bridgedEdges: Int(edges.rawValue))
        }
    }
}

extension View {
    nonisolated public func foregroundColor(_ color: Color?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.foregroundColor(color?.Java_view as? SkipUI.Color)
        }
    }

    nonisolated public func foregroundStyle<S>(_ style: S) -> some View where S : ShapeStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.foregroundStyle(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.Color._clear)
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.frame(width: width, height: height, horizontalAlignmentKey: alignment.horizontal.key, verticalAlignmentKey: alignment.vertical.key)
        }
    }

    @available(*, deprecated, message: "Please pass one or more parameters.")
    /* @inlinable */ nonisolated public func frame() -> some View {
        stubView()
    }

    /* @inlinable */ nonisolated public func frame(minWidth: CGFloat? = nil, idealWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, idealHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.frame(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, horizontalAlignmentKey: alignment.horizontal.key, verticalAlignmentKey: alignment.vertical.key)
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func grayscale(_ amount: Double) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.grayscale(amount)
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func hidden() -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.hidden()
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func id<ID>(_ id: ID) -> some View where ID : Hashable {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.id(Java_swiftHashable(for: id))
        }
    }
}

extension View {
    nonisolated public func labelsHidden() -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.labelsHidden()
        }
    }
}

extension View {
    /// Android-only modifier to opt in to previous Skip layout behavior.
    nonisolated public func layoutImplementationVersion(_ version: Int) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.layoutImplementationVersion(version)
        }
    }
}

extension View {
    @inlinable nonisolated public func offset(_ offset: CGSize) -> some View {
        return self.offset(x: offset.width, y: offset.height)
    }

    /* @inlinable */ nonisolated public func offset(x: CGFloat = 0, y: CGFloat = 0) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.offset(x: x, y: y)
        }
    }

}

extension View {
    /* @inlinable */ nonisolated public func onAppear(perform action: (() -> Void)? = nil) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onAppear(perform: action)
        }
    }


    /* @inlinable */ nonisolated public func onDisappear(perform action: (() -> Void)? = nil) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onDisappear(perform: action)
        }
    }
}

extension View {
    @inlinable nonisolated public func onChange<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> some View where V : Equatable {
        return onChange(of: value, initial: false) { _, newValue in
            action(newValue)
        }
    }

    nonisolated public func onChange<V>(of value: V, initial: Bool = false, _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void) -> some View where V : Equatable {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onChange(of: Java_swiftEquatable(for: value), initial: initial) { oldValue, newValue in
                action(oldValue.base as! V, newValue.base as! V)
            }
        }
    }

    nonisolated public func onChange<V>(of value: V, initial: Bool = false, _ action: @escaping () -> Void) -> some View where V : Equatable {
        return onChange(of: value, initial: initial) { _, _ in
            action()
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func opacity(_ opacity: Double) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.opacity(opacity)
        }
    }
}

extension View {
    @_disfavoredOverload @inlinable nonisolated public func overlay<Overlay>(_ overlay: Overlay, alignment: Alignment = .center) -> some View where Overlay : View {
        return self.overlay(alignment: alignment, content: { overlay })
    }

    /* @inlinable */ nonisolated public func overlay<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View {
        let content = content()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.overlay(horizontalAlignmentKey: alignment.horizontal.key, verticalAlignmentKey: alignment.vertical.key, bridgedContent: content.Java_viewOrEmpty)
        }
    }

    /* @inlinable */ nonisolated public func overlay<S>(_ style: S, ignoresSafeAreaEdges edges: Edge.Set = .all) -> some View where S : ShapeStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.overlay(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.ForegroundStyle(), bridgedIgnoresSafeAreaEdges: Int(edges.rawValue))
        }
    }

    /* @inlinable */ nonisolated public func overlay<S, T>(_ style: S, in shape: T, fillStyle: FillStyle = FillStyle()) -> some View where S : ShapeStyle, T : Shape {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.overlay(style.Java_view as? any SkipUI.ShapeStyle ?? SkipUI.ForegroundStyle(), in: shape.Java_shape, eoFill: fillStyle.isEOFilled, antialiased: fillStyle.isAntialiased)
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func padding(_ insets: EdgeInsets) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.padding(top: insets.top, leading: insets.leading, bottom: insets.bottom, trailing: insets.trailing)
        }
    }

    /* @inlinable */ nonisolated public func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
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


    /* @inlinable */ nonisolated public func padding(_ length: CGFloat) -> some View {
        return padding(.all, length)
    }
}

extension View {
    @inlinable nonisolated public func position(_ position: CGPoint) -> some View {
        return self.position(x: position.x, y: position.y)
    }

    /* @inlinable */ nonisolated public func position(x: CGFloat = 0, y: CGFloat = 0) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.position(x: x, y: y)
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func rotationEffect(_ angle: Angle, anchor: UnitPoint = .center) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.rotationEffect(bridgedAngle: angle.radians, anchorX: anchor.x, anchorY: anchor.y)
        }
    }
}

extension View {
    nonisolated public func refreshable(action: @escaping /* @Sendable */ () async -> Void) -> some View {
        return environment(\.refresh, RefreshAction(action: action))
    }

}

extension View {
    /* @inlinable */ nonisolated public func rotation3DEffect(_ angle: Angle, axis: (x: CGFloat, y: CGFloat, z: CGFloat), anchor: UnitPoint = .center, anchorZ: CGFloat = 0, perspective: CGFloat = 1) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.rotation3DEffect(bridgedAngle: angle.radians, axis: axis, anchorX: anchor.x, anchorY: anchor.y, anchorZ: anchorZ, perspective: perspective)
        }
    }
}

extension View {
    @inlinable nonisolated public func scaleEffect(_ scale: CGSize, anchor: UnitPoint = .center) -> some View {
        return scaleEffect(x: scale.width, y: scale.height, anchor: anchor)
    }

    @inlinable nonisolated public func scaleEffect(_ s: CGFloat, anchor: UnitPoint = .center) -> some View {
        return scaleEffect(x: s, y: s, anchor: anchor)
    }

    /* @inlinable */ nonisolated public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0, anchor: UnitPoint = .center) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.scaleEffect(x: x, y: y, anchorX: anchor.x, anchorY: anchor.y)
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func shadow(color: Color = Color(.sRGBLinear, white: 0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.shadow(color: color.Java_view as? SkipUI.Color ?? SkipUI.Color._black, radius: radius, x: x, y: y)
        }
    }
}

extension View {
    nonisolated public func tag<V>(_ tag: V, includeOptional: Bool = true) -> some View where V : Hashable {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.tag(Java_swiftHashable(for: tag)) // Tag with bridgable wrapper
        }
    }
}

extension View {
    @inlinable nonisolated public func task(priority: TaskPriority = .userInitiated, _ action: @escaping /* @Sendable */ () async -> Void) -> some View {
        return task(id: 0, priority: priority, action)
    }

    /* @inlinable */ nonisolated public func task<T>(id value: T, priority: TaskPriority = .userInitiated, _ action: @escaping /* @Sendable */ () async -> Void) -> some View where T : Equatable {
        // We use a non-@Sendable closure for better compatibility with iOS code that may be isolated to @MainActor
        // where our APIs are not
        let actionBox = UncheckedSendableBox(action)
        return ModifierView(target: self) {
            return $0.Java_viewOrEmpty.task(id: Java_swiftEquatable(for: value), bridgedAction: { completionHandler in
                let task = Task(priority: priority) {
                    await actionBox.wrappedValue()
                    completionHandler.run()
                }
                completionHandler.onCancel = {
                    task.cancel()
                }
            })
        }
    }
}

extension View {
    @available(*, unavailable)
    /* @inlinable */ nonisolated public func tint<S>(_ tint: S?) -> some View where S : ShapeStyle {
        stubView()
    }

    /* @inlinable */ nonisolated public func tint(_ tint: Color?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.tint(tint?.Java_view as? SkipUI.Color)
        }
    }
}

extension View {
    /* @inlinable */ nonisolated public func zIndex(_ value: Double) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.zIndex(value)
        }
    }
}

// MARK: - Mask
extension View {
    /* @inlinable */ nonisolated public func mask<Mask>(alignment: Alignment = .center, @ViewBuilder _ mask: () -> Mask) -> some View where Mask : View {
        let maskView = mask()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.mask(horizontalAlignmentKey: alignment.horizontal.key, verticalAlignmentKey: alignment.vertical.key, bridgedMask: maskView.Java_viewOrEmpty)
        }
    }

    @inlinable nonisolated public func mask<Mask>(_ mask: Mask) -> some View where Mask : View {
        return self.mask(alignment: .center) { mask }
    }
}

// MARK: - Tracking
extension View {
    /* @inlinable */ nonisolated public func tracking(_ tracking: CGFloat) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.tracking(tracking)
        }
    }
}

// MARK: - Line Spacing
extension View {
    /* @inlinable */ nonisolated public func lineSpacing(_ lineSpacing: CGFloat) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.lineSpacing(lineSpacing)
        }
    }
}

// MARK: - Minimum Scale Factor
extension View {
    /* @inlinable */ nonisolated public func minimumScaleFactor(_ factor: CGFloat) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.minimumScaleFactor(factor)
        }
    }
}

// MARK: - Badge
extension View {
    /* @inlinable */ nonisolated public func badge(_ count: Int) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.badge(count)
        }
    }

    /* @inlinable */ nonisolated public func badge(_ label: Text?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.badge(label?.Java_view as? SkipUI.Text)
        }
    }

    @inlinable nonisolated public func badge(_ key: LocalizedStringKey) -> some View {
        return badge(Text(key))
    }

    @inlinable nonisolated public func badge(_ label: String?) -> some View {
        if let label {
            return badge(Text(label))
        } else {
            return badge(nil as Text?)
        }
    }

    /* @inlinable */ nonisolated public func badgeProminence(_ prominence: BadgeProminence) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.badgeProminence(bridgedRawValue: prominence.rawValue)
        }
    }
}

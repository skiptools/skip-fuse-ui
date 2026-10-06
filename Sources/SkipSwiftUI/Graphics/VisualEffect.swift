// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif

/// Visual effects that change a view's appearance without affecting its layout.
public protocol VisualEffect {
}

/// The base visual effect, which effect modifiers transform.
///
/// - Note: Anchors are ignored; effects apply around the view's center.
public struct EmptyVisualEffect : VisualEffect {
    private var opacity = 1.0
    private var scale = CGSize(width: 1.0, height: 1.0)
    private var offset = CGSize.zero
    private var rotation = Angle.zero
    private var blurRadius: CGFloat = 0.0

    public init() {
    }

    public func opacity(_ opacity: Double) -> EmptyVisualEffect {
        var effect = self
        effect.opacity *= opacity
        return effect
    }

    public func scaleEffect(_ scale: CGFloat, anchor: UnitPoint = .center) -> EmptyVisualEffect {
        return scaleEffect(x: scale, y: scale, anchor: anchor)
    }

    public func scaleEffect(_ scale: CGSize, anchor: UnitPoint = .center) -> EmptyVisualEffect {
        return scaleEffect(x: scale.width, y: scale.height, anchor: anchor)
    }

    public func scaleEffect(x: CGFloat = 1.0, y: CGFloat = 1.0, anchor: UnitPoint = .center) -> EmptyVisualEffect {
        var effect = self
        effect.scale = CGSize(width: scale.width * x, height: scale.height * y)
        return effect
    }

    public func offset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> EmptyVisualEffect {
        var effect = self
        effect.offset = CGSize(width: offset.width + x, height: offset.height + y)
        return effect
    }

    public func offset(_ offset: CGSize) -> EmptyVisualEffect {
        return self.offset(x: offset.width, y: offset.height)
    }

    public func rotationEffect(_ angle: Angle, anchor: UnitPoint = .center) -> EmptyVisualEffect {
        var effect = self
        effect.rotation = Angle(radians: rotation.radians + angle.radians)
        return effect
    }

    public func blur(radius: CGFloat, opaque: Bool = false) -> EmptyVisualEffect {
        var effect = self
        effect.blurRadius += radius
        return effect
    }

    /// Opacity, scale width and height, offset width and height, rotation degrees, and blur radius.
    var bridgedValues: [Double] {
        return [opacity, Double(scale.width), Double(scale.height), Double(offset.width), Double(offset.height), rotation.degrees, Double(blurRadius)]
    }
}

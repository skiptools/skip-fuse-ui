// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

public protocol ShapeStyle : SkipUIBridging /*, Sendable */ {
//    associatedtype Resolved : ShapeStyle = Never
//    func resolve(in environment: EnvironmentValues) -> Self.Resolved
}

func stubShapeStyle() -> Color {
    return Color.clear
}

extension ShapeStyle {
    public var secondary: some ShapeStyle {
        return self
    }

    public var tertiary: some ShapeStyle {
        return self
    }

    public var quaternary: some ShapeStyle {
        return self
    }

    public var quinary: some ShapeStyle {
        return self
    }
}

@frozen public struct AnyShapeStyle : ShapeStyle {
    let style: any ShapeStyle

    public init<S>(_ style: S) where S : ShapeStyle {
        self.style = style
    }

    public var Java_view: any SkipUI.View {
        return style.Java_view
    }

//    public typealias Resolved = Never
}

extension ShapeStyle {
    @available(*, unavailable)
    /* @inlinable */ public func blendMode(_ mode: BlendMode) -> some ShapeStyle {
        stubShapeStyle()
    }
}

extension ShapeStyle where Self == AnyShapeStyle {
    @available(*, unavailable)
    public static func blendMode(_ mode: BlendMode) -> some ShapeStyle {
        stubShapeStyle()
    }
}

extension ShapeStyle where Self == AnyShapeStyle {
    @available(*, unavailable)
    public static func opacity(_ opacity: Double) -> some ShapeStyle {
        stubShapeStyle()
    }
}

@frozen public struct BackgroundStyle : ShapeStyle /*, BitwiseCopyable */ {
    @inlinable public init() {
    }

    public var Java_view: any SkipUI.View {
        return SkipUI.BackgroundStyle()
    }

//    public typealias Resolved = Never
}

extension ShapeStyle where Self == BackgroundStyle {
    public static var background: BackgroundStyle {
        return BackgroundStyle()
    }
}

extension ShapeStyle where Self == ForegroundStyle {
    public static var foreground: ForegroundStyle {
        return ForegroundStyle()
    }
}

@frozen public struct ForegroundStyle : ShapeStyle /*, BitwiseCopyable */ {
    @inlinable public init() {
    }

    public var Java_view: any SkipUI.View {
        return SkipUI.ForegroundStyle()
    }

//    public typealias Resolved = Never
}

/* @frozen */ public struct HierarchicalShapeStyle : ShapeStyle {
    public static let primary = HierarchicalShapeStyle(level: 0)
    public static let secondary = HierarchicalShapeStyle(level: 1)

    @available(*, unavailable)
    public static var tertiary: HierarchicalShapeStyle { fatalError() }
    @available(*, unavailable)
    public static var quaternary: HierarchicalShapeStyle { fatalError() }

    private let level: Int

    private init(level: Int) {
        self.level = level
    }

    public var Java_view: any SkipUI.View {
        switch level {
        case 0:
            return Color.primary.Java_view
        case 1:
            return Color.secondary.Java_view
        default:
            return SkipUI.EmptyView()
        }
    }
}

extension ShapeStyle where Self == HierarchicalShapeStyle {
    public static var primary: HierarchicalShapeStyle { HierarchicalShapeStyle.primary }
    public static var secondary: HierarchicalShapeStyle { HierarchicalShapeStyle.secondary }

    @available(*, unavailable)
    public static var tertiary: HierarchicalShapeStyle { fatalError() }
    @available(*, unavailable)
    public static var quaternary: HierarchicalShapeStyle { fatalError() }
    @available(*, unavailable)
    public static var quinary: HierarchicalShapeStyle { fatalError() }
}

public struct TintShapeStyle : ShapeStyle {
    public init() {
    }

    public var Java_view: any SkipUI.View {
        return SkipUI.TintShapeStyle()
    }

//    public typealias Resolved = Never
}

extension ShapeStyle where Self == TintShapeStyle {
    public static var tint: TintShapeStyle {
        return TintShapeStyle()
    }
}

extension Never : ShapeStyle {
}

//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension ShapeStyle where Self == ImagePaint {
//
//    /// A shape style that fills a shape by repeating a region of an image.
//    ///
//    /// For information about how to use shape styles, see ``ShapeStyle``.
//    ///
//    /// - Parameters:
//    ///   - image: The image to be drawn.
//    ///   - sourceRect: A unit-space rectangle defining how much of the source
//    ///     image to draw. The results are undefined if `sourceRect` selects
//    ///     areas outside the `[0, 1]` range in either axis.
//    ///   - scale: A scale factor applied to the image during rendering.
//    public static func image(_ image: Image, sourceRect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1), scale: CGFloat = 1) -> ImagePaint
//}
//
//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
//extension ShapeStyle where Self == Material {
//
//    /// A material that's somewhat translucent.
//    public static var regularMaterial: Material { get }
//
//    /// A material that's more opaque than translucent.
//    public static var thickMaterial: Material { get }
//
//    /// A material that's more translucent than opaque.
//    public static var thinMaterial: Material { get }
//
//    /// A mostly translucent material.
//    public static var ultraThinMaterial: Material { get }
//
//    /// A mostly opaque material.
//    public static var ultraThickMaterial: Material { get }
//}
//
//@available(iOS 15.0, macOS 12.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension ShapeStyle where Self == Material {
//
//    /// A material matching the style of system toolbars.
//    public static var bar: Material { get }
//}
//
//@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
//extension ShapeStyle {
//
//    /// Sets an explicit active appearance for materials created by this style.
//    public func materialActiveAppearance(_ appearance: MaterialActiveAppearance) -> some ShapeStyle
//
//}
//
//@available(iOS 17.0, macOS 10.15, tvOS 17.0, watchOS 10.0, *)
//extension ShapeStyle where Self == SeparatorShapeStyle {
//
//    /// A style appropriate for foreground separator or border lines.
//    ///
//    /// For information about how to use shape styles, see ``ShapeStyle``.
//    public static var separator: SeparatorShapeStyle { get }
//}
//
//@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//extension ShapeStyle {
//
//    /// Applies the specified shadow effect to the shape style.
//    ///
//    /// For example, you can create a rectangle that adds a drop shadow to
//    /// the ``ShapeStyle/red`` shape style.
//    ///
//    ///     Rectangle().fill(.red.shadow(.drop(radius: 2, y: 3)))
//    ///
//    /// - Parameter style: The shadow style to apply.
//    ///
//    /// - Returns: A new shape style that uses the specified shadow style.
//    @inlinable public func shadow(_ style: ShadowStyle) -> some ShapeStyle
//
//}
//
//@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//extension ShapeStyle where Self == AnyShapeStyle {
//
//    /// Returns a shape style that applies the specified shadow style to the
//    /// current style.
//    ///
//    /// In most contexts the current style is the foreground, but not always.
//    /// For example, when setting the value of the background style, that
//    /// becomes the current implicit style.
//    ///
//    /// The following example creates a circle filled with the current
//    /// foreground style that uses an inner shadow:
//    ///
//    ///     Circle().fill(.shadow(.inner(radius: 1, y: 1)))
//    ///
//    /// - Parameter style: The shadow style to apply.
//    ///
//    /// - Returns: A new shape style based on the current style that uses the
//    ///   specified shadow style.
//    public static func shadow(_ style: ShadowStyle) -> some ShapeStyle
//
//}
//
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension ShapeStyle {
//
//    /// Maps a shape style's unit-space coordinates to the absolute coordinates
//    /// of a given rectangle.
//    ///
//    /// Some shape styles have colors or patterns that vary
//    /// with position based on ``UnitPoint`` coordinates. For example, you
//    /// can create a ``LinearGradient`` using ``UnitPoint/top`` and
//    /// ``UnitPoint/bottom`` as the start and end points:
//    ///
//    ///     let gradient = LinearGradient(
//    ///         colors: [.red, .yellow],
//    ///         startPoint: .top,
//    ///         endPoint: .bottom)
//    ///
//    /// When rendering such styles, SwiftUI maps the unit space coordinates to
//    /// the absolute coordinates of the filled shape. However, you can tell
//    /// SwiftUI to use a different set of coordinates by supplying a rectangle
//    /// to the `in(_:)` method. Consider two resizable rectangles using the
//    /// gradient defined above:
//    ///
//    ///     HStack {
//    ///         Rectangle()
//    ///             .fill(gradient)
//    ///         Rectangle()
//    ///             .fill(gradient.in(CGRect(x: 0, y: 0, width: 0, height: 300)))
//    ///     }
//    ///     .onTapGesture { isBig.toggle() }
//    ///     .frame(height: isBig ? 300 : 50)
//    ///     .animation(.easeInOut)
//    ///
//    /// When `isBig` is true — defined elsewhere as a private ``State``
//    /// variable — the rectangles look the same, because their heights
//    /// match that of the modified gradient:
//    ///
//    /// ![Two identical, tall rectangles, with a gradient that starts red at
//    /// the top and transitions to yellow at the bottom.](ShapeStyle-in-1)
//    ///
//    /// When the user toggles `isBig` by tapping the ``HStack``, the
//    /// rectangles shrink, but the gradients each react in a different way:
//    ///
//    /// ![Two short rectangles with different coloration. The first has a
//    /// gradient that transitions top to bottom from full red to full yellow.
//    /// The second starts as red at the top and then begins to transition
//    /// to yellow toward the bottom.](ShapeStyle-in-2)
//    ///
//    /// SwiftUI remaps the gradient of the first rectangle to the new frame
//    /// height, so that you continue to see the full range of colors in a
//    /// smaller area. For the second rectangle, the modified gradient retains
//    /// a mapping to the full height, so you instead see only a small part of
//    /// the overall gradient. Animation helps to visualize the difference.
//    ///
//    /// - Parameter rect: A rectangle that gives the absolute coordinates over
//    ///   which to map the shape style.
//    /// - Returns: A new shape style mapped to the coordinates given by `rect`.
//    @inlinable public func `in`(_ rect: CGRect) -> some ShapeStyle
//
//}
//
//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//extension ShapeStyle where Self.Resolved == Never {
//
//    /// Evaluate to a resolved shape style given the current `environment`.
//    public func resolve(in environment: EnvironmentValues) -> Never
//}
//
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension ShapeStyle where Self : View, Self.Body == _ShapeView<Rectangle, Self> {
//
//    /// A rectangular view that's filled with the shape style.
//    ///
//    /// For a ``ShapeStyle`` that also conforms to the ``View`` protocol, like
//    /// ``Color`` or ``LinearGradient``, this default implementation of the
//    /// ``View/body-swift.property`` property provides a visual representation
//    /// for the shape style. As a result, you can use the shape style in a view
//    /// hierarchy like any other view:
//    ///
//    ///     ZStack {
//    ///         Color.cyan
//    ///         Text("Hello!")
//    ///     }
//    ///     .frame(width: 200, height: 50)
//    ///
//    /// ![A screenshot of a cyan rectangle with the text hello appearing
//    /// in the middle of the rectangle.](ShapeStyle-body-1)
//    public var body: _ShapeView<Rectangle, Self> { get }
//}

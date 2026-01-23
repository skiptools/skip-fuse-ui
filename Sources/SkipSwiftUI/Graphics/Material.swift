// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

/// A background material type.
///
/// You can apply a blur effect to a view that appears behind another view by
/// adding a material with the ``View/background(_:ignoresSafeAreaEdges:)``
/// modifier:
///
///     ZStack {
///         Color.teal
///         Label("Flag", systemImage: "flag.fill")
///             .padding()
///             .background(.regularMaterial)
///     }
///
/// In the example above, the ``ZStack`` layers a ``Label`` on top of the color
/// ``ShapeStyle/teal``. The background modifier inserts the
/// regular material below the label, blurring the part of
/// the background that the label --- including its padding --- covers.
///
/// A material isn't a view, but adding a material is like inserting a
/// translucent layer between the modified view and its background.
///
/// For physical materials, the degree to which the background colors pass
/// through depends on the thickness. The effect also varies with light and
/// dark appearance.
public struct Material : ShapeStyle, RawRepresentable, Hashable, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// A material that's somewhat translucent.
    public static let regular = Material(rawValue: 0)

    /// A material that's more opaque than translucent.
    public static let thick = Material(rawValue: 1)

    /// A material that's more translucent than opaque.
    public static let thin = Material(rawValue: 2)

    /// A mostly translucent material.
    public static let ultraThin = Material(rawValue: 3)

    /// A mostly opaque material.
    public static let ultraThick = Material(rawValue: 4)

    /// A material matching the style of system toolbars.
    public static let bar = Material(rawValue: 5)

    /// Returns the opacity for this material (light mode values).
    /// Note: This is a simplified replica - no blur effect, just semi-transparent white overlay.
    private var materialOpacity: Double {
        switch rawValue {
        case Self.ultraThin.rawValue:
            return 0.3
        case Self.thin.rawValue:
            return 0.45
        case Self.regular.rawValue, Self.bar.rawValue:
            return 0.6
        case Self.thick.rawValue:
            return 0.7
        case Self.ultraThick.rawValue:
            return 0.8
        default:
            return 0.6
        }
    }

    public var Java_view: any SkipUI.View {
        return SkipUI.Color._white.opacity(materialOpacity)
    }
}

extension ShapeStyle where Self == Material {
    public static var regularMaterial: Material { .regular }
    public static var thickMaterial: Material { .thick }
    public static var thinMaterial: Material { .thin }
    public static var ultraThinMaterial: Material { .ultraThin }
    public static var ultraThickMaterial: Material { .ultraThick }
    public static var bar: Material { .bar }
}

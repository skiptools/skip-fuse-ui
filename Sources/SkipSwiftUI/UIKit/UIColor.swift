// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import Foundation
import SkipUI

open class UIColor : NSObject /*, NSSecureCoding, NSCopying */, @unchecked Sendable {
    let uiColor: SkipUI.UIColor

    /// Stored RGB components for Color conversion; SkipUI.UIColor properties may be internal when bridged.
    private let _components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)?

    @available(*, unavailable)
    public init(white: CGFloat, alpha: CGFloat) {
        fatalError()
    }

    @available(*, unavailable)
    public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        fatalError()
    }

    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.uiColor = SkipUI.UIColor(red: red, green: green, blue: blue, alpha: alpha)
        self._components = (red, green, blue, alpha)
    }

    public convenience init(_ color: Color) {
        // Extension point: only colours built from literal component values have components
        // here. The semantic colours, the asset-catalogue colours and `saturate` resolve
        // through MaterialTheme, the asset catalogue or the draw pass inside a @Composable,
        // so `rgbaComponents` is nil for them and they arrive as no components at all rather
        // than as an approximation.
        //
        // Such a colour cannot be carried across faithfully today because `SkipUI.UIColor`
        // exposes a single `init(red:green:blue:alpha:)` and has no way to describe a
        // semantic, asset-catalogue or pattern colour. There is no value we could hand it
        // that would render correctly, so it gets opaque black and `_components` stays nil,
        // which is what makes the getters refuse instead of reporting black as the answer.
        // The black stand-in is inert as long as nothing reads the bridged `uiColor`; it
        // becomes visible the moment a `UIColor` is passed on to a SkipUI API.
        //
        // When `SkipUI.UIColor` can represent more than sRGB components, this initializer
        // should hand the matching representation across instead of flattening every colour
        // to RGBA, and `_components` should stay nil only for the colours that genuinely
        // have no components outside a composition.
        self.init(components: color.spec.rgbaComponents.map {
            (red  : CGFloat($0.red),
             green: CGFloat($0.green),
             blue : CGFloat($0.blue),
             alpha: CGFloat($0.opacity))
        })
    }

    private init(components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)?) {
        self.uiColor = SkipUI.UIColor(red: components?.red ?? 0,
                                      green: components?.green ?? 0,
                                      blue: components?.blue ?? 0,
                                      alpha: components?.alpha ?? 1)
        self._components = components
    }

    /// Semantic system background color. Use with `Color(.systemBackground)` to get the adaptive semantic color.
    public static let systemBackground: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

    @available(*, unavailable)
    public init(displayP3Red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        fatalError()
    }

    @available(*, unavailable)
    public init(cgColor: Any /* CGColor */) {
        fatalError()
    }

    @available(*, unavailable)
    public init(patternImage image: Any /* UIImage */) {
        fatalError()
    }

    @available(*, unavailable)
    public init(ciColor: Any /* CIColor */) {
        fatalError()
    }

    @available(*, unavailable)
    open class var black: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var darkGray: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var lightGray: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var white: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var gray: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var red: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var green: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var blue: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var cyan: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var yellow: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var magenta: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var orange: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var purple: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var brown: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open class var clear: UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open func set() {
        fatalError()
    }

    @available(*, unavailable)
    open func setFill() {
        fatalError()
    }

    @available(*, unavailable)
    open func setStroke() {
        fatalError()
    }

    open func getWhite(
        _ white: UnsafeMutablePointer<CGFloat>?,
        alpha: UnsafeMutablePointer<CGFloat>?,
    ) -> Bool {
        guard let components = _components else {
            return false
        }
        white?.pointee = Color.appleExtendedWhiteFrom(r: components.red, g: components.green, b: components.blue)
        alpha?.pointee = components.alpha
        return true
    }

    open func getHue(
        _ hue: UnsafeMutablePointer<CGFloat>?,
        saturation: UnsafeMutablePointer<CGFloat>?,
        brightness: UnsafeMutablePointer<CGFloat>?,
        alpha: UnsafeMutablePointer<CGFloat>?,
    ) -> Bool {
        guard let components = _components else {
            return false
        }
        let hsb = Color.hsbFrom(r: components.red, g: components.green, b: components.blue)
        hue?.pointee = hsb.h
        saturation?.pointee = hsb.s
        brightness?.pointee = hsb.b
        alpha?.pointee = components.alpha
        return true
    }

    open func getRed(
        _ red: UnsafeMutablePointer<CGFloat>?,
        green: UnsafeMutablePointer<CGFloat>?,
        blue: UnsafeMutablePointer<CGFloat>?,
        alpha: UnsafeMutablePointer<CGFloat>?,
    ) -> Bool {
        guard let components = _components else {
            return false
        }
        red?.pointee = components.red
        green?.pointee = components.green
        blue?.pointee = components.blue
        alpha?.pointee = components.alpha
        return true
    }

    @available(*, unavailable)
    open func withAlphaComponent(_ alpha: CGFloat) -> UIColor {
        fatalError()
    }

    @available(*, unavailable)
    open var cgColor: Any /* CGColor */ {
        fatalError()
    }

    @available(*, unavailable)
    open var ciColor: Any /* CIColor */ {
        fatalError()
    }
}

// MARK: -

extension UIColor {

    var colorSpec: ColorSpec {
        // Extension point: this always answers with `.rgb`, because sRGB components are the
        // only thing a `UIColor` can describe here. A colour with no components — one that
        // came from a semantic or asset-catalogue `Color` — therefore comes back as opaque
        // black, and `Color -> UIColor -> Color` loses what it was.
        //
        // The fix is deliberately not to store the originating `ColorSpec` on `UIColor`.
        // `ColorSpec` is `Color`'s own representation, and a UIKit type carrying a SwiftUI
        // type's internals inverts the layering: `UIColor` is meant to be the lower of the
        // two. It would also only paper over the loss, since the bridged `uiColor` would
        // still be black.
        //
        // The fix belongs in what a `UIColor` can represent. Once it can describe more than
        // sRGB components, map that representation onto the matching `ColorType` here — the
        // semantic cases, `.named` for an asset-catalogue colour, `.systemBackground`, a
        // pattern case — rather than always `.rgb`. At that point `Color` and `UIColor` can
        // express the same set of colours and the round trip becomes lossless in both
        // directions.
        let r = Double(_components?.red ?? 0)
        let g = Double(_components?.green ?? 0)
        let b = Double(_components?.blue ?? 0)
        let a = Double(_components?.alpha ?? 1)
        return .init(.rgb(r, g, b, a))
    }

}

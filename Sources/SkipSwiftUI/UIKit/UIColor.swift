// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import Foundation
import SkipUI

open class UIColor : NSObject /*, NSSecureCoding, NSCopying, @unchecked Sendable */ {
    let uiColor: SkipUI.UIColor

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
    }

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

    @available(*, unavailable)
    open func getWhite(_ white: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        fatalError()
    }

    @available(*, unavailable)
    open func getHue(_ hue: UnsafeMutablePointer<CGFloat>?, saturation: UnsafeMutablePointer<CGFloat>?, brightness: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        fatalError()
    }

    @available(*, unavailable)
    open func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        fatalError()
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

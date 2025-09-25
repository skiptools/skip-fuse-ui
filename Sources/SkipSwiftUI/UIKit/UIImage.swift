// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import Foundation
import SkipUI

extension UIImage {
    public enum Orientation : Int, @unchecked Sendable {
        case up = 0
        case down = 1
        case left = 2
        case right = 3
        case upMirrored = 4
        case downMirrored = 5
        case leftMirrored = 6
        case rightMirrored = 7
    }

    public enum ResizingMode : Int, @unchecked Sendable {
        case tile = 0
        case stretch = 1
    }

    public enum RenderingMode : Int, @unchecked Sendable {
        case automatic = 0
        case alwaysOriginal = 1
        case alwaysTemplate = 2
    }

    public func pngData() -> Data? {
        return uiImage.pngData()
    }

    public func jpegData(compressionQuality: CGFloat) -> Data? {
        return uiImage.jpegData(compressionQuality: compressionQuality)
    }

    @available(*, unavailable)
    public func heicData() -> Data? {
        fatalError()
    }
}

open class UIImage : NSObject /*, NSSecureCoding */, @unchecked Sendable {
    let uiImage: SkipUI.UIImage

    @available(*, unavailable)
    public /*not inherited*/ init?(systemName name: String) {
        fatalError()
    }

    @available(*, unavailable)
    public /*not inherited*/ init?(systemName name: String, withConfiguration configuration: UIImage.Configuration?) {
        fatalError()
    }

    @available(*, unavailable)
    public /*not inherited*/ init?(systemName name: String, compatibleWith traitCollection: Any /* UITraitCollection? */) {
        fatalError()
    }

    @available(*, unavailable)
    public /*not inherited*/ init?(named name: String) {
        fatalError()
    }

    @available(*, unavailable)
    public /*not inherited*/ init?(named name: String, in bundle: Bundle?, with configuration: UIImage.Configuration?) {
        fatalError()
    }

    @available(*, unavailable)
    public /*not inherited*/ init?(named name: String, in bundle: Bundle?, compatibleWith traitCollection: Any /* UITraitCollection? */) {
        fatalError()
    }

    public init?(contentsOfFile path: String) {
        #if SKIP
        // Android decode: try direct file; fall back to content Uri via ImageDecoder
        if let bitmap = android.graphics.BitmapFactory.decodeFile(path) {
            guard let bridged = SkipUI.UIImage.bridgedInit(androidBitmap: bitmap, scale: 1.0) else { return nil }
            self.uiImage = bridged
            return
        }

        let context = ProcessInfo.processInfo.androidContext
        let resolver = context.getContentResolver()
        let uri = android.net.Uri.parse(path)
        let source = android.graphics.ImageDecoder.createSource(resolver, uri)

        guard let bitmap = android.graphics.ImageDecoder.decodeBitmap(source),
              let bridged = SkipUI.UIImage.bridgedInit(androidBitmap: bitmap, scale: 1.0) else {
            return nil
        }
        self.uiImage = bridged
        return
        #else
        guard let uiImage = SkipUI.UIImage.bridgedInit(contentsOfFile: path) else {
            return nil
        }
        self.uiImage = uiImage
        #endif
    }

    public init?(data: Data, scale: CGFloat = 1.0) {
        #if SKIP
        // Android decode from bytes using ImageDecoder + ByteBuffer
        do {
            let bytes = data.kotlin(nocopy: true)
            let buffer = java.nio.ByteBuffer.wrap(bytes)
            let source = android.graphics.ImageDecoder.createSource(buffer)

            guard let bitmap = android.graphics.ImageDecoder.decodeBitmap(source),
                  let bridged = SkipUI.UIImage.bridgedInit(androidBitmap: bitmap, scale: scale) else {
                return nil
            }
            self.uiImage = bridged
            return
        } catch {
            return nil
        }
        #else
        guard let uiImage = SkipUI.UIImage.bridgedInit(data: data, scale: scale) else {
            return nil
        }
        self.uiImage = uiImage
        #endif
    }

    @available(*, unavailable)
    public init(cgImage: Any /* CGImage */) {
        fatalError()
    }

    @available(*, unavailable)
    public init(cgImage: Any /* CGImage */, scale: CGFloat, orientation: UIImage.Orientation) {
        fatalError()
    }

    @available(*, unavailable)
    public init(ciImage: Any /* CIImage */) {
        fatalError()
    }

    @available(*, unavailable)
    public init(ciImage: Any /* CIImage */, scale: CGFloat, orientation: UIImage.Orientation) {
        fatalError()
    }

    @available(*, unavailable)
    open var size: CGSize {
        fatalError()
    }

    @available(*, unavailable)
    open var cgImage: Any? /* CGImage? */ {
        fatalError()
    }

    @available(*, unavailable)
    open var ciImage: Any? /* CIImage? */ {
        fatalError()
    }

    @available(*, unavailable)
    open var imageOrientation: UIImage.Orientation {
        fatalError()
    }

    open var scale: CGFloat {
        return uiImage.scale
    }

    @available(*, unavailable)
    open var isSymbolImage: Bool {
        fatalError()
    }

    @available(*, unavailable)
    open class func animatedImageNamed(_ name: String, duration: TimeInterval) -> UIImage? {
        fatalError()
    }

    @available(*, unavailable)
    open class func animatedResizableImageNamed(_ name: String, capInsets: Any /* UIEdgeInsets */, duration: TimeInterval) -> UIImage? {
        fatalError()
    }

    @available(*, unavailable)
    open class func animatedResizableImageNamed(_ name: String, capInsets: Any /* UIEdgeInsets */, resizingMode: UIImage.ResizingMode, duration: TimeInterval) -> UIImage? {
        fatalError()
    }

    @available(*, unavailable)
    open class func animatedImage(with images: [UIImage], duration: TimeInterval) -> UIImage? {
        fatalError()
    }

    @available(*, unavailable)
    open var images: [UIImage]? {
        fatalError()
    }

    @available(*, unavailable)
    open var duration: TimeInterval {
        fatalError()
    }

    @available(*, unavailable)
    open func draw(at point: CGPoint) {
        fatalError()
    }

    @available(*, unavailable)
    open func draw(at point: CGPoint, blendMode: Any /* CGBlendMode */, alpha: CGFloat) {
        fatalError()
    }

    @available(*, unavailable)
    open func draw(in rect: CGRect) {
        fatalError()
    }

    @available(*, unavailable)
    open func draw(in rect: CGRect, blendMode: Any /* CGBlendMode */, alpha: CGFloat) {
        fatalError()
    }

    @available(*, unavailable)
    open func drawAsPattern(in rect: CGRect) {
        fatalError()
    }

    @available(*, unavailable)
    open func resizableImage(withCapInsets capInsets: Any /* UIEdgeInsets */) -> UIImage {
        fatalError()
    }

    @available(*, unavailable)
    open func resizableImage(withCapInsets capInsets: Any /* UIEdgeInsets */, resizingMode: UIImage.ResizingMode) -> UIImage {
        fatalError()
    }

    @available(*, unavailable)
    open var capInsets: Any /* UIEdgeInsets */ {
        fatalError()
    }

    @available(*, unavailable)
    open var resizingMode: UIImage.ResizingMode {
        fatalError()
    }

    @available(*, unavailable)
    open func withAlignmentRectInsets(_ alignmentInsets: Any /* UIEdgeInsets */) -> UIImage {
        fatalError()
    }

    @available(*, unavailable)
    open var alignmentRectInsets: Any /* UIEdgeInsets */ {
        fatalError()
    }

    @available(*, unavailable)
    open func withRenderingMode(_ renderingMode: UIImage.RenderingMode) -> UIImage {
        fatalError()
    }

    @available(*, unavailable)
    open var renderingMode: UIImage.RenderingMode {
        fatalError()
    }

    @available(*, unavailable)
    open var imageRendererFormat: Any /* UIGraphicsImageRendererFormat */ {
        fatalError()
    }

    @available(*, unavailable)
    /* @NSCopying */ open var traitCollection: Any /* UITraitCollection */ {
        fatalError()
    }

    @available(*, unavailable)
    open var imageAsset: Any? /* UIImageAsset? */ {
        fatalError()
    }

    @available(*, unavailable)
    open func imageFlippedForRightToLeftLayoutDirection() -> UIImage {
        fatalError()
    }

    @available(*, unavailable)
    open var flipsForRightToLeftLayoutDirection: Bool {
        fatalError()
    }

    @available(*, unavailable)
    open func withHorizontallyFlippedOrientation() -> UIImage {
        fatalError()
    }

    @available(*, unavailable)
    open func withBaselineOffset(fromBottom baselineOffset: CGFloat) -> UIImage {
        fatalError()
    }

    @available(*, unavailable)
    open func imageWithoutBaseline() -> UIImage {
        fatalError()
    }

    @available(*, unavailable)
    /* @NSCopying */ open var configuration: UIImage.Configuration? {
        fatalError()
    }

    @available(*, unavailable)
    open func withConfiguration(_ configuration: UIImage.Configuration) -> UIImage {
        fatalError()
    }

    @available(*, unavailable)
    /* @NSCopying */ open var symbolConfiguration: Any? /* UIImage.SymbolConfiguration? */ {
        fatalError()
    }

    @available(*, unavailable)
    open func applyingSymbolConfiguration(_ configuration: Any /* UIImage.SymbolConfiguration */) -> UIImage? {
        fatalError()
    }

    @available(*, unavailable)
    open func withTintColor(_ color: UIColor) -> UIImage {
        fatalError()
    }

    @available(*, unavailable)
    open func withTintColor(_ color: UIColor, renderingMode: UIImage.RenderingMode) -> UIImage {
        fatalError()
    }

    @available(*, unavailable)
    open func preparingForDisplay() -> UIImage? {
        fatalError()
    }

    @available(*, unavailable)
    open func prepareForDisplay(completionHandler: @escaping (UIImage?) -> Void) {
        fatalError()
    }

    @available(*, unavailable)
    open func byPreparingForDisplay() async -> UIImage? {
        fatalError()
    }

    @available(*, unavailable)
    open func preparingThumbnail(of size: CGSize) -> UIImage? {
        fatalError()
    }

    @available(*, unavailable)
    open func prepareThumbnail(of size: CGSize, completionHandler: @escaping (UIImage?) -> Void) {
        fatalError()
    }

    @available(*, unavailable)
    open func byPreparingThumbnail(ofSize size: CGSize) async -> UIImage? {
        fatalError()
    }

    @available(*, unavailable)
    open var isHighDynamicRange: Bool {
        fatalError()
    }

    @available(*, unavailable)
    open func imageRestrictedToStandardDynamicRange() -> UIImage {
        fatalError()
    }

    public struct Configuration {
    }
}

//extension UIImage {
//    required public convenience init(imageLiteralResourceName name: String)
//}

extension UIImage {
    @available(*, unavailable)
    public convenience init(resource: Any /* ImageResource */) {
        fatalError()
    }
}

extension UIImage {
    @available(*, unavailable)
    public var baselineOffsetFromBottom: CGFloat? {
        fatalError()
    }
}

extension UIImage {
    @available(*, unavailable)
    public convenience init?(systemName name: String, variableValue: Double, configuration: UIImage.Configuration? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    public convenience init?(named name: String, in bundle: Bundle? = nil, variableValue: Double, configuration: UIImage.Configuration? = nil) {
        fatalError()
    }
}

extension UIImage {
    @available(*, unavailable)
    public class var actions: UIImage {
        fatalError()
    }

    @available(*, unavailable)
    public class var add: UIImage {
        fatalError()
    }

    @available(*, unavailable)
    public class var remove: UIImage {
        fatalError()
    }

    @available(*, unavailable)
    public class var checkmark: UIImage {
        fatalError()
    }

    @available(*, unavailable)
    public class var strokedCheckmark: UIImage {
        fatalError()
    }
}

//extension UIImage : NSItemProviderReading, NSItemProviderWriting, UIItemProviderPresentationSizeProviding {
//}

extension UIImage {
    @available(*, unavailable)
    public func stretchableImage(withLeftCapWidth leftCapWidth: Int, topCapHeight: Int) -> UIImage {
        fatalError()
    }

    @available(*, unavailable)
    public var leftCapWidth: Int {
        fatalError()
    }

    @available(*, unavailable)
    public var topCapHeight: Int {
        fatalError()
    }
}

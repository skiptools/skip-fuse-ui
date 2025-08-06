// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import Foundation
import SkipUI

/* @frozen */ public struct Image : Equatable, Sendable {
    let spec: ImageSpec

    init(spec: ImageSpec) {
        self.spec = spec
    }

    public static func ==(lhs: Image, rhs: Image) -> Bool {
        return lhs.spec == rhs.spec
    }
}

/// Define an image.
struct ImageSpec : Equatable, Sendable {
    let type: ImageType
    public var resizingMode: Image.ResizingMode?
    public var templateRenderingMode: Image.TemplateRenderingMode?

    init(_ type: ImageType, resizingMode: Image.ResizingMode? = nil, templateRenderingMode: Image.TemplateRenderingMode? = nil) {
        self.type = type
        self.resizingMode = resizingMode
        self.templateRenderingMode = templateRenderingMode
    }
}

enum ImageType : Equatable, @unchecked Sendable {
    case named(String, Bundle?, Text?)
    case system(String)
    case decorative(String, Bundle?)
    case uiImage(UIImage)
    case java(SkipUI.Image)
}

extension Image : View {
    public typealias Body = Never
}

extension Image : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        var image: SkipUI.Image
        switch spec.type {
        case .named(let name, let bundle, let label):
            image = SkipUI.Image(name: name, isSystem: false, isDecorative: false, bridgedBundle: bundle, label: label?.Java_view as? SkipUI.Text)
        case .system(let name):
            image = SkipUI.Image(name: name, isSystem: true, isDecorative: false, bridgedBundle: nil, label: nil)
        case .decorative(let name, let bundle):
            image = SkipUI.Image(name: name, isSystem: false, isDecorative: true, bridgedBundle: bundle, label: nil)
        case .uiImage(let uiImage):
            image = SkipUI.Image(uiImage: uiImage.uiImage)
        case .java(let javaImage):
            image = javaImage
        }
        if let resizingMode = spec.resizingMode {
            image = image.resizable()
        }
        if let templateRenderingMode = spec.templateRenderingMode {
            logger.info("Applying templateRenderingMode: \(String(describing: templateRenderingMode))")
            let skipUIRenderingMode: SkipUI.Image.TemplateRenderingMode = templateRenderingMode == .template ? .template : .original
            logger.info("Converting to SkipUI renderingMode: \(String(describing: skipUIRenderingMode))")
            image = image.renderingMode(skipUIRenderingMode)
        } else {
            logger.info("No templateRenderingMode specified for image type: \(String(describing: spec.type))")
        }
        return image
    }
}

extension Image {
    public enum ResizingMode : Int, Hashable, Sendable {
        case tile = 0 // For bridging
        case stretch = 1 // For bridging
    }

    public func resizable() -> Image {
        var spec = self.spec
        spec.resizingMode = .stretch
        return Image(spec: spec)
    }
    @available(*, unavailable)
    public func resizable(capInsets: EdgeInsets) -> Image {
        fatalError()
    }
    @available(*, unavailable)
    public func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode) -> Image {
        fatalError()
    }
}

extension Image {
    @frozen public enum Orientation : UInt8, CaseIterable, Hashable {
        case up
        case upMirrored
        case down
        case downMirrored
        case left
        case leftMirrored
        case right
        case rightMirrored
    }
}

extension Image {
    public enum Interpolation : Hashable, Sendable {
        case none
        case low
        case medium
        case high
    }
}

extension Image {
    public func interpolation(_ interpolation: Image.Interpolation) -> Image {
        return self
    }

    public func antialiased(_ isAntialiased: Bool) -> Image {
        return self
    }
}

extension Image {
    @available(*, unavailable)
    public init(_ cgImage: Any /* CGImage */, scale: CGFloat, orientation: Image.Orientation = .up, label: Text) {
        fatalError()
    }

    @available(*, unavailable)
    public init(decorative cgImage: Any /* CGImage */, scale: CGFloat, orientation: Image.Orientation = .up) {
        fatalError()
    }
}

extension Image {
    public func renderingMode(_ renderingMode: Image.TemplateRenderingMode?) -> Image {
        logger.info("Image.renderingMode called with: \(String(describing: renderingMode))")
        var spec = self.spec
        spec.templateRenderingMode = renderingMode
        return Image(spec: spec)
    }
}

extension Image {
    public init(_ name: String, bundle: Bundle? = nil) {
        self.init(spec: .init(.named(name, bundle, nil)))
    }

    public init(_ name: String, bundle: Bundle? = nil, label: Text) {
        self.init(spec: .init(.named(name, bundle, label)))
    }

    public init(decorative name: String, bundle: Bundle? = nil) {
        self.init(spec: .init(.decorative(name, bundle)))
    }

    public init(systemName: String) {
        self.init(spec: .init(.system(systemName)))
    }
}

extension Image {
    @available(*, unavailable)
    public init(systemName: String, variableValue: Double?) {
        fatalError()
    }

    @available(*, unavailable)
    public init(_ name: String, variableValue: Double?, bundle: Bundle? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    public init(_ name: String, variableValue: Double?, bundle: Bundle? = nil, label: Text) {
        fatalError()
    }

    @available(*, unavailable)
    public init(decorative name: String, variableValue: Double?, bundle: Bundle? = nil) {
        fatalError()
    }
}

//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//extension Image {
//    public init(_ resource: ImageResource)
//}

extension Image {
    public struct DynamicRange : Hashable, Sendable {
        public static let standard = DynamicRange()
        public static let constrainedHigh = DynamicRange()
        public static let high = DynamicRange()
    }

    public func allowedDynamicRange(_ range: Image.DynamicRange?) -> Image {
        return self
    }
}

extension Image {
    @available(*, unavailable)
    public init(size: CGSize, label: Text? = nil, opaque: Bool = false, colorMode: ColorRenderingMode = .nonLinear, renderer: @escaping (inout Any /* GraphicsContext */) -> Void) {
        fatalError()
    }
}

extension Image {
    public enum TemplateRenderingMode : Hashable, Sendable {
        case template
        case original
    }

    public enum Scale : Hashable, Sendable {
        case small
        case medium
        case large
    }
}

extension Image {
    public init(uiImage: UIImage) {
        self.init(spec: .init(.uiImage(uiImage)))
    }
}

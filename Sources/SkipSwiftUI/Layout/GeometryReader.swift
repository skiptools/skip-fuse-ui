// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

public struct GeometryProxy {
    private let javaProxy: SkipUI.GeometryProxy

    init(javaProxy: SkipUI.GeometryProxy) {
        self.javaProxy = javaProxy
        let (width, height) = javaProxy.bridgedSize
        self.size = CGSize(width: width, height: height)
    }

    public let size: CGSize

    @available(*, unavailable)
    public subscript<T>(anchor: Any /* Anchor<T> */) -> T {
        fatalError()
    }

    public var safeAreaInsets: EdgeInsets {
        let (top, leading, bottom, trailing) = javaProxy.bridgedSafeAreaInsets
        return EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

    public func frame(in coordinateSpace: CoordinateSpace) -> CGRect {
        var name: SwiftHashable? = nil
        if case .named(let n) = coordinateSpace {
            name = Java_swiftHashable(for: n)
        }
        let (x, y, width, height) = javaProxy.frame(bridgedCoordinateSpace: coordinateSpace.identifier, name: name)
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

extension GeometryProxy {
    @available(*, unavailable)
    public func bounds(of coordinateSpace: NamedCoordinateSpace) -> CGRect? {
        fatalError()
    }

    public func frame(in coordinateSpace: some CoordinateSpaceProtocol) -> CGRect {
        return frame(in: coordinateSpace.coordinateSpace)
    }
}

@frozen public struct GeometryReader<Content> where Content : View {
    public var content: (GeometryProxy) -> Content

    /* @inlinable */public init(@ViewBuilder content: @escaping (GeometryProxy) -> Content) {
        self.content = content
    }
}

extension GeometryReader : View {
    public typealias Body = Never
}

extension GeometryReader : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.GeometryReader(content: { javaProxy in
            content(GeometryProxy(javaProxy: javaProxy)).Java_viewOrEmpty
        })
    }
}

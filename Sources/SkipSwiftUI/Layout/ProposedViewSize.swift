// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif

@frozen public struct ProposedViewSize : Equatable /*, BitwiseCopyable, Sendable */ {
    public var width: CGFloat?
    public var height: CGFloat?

    public static let zero = ProposedViewSize(width: 0, height: 0)

    public static let unspecified = ProposedViewSize(width: nil, height: nil)

    public static let infinity = ProposedViewSize(width: .infinity, height: .infinity)

    @inlinable public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }

    @inlinable public init(_ size: CGSize) {
        self.width = size.width
        self.height = size.height
    }

    @inlinable public func replacingUnspecifiedDimensions(by size: CGSize = CGSize(width: 10, height: 10)) -> CGSize {
        return CGSize(width: width == nil ? size.width : width!, height: height == nil ? size.height : height!)
    }
}

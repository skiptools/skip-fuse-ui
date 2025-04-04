// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if ROBOLECTRIC || !canImport(CoreGraphics)
#if canImport(Darwin)
import Darwin
#elseif canImport(Android)
import Android
#endif

public typealias CGFloat = Double

public struct CGPoint : Hashable {
    public static let zero = CGPoint()
    public var x: Double
    public var y: Double

    public init(x: Double = 0.0, y: Double = 0.0) {
        self.x = x
        self.y = y
    }

    public func applying(_ transform: CGAffineTransform) -> CGPoint {
        let px = transform.a * x + transform.c * y + transform.tx
        let py = transform.b * x + transform.d * y + transform.ty
        return CGPoint(x: px, y: py)
    }
}

public struct CGSize : Hashable {
    public static let zero = CGSize()
    public var width: Double
    public var height: Double

    public init(width: Double = 0.0, height: Double = 0.0) {
        self.width = width
        self.height = height
    }

    public func applying(_ transform: CGAffineTransform) -> CGSize {
        let swidth  = transform.a * width + transform.c * height
        let sheight = transform.b * width + transform.d * height
        return CGSize(width: swidth, height: sheight)
    }
}

public struct CGRect : Hashable {
    public static let zero = CGRect()
    public static let null = CGRect(x: .infinity, y: .infinity, width: 0.0, height: 0.0)
    public static let infinite = CGRect(x: -Double.infinity / 2.0, y: -Double.infinity / 2.0, width: Double.infinity, height: Double.infinity)
    public var origin: CGPoint
    public var size: CGSize

    public init(origin: CGPoint = .zero, size: CGSize = .zero) {
        self.origin = origin
        self.size = size
    }

    public init(x: Double, y: Double, width: Double, height: Double) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }

    public init(x: Int, y: Int, width: Int, height: Int) {
        self.init(origin: CGPoint(x: Double(x), y: Double(y)), size: CGSize(width: Double(width), height: Double(height)))
    }

    public var height: CGFloat {
        get {
            return size.height
        }
        set {
            size.height = newValue
        }
    }

    public var width: CGFloat {
        get {
            return size.width
        }
        set {
            size.width = newValue
        }
    }

    public var minX: CGFloat {
        return width >= 0.0 ? origin.x : origin.x + width
    }

    public var midX: CGFloat {
        return (minX + maxX) / 2.0
    }

    public var maxX: CGFloat {
        return width >= 0.0 ? origin.x + width : origin.x
    }

    public var minY: CGFloat {
        return height >= 0.0 ? origin.y : origin.y + height
    }

    public var midY: CGFloat {
        return (minY + maxY) / 2.0
    }

    public var maxY: CGFloat {
        return height >= 0.0 ? origin.y + height : origin.y
    }

    public var standardized: CGRect {
        return CGRect(x: minX, y: minY, width: abs(width), height: abs(height))
    }

    public var integral: CGRect {
        if isInfinite || isNull {
            return self
        }
        let rect = standardized
        return CGRect(x: floor(rect.minX), y: floor(rect.minY), width: ceil(rect.width), height: ceil(rect.height))
    }

    public func applying(_ transform: CGAffineTransform) -> CGRect {
        if isInfinite || isNull {
            return self
        }
        return CGRect(origin: origin.applying(transform), size: size.applying(transform))
    }

    public func insetBy(dx: CGFloat, dy: CGFloat) -> CGRect {
        if isInfinite || isNull {
            return self
        }
        let rect = standardized
        return CGRect(x: rect.minX + dx, y: rect.minY + dy, width: rect.width - dx * 2.0, height: rect.height - dy * 2.0)
    }

    public func offsetBy(dx: CGFloat, dy: CGFloat) -> CGRect {
        if isInfinite || isNull {
            return self
        }
        let rect = standardized
        return CGRect(x: rect.minX + dx, y: rect.minY + dy, width: rect.width, height: rect.height)
    }

    public func union(_ other: CGRect) -> CGRect {
        if other.isEmpty {
            return self
        } else if isEmpty {
            return other
        }
        if other.isInfinite || isInfinite {
            return .infinite
        }
        let rect1 = standardized
        let rect2 = other.standardized
        let minX = min(rect1.minX, rect2.minX)
        let maxX = max(rect1.maxX, rect2.maxX)
        let minY = min(rect1.minY, rect2.minY)
        let maxY = max(rect1.maxY, rect2.maxY)
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    public func intersection(_ other: CGRect) -> CGRect {
        if other.isEmpty || isEmpty {
            return .null
        }
        if other.isInfinite {
            return self
        } else if isInfinite {
            return other
        }
        let rect1 = standardized
        let rect2 = other.standardized
        let minX = max(rect1.minX, rect2.minX)
        let maxX = min(rect1.maxX, rect2.maxX)
        let minY = max(rect1.minY, rect2.minY)
        let maxY = min(rect1.maxY, rect2.maxY)
        return CGRect(x: minX, y: minY, width: max(0.0, maxX - minX), height: max(0.0, maxY - minY))
    }

    public func intersects(_ other: CGRect) -> Bool {
        return !intersection(other).isEmpty
    }

    public func contains(_ point: CGPoint) -> Bool {
        let rect = standardized
        return point.x >= rect.minX && point.x <= rect.maxX && point.y >= rect.minY && point.y <= rect.maxY
    }

    public func contains(_ rect: CGRect) -> Bool {
        return intersection(rect) == rect
    }

    public var isEmpty: Bool {
        return width == 0.0 && height == 0.0
    }

    public var isInfinite: Bool {
        return self == .infinite
    }

    public var isNull: Bool {
        return self == .null
    }
}

public struct CGAffineTransform : Codable, Equatable {
    public var a = 1.0
    public var b = 0.0
    public var c = 0.0
    public var d = 1.0
    public var tx = 0.0
    public var ty = 0.0

    public static let identity = CGAffineTransform()

    public init() {
    }

    public init(a: Double, b: Double, c: Double, d: Double, tx: Double, ty: Double) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.tx = tx
        self.ty = ty
    }

    public init(a: Float, b: Float, c: Float, d: Float, tx: Float, ty: Float) {
        self.a = Double(a)
        self.b = Double(b)
        self.c = Double(c)
        self.d = Double(d)
        self.tx = Double(tx)
        self.ty = Double(ty)
    }

    public init(rotationAngle: CGFloat) {
        let sinus = sin(rotationAngle)
        let cosinus = cos(rotationAngle)
        a = cosinus
        b = sinus
        c = -sinus
        d = cosinus
    }

    public init(scaleX: CGFloat, y: CGFloat) {
        a = scaleX
        d = y
    }

    public init(translationX: CGFloat, y: CGFloat) {
        tx = translationX
        ty = y
    }

    public var isIdentity: Bool {
        return self == Self.identity
    }

    public func concatenating(_ transform: CGAffineTransform) -> CGAffineTransform {
        var result = CGAffineTransform()
        result.a = transform.a * a + transform.b * c
        result.b = transform.a * b + transform.b * d
        result.c = transform.c * a + transform.d * c
        result.d = transform.c * b + transform.d * d
        result.tx = transform.tx * a + transform.ty * c + tx
        result.ty = transform.tx * b + transform.ty * d + ty
        return result
    }

    public func inverted() -> CGAffineTransform {
        let determinant = a * d - c * b
        if determinant == 0.0 {
            return self
        }

        var result = CGAffineTransform()
        result.a = d  / determinant
        result.b = -b  / determinant
        result.c = -c  / determinant
        result.d = a  / determinant
        result.tx = (-d * tx + c * ty) / determinant;
        result.ty = (b * tx - a * ty) / determinant;
        return result
    }

    public func rotated(by angle: CGFloat) -> CGAffineTransform {
        return concatenating(CGAffineTransform(rotationAngle: angle))
    }

    public func scaledBy(x: CGFloat, y: CGFloat) -> CGAffineTransform {
        return concatenating(CGAffineTransform(scaleX: x, y: y))
    }

    public func translatedBy(x: CGFloat, y: CGFloat) -> CGAffineTransform {
        return concatenating(CGAffineTransform(translationX: x, y: y))
    }
}

public struct CGVector : Equatable {
    public var dx = 0.0
    public var dy = 0.0
}

public enum CGLineCap : Int {
    case butt = 0 // For bridging
    case round = 1 // For bridging
    case square = 2 // For bridging

}

public enum CGLineJoin : Int {
    case miter = 0 // For bridging
    case round = 1 // For bridging
    case bevel = 2 // For bridging
}

#endif

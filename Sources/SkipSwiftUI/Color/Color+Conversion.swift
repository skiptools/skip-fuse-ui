// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

extension Color {

    static func hsbFrom(
        r: CGFloat,
        g: CGFloat,
        b: CGFloat,
    ) -> (h: CGFloat, s: CGFloat, b: CGFloat) {
        let maximum = max(r, g, b)
        let minimum = min(r, g, b)
        let chroma = maximum - minimum

        guard chroma > 0 else {
            // An achromatic colour has no hue to report; UIKit reports zero for it too.
            return (0.0, 0.0, maximum)
        }

        let sextant: Double = if maximum == r {
            (g - b) / chroma
        } else if maximum == g {
            (b - r) / chroma + 2.0
        } else {
            (r - g) / chroma + 4.0
        }

        var hue = sextant / 6.0
        if hue < 0.0 {
            hue += 1.0
        }

        return (h: hue, s: maximum > 0 ? chroma / maximum : 0.0, b: maximum)
    }

    static func rgbFrom(
        h: Double,
        s: Double,
        b: Double,
    ) -> (r: Double, g: Double, b: Double) {
        let hue = min(max(h, 0.0), 1.0) * 6.0
        let saturation = min(max(s, 0.0), 1.0)
        let brightness = min(max(b, 0.0), 1.0)

        let chroma = brightness * saturation
        let secondary = chroma * (1.0 - abs(hue.truncatingRemainder(dividingBy: 2.0) - 1.0))
        let base = brightness - chroma

        let rgb: (Double, Double, Double) = switch Int(hue) {
        case 0: (chroma, secondary, 0.0)
        case 1: (secondary, chroma, 0.0)
        case 2: (0.0, chroma, secondary)
        case 3: (0.0, secondary, chroma)
        case 4: (secondary, 0.0, chroma)
        default: (chroma, 0.0, secondary)
        }

        return (r: rgb.0 + base, g: rgb.1 + base, b: rgb.2 + base)
    }

    static func appleExtendedWhiteFrom(
        r: CGFloat,
        g: CGFloat,
        b: CGFloat,
    ) -> CGFloat {
        let toLinear: (CGFloat) -> CGFloat = { x in
            let sign: CGFloat = x < 0 ? -1.0 : 1.0
            let absX = abs(x)

            if absX <= 0.04045 {
                return x / 12.92
            } else {
                return sign * pow((absX + 0.055) / 1.055, 2.4)
            }
        }

        let rLinear = toLinear(r)
        let gLinear = toLinear(g)
        let bLinear = toLinear(b)

        let wR: CGFloat = 0.2225045
        let wG: CGFloat = 0.7168787
        let wB: CGFloat = 0.0606168

        let yLinear = (rLinear * wR) + (gLinear * wG) + (bLinear * wB)

        let toGammaCorrected: (CGFloat) -> CGFloat = { y in
            let sign: CGFloat = y < 0 ? -1.0 : 1.0
            let absY = abs(y)

            if absY <= 0.0031308 {
                return y * 12.92
            } else {
                return sign * (1.055 * pow(absY, 1.0 / 2.4) - 0.055)
            }
        }

        return toGammaCorrected(yLinear)
    }
}

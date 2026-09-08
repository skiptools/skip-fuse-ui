// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
#if !SKIP
@testable import SkipSwiftUI
#endif

final class ColorComponentsTests: XCTestCase {

    #if !SKIP

    func testRGBSpecReportsItsComponentsUnchanged() throws {
        let components = try XCTUnwrap(ColorSpec(.rgb(0.25, 0.5, 0.75, 0.5)).rgbaComponents)

        XCTAssertEqual(components.red, 0.25, accuracy: 0.0001)
        XCTAssertEqual(components.green, 0.5, accuracy: 0.0001)
        XCTAssertEqual(components.blue, 0.75, accuracy: 0.0001)
        XCTAssertEqual(components.opacity, 0.5, accuracy: 0.0001)
    }

    func testWhiteSpecForwardsWhiteToEveryChannel() throws {
        let components = try XCTUnwrap(ColorSpec(.w(0.4, 0.5)).rgbaComponents)

        XCTAssertEqual(components.red, 0.4, accuracy: 0.0001)
        XCTAssertEqual(components.green, 0.4, accuracy: 0.0001)
        XCTAssertEqual(components.blue, 0.4, accuracy: 0.0001)
        XCTAssertEqual(components.opacity, 0.5, accuracy: 0.0001)
    }

    func testSpecOpacityMultipliesTheComponentOpacity() throws {
        let components = try XCTUnwrap(ColorSpec(.rgb(1, 0, 0, 0.5), opacity: 0.5).rgbaComponents)

        XCTAssertEqual(components.red, 1, accuracy: 0.0001)
        XCTAssertEqual(components.opacity, 0.25, accuracy: 0.0001)
    }

    func testHSBSpecConvertsEverySextantToRGB() throws {
        let cases: [(hue: Double, expected: (Double, Double, Double))] = [
            (0.0, (1, 0, 0)),
            (1.0 / 6.0, (1, 1, 0)),
            (1.0 / 3.0, (0, 1, 0)),
            (0.5, (0, 1, 1)),
            (2.0 / 3.0, (0, 0, 1)),
            (5.0 / 6.0, (1, 0, 1)),
            (1.0, (1, 0, 0)),
        ]

        for (hue, expected) in cases {
            let components = try XCTUnwrap(ColorSpec(.hsb(hue, 1, 1, 1)).rgbaComponents)

            XCTAssertEqual(components.red, expected.0, accuracy: 0.0001, "hue \(hue)")
            XCTAssertEqual(components.green, expected.1, accuracy: 0.0001, "hue \(hue)")
            XCTAssertEqual(components.blue, expected.2, accuracy: 0.0001, "hue \(hue)")
        }
    }

    func testHSBSpecClampsOutOfRangeInput() throws {
        let above = try XCTUnwrap(ColorSpec(.hsb(2.0, 2.0, 2.0, 1)).rgbaComponents)

        XCTAssertEqual(above.red, 1, accuracy: 0.0001)
        XCTAssertEqual(above.green, 0, accuracy: 0.0001)
        XCTAssertEqual(above.blue, 0, accuracy: 0.0001)

        let below = try XCTUnwrap(ColorSpec(.hsb(-1.0, -1.0, -1.0, 1)).rgbaComponents)

        XCTAssertEqual(below.red, 0, accuracy: 0.0001)
        XCTAssertEqual(below.green, 0, accuracy: 0.0001)
        XCTAssertEqual(below.blue, 0, accuracy: 0.0001)
    }

    func testCompositionResolvedSpecsHaveNoComponents() {
        let types: [ColorType] = [
            .accent, .primary, .secondary,
            .red, .orange, .yellow, .green, .mint, .teal, .cyan,
            .blue, .indigo, .purple, .pink, .brown,
            .white, .gray, .black, .clear,
            .named("Brand", nil),
            .systemBackground,
            .saturate(ColorSpec(.rgb(1, 0, 0, 1)), 1.5),
        ]

        for type in types {
            XCTAssertNil(ColorSpec(type).rgbaComponents, "\(type) should not claim components")
            XCTAssertNil(ColorSpec(type, opacity: 0.5).rgbaComponents, "\(type) should not claim components")
        }
    }

    func testHSBFromInvertsRGBFromAroundTheWheel() {
        for step in 0..<12 {
            let hue = Double(step) / 12.0
            let rgb = Color.rgbFrom(h: hue, s: 1, b: 1)
            let hsb = Color.hsbFrom(r: rgb.r, g: rgb.g, b: rgb.b)

            XCTAssertEqual(hsb.h, hue, accuracy: 0.0001, "hue \(hue)")
            XCTAssertEqual(hsb.s, 1, accuracy: 0.0001, "hue \(hue)")
            XCTAssertEqual(hsb.b, 1, accuracy: 0.0001, "hue \(hue)")
        }
    }

    func testHSBFromReportsNoHueOrSaturationForGreys() {
        let hsb = Color.hsbFrom(r: 0.6, g: 0.6, b: 0.6)

        XCTAssertEqual(hsb.h, 0, accuracy: 0.0001)
        XCTAssertEqual(hsb.s, 0, accuracy: 0.0001)
        XCTAssertEqual(hsb.b, 0.6, accuracy: 0.0001)
    }

    func testHSBFromReportsZeroBrightnessForBlack() {
        let hsb = Color.hsbFrom(r: 0, g: 0, b: 0)

        XCTAssertEqual(hsb.h, 0, accuracy: 0.0001)
        XCTAssertEqual(hsb.s, 0, accuracy: 0.0001)
        XCTAssertEqual(hsb.b, 0, accuracy: 0.0001)
    }

    func testAppleExtendedWhiteMatchesAppleGrayConversion() {
        XCTAssertEqual(Color.appleExtendedWhiteFrom(r: 1, g: 0, b: 0), 0.509031, accuracy: 0.0001)
        XCTAssertEqual(Color.appleExtendedWhiteFrom(r: 0, g: 1, b: 0), 0.863387, accuracy: 0.0001)
        XCTAssertEqual(Color.appleExtendedWhiteFrom(r: 0, g: 0, b: 1), 0.273079, accuracy: 0.0001)
        XCTAssertEqual(Color.appleExtendedWhiteFrom(r: 0.25, g: 0.5, b: 0.75), 0.480501, accuracy: 0.0001)
    }

    func testAppleExtendedWhitePreservesGreys() {
        XCTAssertEqual(Color.appleExtendedWhiteFrom(r: 0.3, g: 0.3, b: 0.3), 0.3, accuracy: 0.0001)
        XCTAssertEqual(Color.appleExtendedWhiteFrom(r: 0.02, g: 0.02, b: 0.02), 0.02, accuracy: 0.0001)
        XCTAssertEqual(Color.appleExtendedWhiteFrom(r: 0, g: 0, b: 0), 0, accuracy: 0.0001)
        XCTAssertEqual(Color.appleExtendedWhiteFrom(r: 1, g: 1, b: 1), 1, accuracy: 0.0001)
    }

    func testAppleExtendedWhiteHandlesExtendedRangeComponents() {
        XCTAssertEqual(Color.appleExtendedWhiteFrom(r: -0.2, g: 0, b: 0), -0.081332, accuracy: 0.0001)
        XCTAssertEqual(Color.appleExtendedWhiteFrom(r: -0.02, g: -0.02, b: -0.02), -0.02, accuracy: 0.0001)
    }

    func testGetRedReadsBackLiteralComponents() throws {
        let color = SkipSwiftUI.UIColor(SkipSwiftUI.Color(red: 0.25, green: 0.5, blue: 0.75, opacity: 0.5))
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1

        XCTAssertTrue(color.getRed(&r, green: &g, blue: &b, alpha: &a))
        XCTAssertEqual(r, 0.25, accuracy: 0.0001)
        XCTAssertEqual(g, 0.5, accuracy: 0.0001)
        XCTAssertEqual(b, 0.75, accuracy: 0.0001)
        XCTAssertEqual(a, 0.5, accuracy: 0.0001)
    }

    func testGetRedReadsBackTheRGBAInitializer() throws {
        let color = SkipSwiftUI.UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 0.4)
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1

        XCTAssertTrue(color.getRed(&r, green: &g, blue: &b, alpha: &a))
        XCTAssertEqual(r, 0.1, accuracy: 0.0001)
        XCTAssertEqual(g, 0.2, accuracy: 0.0001)
        XCTAssertEqual(b, 0.3, accuracy: 0.0001)
        XCTAssertEqual(a, 0.4, accuracy: 0.0001)
    }

    func testOpacityModifierCompoundsIntoAlpha() throws {
        let color = SkipSwiftUI.UIColor(SkipSwiftUI.Color(red: 1, green: 0, blue: 0, opacity: 0.5).opacity(0.5))
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1

        XCTAssertTrue(color.getRed(&r, green: &g, blue: &b, alpha: &a))
        XCTAssertEqual(r, 1, accuracy: 0.0001)
        XCTAssertEqual(a, 0.25, accuracy: 0.0001)
    }

    func testWhiteForwardsToEveryChannel() throws {
        let color = SkipSwiftUI.UIColor(SkipSwiftUI.Color(white: 0.4))
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1

        XCTAssertTrue(color.getRed(&r, green: &g, blue: &b, alpha: &a))
        XCTAssertEqual(r, 0.4, accuracy: 0.0001)
        XCTAssertEqual(g, 0.4, accuracy: 0.0001)
        XCTAssertEqual(b, 0.4, accuracy: 0.0001)
        XCTAssertEqual(a, 1, accuracy: 0.0001)
    }

    func testHueSaturationBrightnessConvertsToRGB() throws {
        // Primaries sit at hue 0, 1/3 and 2/3 of the way round the wheel.
        let cases: [(hue: Double, expected: (CGFloat, CGFloat, CGFloat))] = [
            (0.0, (1, 0, 0)),
            (1.0 / 3.0, (0, 1, 0)),
            (2.0 / 3.0, (0, 0, 1)),
        ]

        for (hue, expected) in cases {
            let color = SkipSwiftUI.UIColor(SkipSwiftUI.Color(hue: hue, saturation: 1, brightness: 1))
            var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1

            XCTAssertTrue(color.getRed(&r, green: &g, blue: &b, alpha: &a))
            XCTAssertEqual(r, expected.0, accuracy: 0.0001, "hue \(hue)")
            XCTAssertEqual(g, expected.1, accuracy: 0.0001, "hue \(hue)")
            XCTAssertEqual(b, expected.2, accuracy: 0.0001, "hue \(hue)")
        }
    }

    func testGreyBrightnessHasNoChroma() throws {
        let color = SkipSwiftUI.UIColor(SkipSwiftUI.Color(hue: 0.5, saturation: 0, brightness: 0.6))
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1

        XCTAssertTrue(color.getRed(&r, green: &g, blue: &b, alpha: &a))
        XCTAssertEqual(r, 0.6, accuracy: 0.0001)
        XCTAssertEqual(g, 0.6, accuracy: 0.0001)
        XCTAssertEqual(b, 0.6, accuracy: 0.0001)
    }

    func testGetHueInvertsTheHSBConversion() throws {
        let cases: [(hue: Double, saturation: Double, brightness: Double)] = [
            (0.0, 1.0, 1.0),
            (1.0 / 3.0, 1.0, 1.0),
            (2.0 / 3.0, 0.5, 0.75),
            (0.125, 0.9, 0.4),
            (0.875, 0.25, 1.0),
        ]

        for expected in cases {
            let color = SkipSwiftUI.UIColor(SkipSwiftUI.Color(hue: expected.hue, saturation: expected.saturation, brightness: expected.brightness))
            var h: CGFloat = -1, s: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1

            XCTAssertTrue(color.getHue(&h, saturation: &s, brightness: &b, alpha: &a))
            XCTAssertEqual(h, expected.hue, accuracy: 0.0001, "hue for \(expected)")
            XCTAssertEqual(s, expected.saturation, accuracy: 0.0001, "saturation for \(expected)")
            XCTAssertEqual(b, expected.brightness, accuracy: 0.0001, "brightness for \(expected)")
            XCTAssertEqual(a, 1, accuracy: 0.0001)
        }
    }

    func testGetHueReportsNoHueForAnAchromaticColour() throws {
        let color = SkipSwiftUI.UIColor(SkipSwiftUI.Color(white: 0.6))
        var h: CGFloat = -1, s: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1

        XCTAssertTrue(color.getHue(&h, saturation: &s, brightness: &b, alpha: &a))
        XCTAssertEqual(h, 0, accuracy: 0.0001)
        XCTAssertEqual(s, 0, accuracy: 0.0001)
        XCTAssertEqual(b, 0.6, accuracy: 0.0001)
    }

    func testGetHueCarriesAlphaThrough() throws {
        let color = SkipSwiftUI.UIColor(SkipSwiftUI.Color(red: 1, green: 0, blue: 0, opacity: 0.25))
        var h: CGFloat = -1, s: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1

        XCTAssertTrue(color.getHue(&h, saturation: &s, brightness: &b, alpha: &a))
        XCTAssertEqual(a, 0.25, accuracy: 0.0001)
    }

    func testGetWhiteReadsAGreyBackUnchanged() throws {
        var w: CGFloat = -1, a: CGFloat = -1

        XCTAssertTrue(SkipSwiftUI.UIColor(SkipSwiftUI.Color(white: 0.3, opacity: 0.5)).getWhite(&w, alpha: &a))
        XCTAssertEqual(w, 0.3, accuracy: 0.0001)
        XCTAssertEqual(a, 0.5, accuracy: 0.0001)
    }

    func testGetWhiteConvertsAChromaticColourToItsAppleGrey() throws {
        var w: CGFloat = -1, a: CGFloat = -1

        XCTAssertTrue(SkipSwiftUI.UIColor(SkipSwiftUI.Color(red: 1, green: 0, blue: 0)).getWhite(&w, alpha: &a))
        XCTAssertEqual(w, 0.509031, accuracy: 0.0001)
        XCTAssertEqual(a, 1, accuracy: 0.0001)
    }

    func testCompositionResolvedColoursReportNoComponents() throws {
        // These resolve through MaterialTheme or the asset catalogue inside a @Composable,
        // so there is nothing to read outside one — and nothing may be written back.
        let colors: [SkipSwiftUI.Color] = [
            .red,
            .primary,
            .accentColor,
            SkipSwiftUI.Color("Brand"),
            SkipSwiftUI.Color(spec: .init(.saturate(ColorSpec(.rgb(1, 0, 0, 1)), 1.5))),
        ]

        for color in colors {
            var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1

            XCTAssertFalse(SkipSwiftUI.UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a),
                           "\(color) should not claim components")
            XCTAssertEqual(r, -1, "pointers must be left untouched on failure")
            XCTAssertEqual(g, -1)
            XCTAssertEqual(b, -1)
            XCTAssertEqual(a, -1)
        }
    }

    func testComponentReadersAllRefuseCompositionResolvedColours() throws {
        let color = SkipSwiftUI.UIColor(SkipSwiftUI.Color.primary)
        var x: CGFloat = -1, y: CGFloat = -1, z: CGFloat = -1, w: CGFloat = -1

        XCTAssertFalse(color.getRed(&x, green: &y, blue: &z, alpha: &w))
        XCTAssertFalse(color.getHue(&x, saturation: &y, brightness: &z, alpha: &w))
        XCTAssertFalse(color.getWhite(&x, alpha: &y))

        XCTAssertEqual(x, -1, "pointers must be left untouched on failure")
        XCTAssertEqual(y, -1)
        XCTAssertEqual(z, -1)
        XCTAssertEqual(w, -1)
    }

    func testComponentReadersAcceptNilPointers() throws {
        let readable = SkipSwiftUI.UIColor(SkipSwiftUI.Color(red: 1, green: 0, blue: 0))

        XCTAssertTrue(readable.getRed(nil, green: nil, blue: nil, alpha: nil))
        XCTAssertTrue(readable.getHue(nil, saturation: nil, brightness: nil, alpha: nil))
        XCTAssertTrue(readable.getWhite(nil, alpha: nil))

        let unreadable = SkipSwiftUI.UIColor(SkipSwiftUI.Color.primary)

        XCTAssertFalse(unreadable.getRed(nil, green: nil, blue: nil, alpha: nil))
        XCTAssertFalse(unreadable.getHue(nil, saturation: nil, brightness: nil, alpha: nil))
        XCTAssertFalse(unreadable.getWhite(nil, alpha: nil))
    }

    func testLiteralColoursKeepTheirComponentsThroughTheUIColorRoundTrip() throws {
        let colors: [SkipSwiftUI.Color] = [
            SkipSwiftUI.Color(red: 0.1, green: 0.2, blue: 0.3),
            SkipSwiftUI.Color(white: 0.4).opacity(0.5),
            SkipSwiftUI.Color(hue: 0.25, saturation: 0.6, brightness: 0.8, opacity: 0.75),
        ]

        for color in colors {
            let expected = try XCTUnwrap(color.spec.rgbaComponents)
            let actual = try XCTUnwrap(SkipSwiftUI.Color(SkipSwiftUI.UIColor(color)).spec.rgbaComponents)

            XCTAssertEqual(actual.red, expected.red, accuracy: 0.0001, "\(color)")
            XCTAssertEqual(actual.green, expected.green, accuracy: 0.0001, "\(color)")
            XCTAssertEqual(actual.blue, expected.blue, accuracy: 0.0001, "\(color)")
            XCTAssertEqual(actual.opacity, expected.opacity, accuracy: 0.0001, "\(color)")
        }
    }

    func testRGBColoursKeepTheirSpecThroughTheUIColorRoundTrip() throws {
        let color = SkipSwiftUI.Color(red: 0.1, green: 0.2, blue: 0.3, opacity: 0.4)

        XCTAssertEqual(SkipSwiftUI.Color(SkipSwiftUI.UIColor(color)), color)
    }

    func testColorFromAnRGBAUIColorKeepsItsComponents() throws {
        let uiColor = SkipSwiftUI.UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 0.4)

        XCTAssertEqual(SkipSwiftUI.Color(uiColor), SkipSwiftUI.Color(red: 0.1, green: 0.2, blue: 0.3, opacity: 0.4))
    }

    func testCompositionResolvedColoursAreLostThroughTheUIColorRoundTrip() throws {
        let colors: [SkipSwiftUI.Color] = [.red, .primary, .accentColor, SkipSwiftUI.Color("Brand")]

        for color in colors {
            XCTAssertEqual(SkipSwiftUI.Color(SkipSwiftUI.UIColor(color)),
                           SkipSwiftUI.Color(spec: .init(.rgb(0, 0, 0, 1))),
                           "\(color)")
        }
    }

    func testSystemBackgroundStillResolvesToItsSemanticColour() throws {
        XCTAssertEqual(SkipSwiftUI.Color(SkipSwiftUI.UIColor.systemBackground),
                       SkipSwiftUI.Color(spec: .init(.systemBackground)))
    }
    #endif
}

// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
#if !SKIP
@testable import SkipSwiftUI
#endif

final class SkipSwiftUITests: XCTestCase {
    func testSkipUI() throws {
        XCTAssertEqual(3, 1 + 2)
    }

    #if !SKIP
    func testAccessibilityOptionSetEmptyInitDoesNotRecurse() throws {
        // `init() { self = [] }` recursed infinitely: for an OptionSet, `[]` is built
        // via `init()`. `init(rawValue: 0)` breaks the cycle (issue #130).
        XCTAssertEqual(AccessibilityTraits().rawValue, 0)
        XCTAssertEqual(AccessibilityTechnologies().rawValue, 0)
        // OptionSet semantics still work without the redundant SetAlgebra conformance.
        XCTAssertTrue(AccessibilityTraits([.isButton, .isHeader]).contains(.isButton))
    }

    func testTypedEnvironmentKeyPathsRemainAvailable() throws {
        let legibilityWeightKeyPath: WritableKeyPath<EnvironmentValues, LegibilityWeight?> = \.legibilityWeight
        let colorSchemeContrastKeyPath: WritableKeyPath<EnvironmentValues, ColorSchemeContrast> = \.colorSchemeContrast
        let reduceMotionKeyPath: WritableKeyPath<EnvironmentValues, Bool> = \.accessibilityReduceMotion
        let voiceOverKeyPath: WritableKeyPath<EnvironmentValues, Bool> = \.accessibilityVoiceOverEnabled

        XCTAssertEqual("legibilityWeight", EnvironmentValues.key(for: legibilityWeightKeyPath))
        XCTAssertEqual("colorSchemeContrast", EnvironmentValues.key(for: colorSchemeContrastKeyPath))
        XCTAssertEqual("accessibilityReduceMotion", EnvironmentValues.key(for: reduceMotionKeyPath))
        XCTAssertEqual("accessibilityVoiceOverEnabled", EnvironmentValues.key(for: voiceOverKeyPath))
    }

    func testEnvironmentBuiltinsBridgeTypedAccessibilityAndContrastValues() throws {
        XCTAssertEqual(EnvironmentValues.bridgeBuiltin(key: "accessibilityReduceMotion", value: true) as? Bool, true)
        XCTAssertEqual(EnvironmentValues.builtin(key: "accessibilityReduceMotion", bridgedValue: true) as? Bool, true)

        XCTAssertEqual(
            EnvironmentValues.bridgeBuiltin(key: "colorSchemeContrast", value: ColorSchemeContrast.increased) as? Int,
            ColorSchemeContrast.increased.rawValue
        )
        XCTAssertEqual(
            EnvironmentValues.builtin(key: "colorSchemeContrast", bridgedValue: ColorSchemeContrast.increased.rawValue) as? ColorSchemeContrast,
            .increased
        )

        let bridgedLegibilityWeight = EnvironmentValues.bridgeBuiltin(key: "legibilityWeight", value: LegibilityWeight.bold)
        XCTAssertEqual(
            EnvironmentValues.builtin(key: "legibilityWeight", bridgedValue: bridgedLegibilityWeight) as? LegibilityWeight,
            .bold
        )
    }
    #endif
}

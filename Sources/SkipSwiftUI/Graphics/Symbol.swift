// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

/// Symbol variants that can be applied to SF Symbols.
/// Uses a bit flag internally to combine variants.
public struct SymbolVariants : RawRepresentable, Hashable, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    // Bit flags for each variant type (must match skip-ui)
    private static let fillBit = 1 << 0      // 1
    private static let circleBit = 1 << 1    // 2
    private static let squareBit = 1 << 2    // 4
    private static let rectangleBit = 1 << 3 // 8
    private static let slashBit = 1 << 4     // 16

    public static let none = SymbolVariants(rawValue: 0)
    public static let fill = SymbolVariants(rawValue: fillBit)
    public static let circle = SymbolVariants(rawValue: circleBit)
    public static let square = SymbolVariants(rawValue: squareBit)
    public static let rectangle = SymbolVariants(rawValue: rectangleBit)
    public static let slash = SymbolVariants(rawValue: slashBit)

    /// Combine with fill variant
    public var fill: SymbolVariants {
        return SymbolVariants(rawValue: rawValue | Self.fillBit)
    }

    /// Combine with circle variant
    public var circle: SymbolVariants {
        return SymbolVariants(rawValue: rawValue | Self.circleBit)
    }

    /// Combine with square variant
    public var square: SymbolVariants {
        return SymbolVariants(rawValue: rawValue | Self.squareBit)
    }

    /// Combine with rectangle variant
    public var rectangle: SymbolVariants {
        return SymbolVariants(rawValue: rawValue | Self.rectangleBit)
    }

    /// Combine with slash variant
    public var slash: SymbolVariants {
        return SymbolVariants(rawValue: rawValue | Self.slashBit)
    }

    /// Check if this variant contains another variant
    public func contains(_ other: SymbolVariants) -> Bool {
        return (rawValue & other.rawValue) == other.rawValue
    }
}

public enum SymbolRenderingMode : Int, Sendable {
    case monochrome = 0
    case multicolor = 1
    case hierarchical = 2
    case palette = 3
}

public struct SymbolVariableValueMode : Equatable, Sendable {
    public static let color = SymbolVariableValueMode()
    public static let draw = SymbolVariableValueMode()
}

public struct SymbolColorRenderingMode : Equatable, Sendable {
    public static let flat = SymbolColorRenderingMode()
    public static let gradient = SymbolColorRenderingMode()
}

extension View {
    @available(*, unavailable)
    nonisolated public func symbolEffect(_ effect: Any, options: Any? = nil /* SymbolEffectOptions = .default */, isActive: Bool = true) -> some View {
        return stubView()
    }

    @available(*, unavailable)
    nonisolated public func symbolEffect(_ effect: Any, options: Any? = nil /* SymbolEffectOptions = .default */, value: Any) -> some View {
        return stubView()
    }

    @available(*, unavailable)
    nonisolated public func symbolRenderingMode(_ mode: SymbolRenderingMode?) -> some View {
        return stubView()
    }

    nonisolated public func symbolVariant(_ variant: SymbolVariants) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.symbolVariant(bridgedRawValue: variant.rawValue)
        }
    }

    @available(*, unavailable)
    nonisolated public func symbolVariableValueMode(_ mode: SymbolVariableValueMode?) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func symbolColorRenderingMode(_ mode: SymbolColorRenderingMode?) -> some View {
        stubView()
    }
}

extension Image {
    @available(*, unavailable)
    public func symbolRenderingMode(_ mode: SymbolRenderingMode?) -> Image {
        fatalError()
    }

    @available(*, unavailable)
    public func symbolVariableValueMode(_ mode: SymbolVariableValueMode?) -> Image {
        fatalError()
    }

    @available(*, unavailable)
    public func symbolColorRenderingMode(_ mode: SymbolColorRenderingMode?) -> Image {
        fatalError()
    }
}

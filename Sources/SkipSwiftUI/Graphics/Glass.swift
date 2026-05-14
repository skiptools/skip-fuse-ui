// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif

public struct Glass : Equatable, Sendable {
    public static var regular: Glass {
        return Glass()
    }

    public func tint(_ color: Color?) -> Glass {
        return self
    }

    public func interactive(_ isEnabled: Bool = true) -> Glass {
        return self
    }
}

@MainActor @preconcurrency public struct GlassEffectContainer<Content> : View, Sendable where Content : View {
    @available(*, unavailable)
    public init(spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
    }

    public var body: some View {
        EmptyView()
    }
}

public struct GlassEffectTransition : Sendable {
    @available(*, unavailable)
    public static var matchedGeometry: GlassEffectTransition {
        return GlassEffectTransition()
    }

    @available(*, unavailable)
    public static func matchedGeometry(properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center) -> GlassEffectTransition {
        return GlassEffectTransition()
    }

    public static var identity: GlassEffectTransition {
        return GlassEffectTransition()
    }
}

extension View {
    @available(*, unavailable)
    nonisolated public func glassEffect(_ glass: Glass = .regular, in shape: some Shape = .capsule, isEnabled: Bool = true) -> some View {
        stubView()
    }

    @MainActor @preconcurrency public func glassEffectTransition(_ transition: GlassEffectTransition, isEnabled: Bool = true) -> some View {
        // We only support .identity
        return self
    }

    @available(*, unavailable)
    @MainActor @preconcurrency public func glassEffectUnion(id: (some Hashable & Sendable)?, namespace: Namespace.ID) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func glassEffectID(_ id: (some Hashable & Sendable)?, in namespace: Namespace.ID) -> some View {
        stubView()
    }
}

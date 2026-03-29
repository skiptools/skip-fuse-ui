// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

/// The placement of content margins.
public enum ContentMarginPlacement: Int {
    case automatic = 0
    case scrollContent = 1
    case scrollIndicators = 2
}

/// Holds the content margin values for each placement type.
public struct ContentMargins {
    public var automatic: EdgeInsets?
    public var scrollContent: EdgeInsets?
    public var scrollIndicators: EdgeInsets?

    public init(automatic: EdgeInsets? = nil, scrollContent: EdgeInsets? = nil, scrollIndicators: EdgeInsets? = nil) {
        self.automatic = automatic
        self.scrollContent = scrollContent
        self.scrollIndicators = scrollIndicators
    }

    /// Returns the effective content margin for the given placement.
    public func effectiveContentMargin(for placement: ContentMarginPlacement) -> EdgeInsets? {
        switch placement {
        case .automatic:
            return scrollContent ?? automatic
        case .scrollContent:
            return scrollContent ?? automatic
        case .scrollIndicators:
            return scrollIndicators ?? automatic
        }
    }
}


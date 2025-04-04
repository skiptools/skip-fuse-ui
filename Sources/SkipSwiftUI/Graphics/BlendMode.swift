// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public enum BlendMode : Hashable /*, Sendable */ {
    case normal
    case multiply
    case screen
    case overlay
    case darken
    case lighten
    case colorDodge
    case colorBurn
    case softLight
    case hardLight
    case difference
    case exclusion
    case hue
    case saturation
    case color
    case luminosity
    case sourceAtop
    case destinationOver
    case destinationOut
    case plusDarker
    case plusLighter
}

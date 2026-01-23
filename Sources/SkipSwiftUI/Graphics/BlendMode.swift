// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public enum BlendMode : Int, Hashable, Sendable {
    case normal = 0
    case multiply = 1
    case screen = 2
    case overlay = 3
    case darken = 4
    case lighten = 5
    case colorDodge = 6
    case colorBurn = 7
    case softLight = 8
    case hardLight = 9
    case difference = 10
    case exclusion = 11
    case hue = 12
    case saturation = 13
    case color = 14
    case luminosity = 15
    case sourceAtop = 16
    case destinationOver = 17
    case destinationOut = 18
    case plusDarker = 19
    case plusLighter = 20
}

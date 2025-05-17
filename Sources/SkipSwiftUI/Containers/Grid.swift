// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

public struct GridItem : Sendable {
    public enum Size : Sendable {
        case fixed(CGFloat)
        case flexible(minimum: CGFloat = 10, maximum: CGFloat = .infinity)
        case adaptive(minimum: CGFloat, maximum: CGFloat = .infinity)
    }

    public var size: GridItem.Size

    public var spacing: CGFloat?

    public var alignment: Alignment?

    public init(_ size: GridItem.Size = .flexible(), spacing: CGFloat? = nil, alignment: Alignment? = nil) {
        self.size = size
        self.spacing = spacing
        self.alignment = alignment
    }
}

extension GridItem {
    var Java_gridItem: SkipUI.GridItem {
        let javaSize: SkipUI.GridItem.Size
        switch size {
        case .fixed(let value):
            javaSize = SkipUI.GridItem.Size.fixed(value)
        case .flexible(minimum: let minimum, maximum: let maximum):
            javaSize = SkipUI.GridItem.Size.flexible(minimum: minimum, maximum: maximum)
        case .adaptive(minimum: let minimum, maximum: let maximum):
            javaSize = SkipUI.GridItem.Size.adaptive(minimum: minimum, maximum: maximum)
        }
        return SkipUI.GridItem(size: javaSize, spacing: spacing, horizontalAlignmentKey: alignment?.horizontal.key, verticalAlignmentKey: alignment?.vertical.key)
    }
}

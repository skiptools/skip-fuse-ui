// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public struct TextInputAutocapitalization /* : Sendable */ {
    let identifier: Int

    public static var never: TextInputAutocapitalization {
        return TextInputAutocapitalization(identifier: 0) // For bridging
    }

    public static var words: TextInputAutocapitalization {
        return TextInputAutocapitalization(identifier: 1) // For bridging
    }

    public static var sentences: TextInputAutocapitalization {
        return TextInputAutocapitalization(identifier: 2) // For bridging
    }

    public static var characters: TextInputAutocapitalization {
        return TextInputAutocapitalization(identifier: 3) // For bridging
    }
}

//extension TextInputAutocapitalization {
//    public init?(_ type: UITextAutocapitalizationType)
//}

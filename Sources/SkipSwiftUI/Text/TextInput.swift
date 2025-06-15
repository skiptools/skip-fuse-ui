// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public struct TextInputAutocapitalization : Sendable {
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

public struct TextInputFormattingControlPlacement : Sendable {
    public struct Set : OptionSet, Sendable {
        public let rawValue: UInt

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        public static let contextMenu = TextInputFormattingControlPlacement.Set(rawValue: 1 << 0)
        public static let inputAssistant = TextInputFormattingControlPlacement.Set(rawValue: 1 << 1)
        public static let all = TextInputFormattingControlPlacement.Set(rawValue: 1 << 2)
        public static let `default` = TextInputFormattingControlPlacement.Set(rawValue: 1 << 3)
    }
}

extension View {
    nonisolated public func textInputAutocapitalization(_ autocapitalization: TextInputAutocapitalization?) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.textInputAutocapitalization(bridgedAutocapitalization: autocapitalization?.identifier)
        }
    }

    @available(*, unavailable)
    @MainActor @preconcurrency public func textInputFormattingControlVisibility(_ visibility: Visibility, for placement: TextInputFormattingControlPlacement.Set) -> some View {
        stubView()
    }
}

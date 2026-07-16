// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

extension View {
    /// Isolates this subtree in a retained Android composition root.
    ///
    /// Non-Android platforms return the original view. On Android, the detached root updates its
    /// child content only when `inputs` changes. Include every parent-driven value that should
    /// refresh the subtree in `inputs`.
    nonisolated public func androidCompositionBoundary(id: String, inputs: String = "") -> some View {
        #if os(Android)
        return ModifierView(target: self) { target in
            return SkipUI.AndroidCompositionBoundary(
                id: id,
                inputs: inputs,
                bridgedContentFactory: { target.Java_viewOrEmpty }
            )
        }
        #else
        return self
        #endif
    }
}

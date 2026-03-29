// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SkipUI

extension View {
    @available(*, unavailable)
    nonisolated public func userActivity(_ activityType: String, isActive: Bool = true, _ update: @escaping (Any /* NSUserActivity */) -> ()) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func userActivity<P>(_ activityType: String, element: P?, _ update: @escaping (P, Any /* NSUserActivity */) -> ()) -> some View {
        stubView()
    }

    @available(*, unavailable)
    nonisolated public func onContinueUserActivity(_ activityType: String, perform action: @escaping (Any /* NSUserActivity */) -> ()) -> some View {
        stubView()
    }

    nonisolated public func onOpenURL(perform action: @escaping (URL) -> Void) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onOpenURLString(perform: {
                if let url = URL(string: $0) {
                    action(url)
                }
            })
        }
    }

    @MainActor @preconcurrency  public func onOpenURL(prefersInApp: Bool) -> some View {
        return self
    }
}

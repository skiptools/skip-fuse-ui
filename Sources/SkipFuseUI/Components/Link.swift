// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipUI

/* @MainActor @preconcurrency */ public struct Link<Label> : View where Label : View {
    private let destination: URL
    private let label: Label

    /* nonisolated */ public init(destination: URL, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }

    public typealias Body = Never
}

extension Link : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Link(destination: destination, bridgedLabel: label.Java_viewOrEmpty)
    }
}

extension Link where Label == Text {
    /* nonisolated */ public init(_ titleKey: LocalizedStringKey, destination: URL) {
        self.init(destination: destination, label: { Text(titleKey) })
    }

    /* nonisolated */ public init<S>(_ title: S, destination: URL) where S : StringProtocol {
        self.init(destination: destination, label: { Text(title) })
    }
}

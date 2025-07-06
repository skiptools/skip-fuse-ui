// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipFuse
import SkipUI

public struct Link<Label> where Label : View {
    private let destination: URL
    private let label: Label

    nonisolated public init(destination: URL, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
}

extension Link : View {
    public typealias Body = Never
}

extension Link : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Link(destination: destination, bridgedLabel: label.Java_viewOrEmpty)
    }
}

extension Link where Label == Text {
    public init(_ titleKey: LocalizedStringKey, destination: URL) {
        self.init(destination: destination, label: { Text(titleKey) })
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, destination: URL) {
        self.init(destination: destination, label: { Text(titleResource) })
    }

    @_disfavoredOverload public init<S>(_ title: S, destination: URL) where S : StringProtocol {
        self.init(destination: destination, label: { Text(title) })
    }
}

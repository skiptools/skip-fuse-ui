// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipBridge
import SkipUI

extension View {
    /* nonisolated */ public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10, perform action: @escaping () -> Void, onPressingChanged: ((Bool) -> Void)? = nil) -> some View {
        return ModifierView(target: self) {
            if let onPressingChanged {
                $0.Java_viewOrEmpty.onLongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance, perform: action, onPressingChanged: onPressingChanged)
            } else {
                $0.Java_viewOrEmpty.onLongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance, perform: action)
            }
        }
    }

    /* nonisolated */ public func onLongPressGesture(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10, pressing: ((Bool) -> Void)? = nil, perform action: @escaping () -> Void) -> some View {
        return onLongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance, perform: action, onPressingChanged: pressing)
    }

    /* nonisolated */ public func onTapGesture(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        return onTapGesture(count: count, coordinateSpace: .local, perform: { _ in action() })
    }

    /* nonisolated */ public func onTapGesture(count: Int = 1, coordinateSpace: CoordinateSpace = .local, perform action: @escaping (CGPoint) -> Void) -> some View {
        var name: SwiftHashable? = nil
        if case .named(let n) = coordinateSpace {
            name = Java_swiftHashable(for: n)
        }
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onTapGesture(count: count, bridgedCoordinateSpace: coordinateSpace.identifier, name: name, perform: { action(CGPoint(x: $0, y: $1)) })
        }
    }

    /* nonisolated */ public func onTapGesture(count: Int = 1, coordinateSpace: some CoordinateSpaceProtocol = .local, perform action: @escaping (CGPoint) -> Void) -> some View {
        var name: SwiftHashable? = nil
        if case .named(let n) = coordinateSpace.coordinateSpace {
            name = Java_swiftHashable(for: n)
        }
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.onTapGesture(count: count, bridgedCoordinateSpace: coordinateSpace.coordinateSpace.identifier, name: name, perform: { action(CGPoint(x: $0, y: $1)) })
        }
    }
}

// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import Foundation
import SkipBridge
import SkipUI

extension View {
    /// Lets the user long-press and drag `payload` to a drop destination.
    ///
    /// Payloads travel as text, so they also drop into other apps; within the app, drops receive the original value.
    nonisolated public func draggable<T>(_ payload: @autoclosure @escaping () -> T) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.draggable(bridgedPayload: { Java_dragPayload(payload()) })
        }
    }

    /// Accepts dropped payloads of the given type; `location` is in this view's coordinate space.
    nonisolated public func dropDestination<T>(for payloadType: T.Type = T.self, action: @escaping (_ items: [T], _ location: CGPoint) -> Bool, isTargeted: @escaping (Bool) -> Void = { _ in }) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.dropDestination(bridgedAccepts: { Java_dropItem($0, as: T.self) != nil }, bridgedAction: { items, x, y in
                return action(items.compactMap { Java_dropItem($0, as: T.self) }, CGPoint(x: x, y: y))
            }, isTargeted: isTargeted)
        }
    }
}

extension DynamicViewContent {
    /// Accepts payloads dropped onto a `List`'s rows, inserting above or below the row under the drop.
    nonisolated public func dropDestination<T>(for payloadType: T.Type = T.self, action: @escaping ([T], Int) -> Void) -> some DynamicViewContent {
        guard var forEach = self as? any ForEachProtocol else {
            return self
        }
        forEach.onDrop = ForEachDropAction(accepts: { Java_dropItem($0, as: T.self) != nil }, action: { items, index in
            action(items.compactMap { Java_dropItem($0, as: T.self) }, index)
        })
        return forEach as! Self
    }
}

/// A `ForEach` row drop target.
struct ForEachDropAction {
    let accepts: (Any) -> Bool
    let action: ([Any], Int) -> Void
}

/// Identifies a dragged value, so in-app drops receive the original rather than its text.
private struct DragPayload : Hashable {
    let id = UUID()
    let value: Any

    static func ==(lhs: DragPayload, rhs: DragPayload) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

private func Java_dragPayload(_ payload: Any) -> SwiftHashable {
    return SwiftHashable(DragPayload(value: payload), description: { String(describing: payload) })
}

/// A dropped in-app payload, or another app's dropped text.
private func Java_dropItem<T>(_ item: Any, as type: T.Type) -> T? {
    if let payload = (item as? SwiftHashable)?.value as? DragPayload {
        return payload.value as? T
    }
    return item as? T
}

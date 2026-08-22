// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SkipUI

/// Retains one projected child per live Compose boundary instance and input value.
internal final class AndroidCompositionBoundaryProjectionRegistry<Projection>: @unchecked Sendable {
    private struct Entry {
        let inputs: String
        let projection: Projection
    }

    private let lock = NSLock()
    private var entries: [String: Entry] = [:]

    /// Reuses the installed projection while a boundary's explicit inputs are unchanged.
    internal func prepare(
        instanceID: String,
        inputs: String,
        create: () -> Projection
    ) -> Projection {
        lock.lock()
        if let entry = entries[instanceID], entry.inputs == inputs {
            lock.unlock()
            return entry.projection
        }
        lock.unlock()

        // Projection can bridge a large view graph, so do that work outside the registry lock.
        let projection = create()
        lock.lock()
        defer { lock.unlock() }
        if let entry = entries[instanceID], entry.inputs == inputs {
            return entry.projection
        }
        let entry = Entry(inputs: inputs, projection: projection)
        entries[instanceID] = entry
        return entry.projection
    }

    /// Releases a projection when the owning Compose boundary leaves the hierarchy.
    internal func release(instanceID: String) {
        lock.lock()
        defer { lock.unlock() }
        entries.removeValue(forKey: instanceID)
    }
}

/// Owns a projection factory only until SkipUI prepares the current Compose instance.
internal final class AndroidCompositionBoundaryProjectionSource<Projection>: @unchecked Sendable {
    private let lock = NSLock()
    private var create: (() -> Projection)?

    internal init(create: @escaping () -> Projection) {
        self.create = create
    }

    /// Prepares the instance projection, then drops the captured native view graph.
    internal func prepare(
        in registry: AndroidCompositionBoundaryProjectionRegistry<Projection>,
        instanceID: String,
        inputs: String
    ) -> Projection {
        lock.lock()
        let create = self.create
        lock.unlock()

        let prepared = registry.prepare(instanceID: instanceID, inputs: inputs) {
            guard let create else {
                preconditionFailure("Missing projection source for changed boundary inputs")
            }
            return create()
        }

        lock.lock()
        self.create = nil
        lock.unlock()
        return prepared
    }
}

#if os(Android)
private let androidCompositionBoundaryProjectionRegistry =
    AndroidCompositionBoundaryProjectionRegistry<any SkipUI.View>()
#endif

extension View {
    /// Gives this subtree its own retained identity and lifecycle on Android.
    ///
    /// Think of the boundary as a separate hosting container. Keeping `id` stable preserves that
    /// container and its state. Changing `inputs` updates content inside the existing container;
    /// changing `id` disposes it and creates a new one. State owned inside the boundary can update
    /// independently without changing `inputs`. The boundary inherits environment values and is
    /// transparent to parent measurement: new constraints remeasure the same retained host and
    /// child rather than changing their identity.
    ///
    /// Use this for content such as a WebView, map, or video surface that needs an independently
    /// retained lifecycle. To only skip reevaluating ordinary UI while a value remains equal, use
    /// `androidEquatable(recomposeOverride:)`.
    ///
    /// Non-Android platforms return the original view.
    nonisolated public func androidCompositionBoundary(id: String, inputs: String = "") -> some View {
        #if os(Android)
        return ModifierView(target: self) { target in
            let projectionSource = AndroidCompositionBoundaryProjectionSource {
                target.Java_viewOrEmpty
            }
            return SkipUI.AndroidCompositionBoundary(
                id: id,
                inputs: inputs,
                bridgedProjectionLifecycle: { instanceID, isDisposing in
                    if isDisposing {
                        androidCompositionBoundaryProjectionRegistry.release(instanceID: instanceID)
                        return SkipUI.EmptyView()
                    }
                    return projectionSource.prepare(
                        in: androidCompositionBoundaryProjectionRegistry,
                        instanceID: instanceID,
                        inputs: inputs
                    )
                }
            )
        }
        #else
        return self
        #endif
    }
}

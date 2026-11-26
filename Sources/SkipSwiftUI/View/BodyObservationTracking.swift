// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipFuse

/// Evaluates a bridged view's `body` (and its conversion to a Kotlin view) inside
/// `withObservationTracking`, so any `Observable` type read there invalidates the calling
/// composable when it changes, including types built on the stock `Observation` module that
/// never touch Skip's bridged registrar.
///
/// Each evaluation makes one JNI call: `skip.model.trackBodyInvalidation()` subscribes the
/// current recompose scope to a fresh Compose state and returns its id. `onChange` captures only
/// that id, so a pending tracking holds no JNI reference.
// Note: Observation has no way to cancel a pending tracking, so registrations for properties
// that never change stay in their model's registrar (Swift memory only) until the property changes
// or the model deinits. Fixing that needs a cancellable one-shot tracking API in Observation.
public func Java_withBodyObservationTracking<T>(_ apply: () -> T) -> T {
    #if SKIP_BRIDGE
    // Nested reads already land in the enclosing tracking (Observation merges access lists).
    guard BodyObservationTracking.isEnabled, trackingDepth == 0, let id = BodyInvalidation.track() else {
        return apply()
    }
    trackingDepth += 1
    defer { trackingDepth -= 1 }
    return ObservationModule.withObservationTrackingFunc(apply, onChange: { BodyInvalidation.invalidate(id) })
    #else
    return apply()
    #endif
}

// Note: one global depth, assumes bodies and Compose reads run on the main thread;
// make it thread-local if off-main view evaluation ever happens.
nonisolated(unsafe) private var trackingDepth = 0

/// Controls whether bridged view bodies (and content evaluated after them, such as lazy
/// `ForEach` items and `Binding` reads from Compose) are run inside `withObservationTracking`.
///
/// With tracking on, any `Observable` type read during evaluation refreshes the view when it
/// changes — including types that are not Skip-aware, such as those from third-party packages.
/// Set `isEnabled` to `false` early in app startup to fall back to tracking only Skip-aware types.
public enum BodyObservationTracking {
    nonisolated(unsafe) public static var isEnabled = true
}

#if SKIP_BRIDGE
private enum BodyInvalidation {
    private static let Java_class = try? JClass(name: "skip/model/BodyInvalidationKt")
    private static let Java_track = Java_class?.getStaticMethodID(name: "trackBodyInvalidation", sig: "()I")
    private static let Java_invalidate = Java_class?.getStaticMethodID(name: "invalidateBody", sig: "(I)V")

    /// Subscribes the current recompose scope to a fresh state; returns its id.
    static func track() -> Int32? {
        jniContext {
            guard let cls = Java_class, let method = Java_track else { return nil }
            let id: Int32 = try! cls.callStatic(method: method, options: [], args: [])
            return id
        }
    }

    /// May run on any thread (onChange fires on the writer's thread), so the IDs are resolved
    /// inside `jniContext`, which attaches the thread to the JVM.
    static func invalidate(_ id: Int32) {
        jniContext {
            guard let cls = Java_class, let method = Java_invalidate else { return }
            try! cls.callStatic(method: method, options: [], args: [id.toJavaParameter(options: [])])
        }
    }
}
#endif

// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

/// Native support for the transpiled `SkipSwiftUISamplesTests` Compose UI tests.
public final class SkipSwiftUITestSupport {
    /// Prepare a JVM-hosted (Robolectric) test environment for bridged main-actor calls.
    ///
    /// On Android the main looper drains the dispatch main queue, so the main-actor
    /// assumptions made by bridged calls hold on the UI thread and this is a no-op. A JVM
    /// hosted on a development OS has no such integration: Robolectric runs everything on a
    /// JVM test thread that is never the platform main queue, so the first bridged call into
    /// `@MainActor` API would trap in the runtime's last-resort `checkIsolated` check.
    /// Installing a no-op `swift_task_checkIsolated_hook` makes the runtime treat that check
    /// as satisfied; Robolectric tests are effectively single-threaded, so the assumption is
    /// sound in practice.
    ///
    /// Returns false when the relaxation could not be installed (a host Swift runtime that
    /// predates the hook); callers should skip bridged-UI tests in that case rather than crash.
    public static func prepareJVMHostedTesting() -> Bool {
        #if os(Android)
        return true
        #else
        #if canImport(Darwin)
        let defaultHandle = UnsafeMutableRawPointer(bitPattern: -2) // RTLD_DEFAULT
        #else
        let defaultHandle: UnsafeMutableRawPointer? = nil // RTLD_DEFAULT
        #endif
        guard let hook = dlsym(defaultHandle, "swift_task_checkIsolated_hook") else {
            return false
        }
        // The hook is `SWIFT_CC(swift) (SerialExecutorRef, original) -> Void`: two register
        // words plus the original-function pointer, all ignored by the no-op, so a
        // C-convention function with matching register usage is ABI-compatible.
        let noop: @convention(c) (UnsafeRawPointer?, UnsafeRawPointer?, UnsafeRawPointer?) -> Void = { _, _, _ in }
        hook.assumingMemoryBound(to: UnsafeRawPointer?.self).pointee = unsafeBitCast(noop, to: UnsafeRawPointer?.self)
        return true
        #endif
    }
}

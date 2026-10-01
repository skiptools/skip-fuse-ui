// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
/// Native support for the transpiled `SkipSwiftUISamplesTests` Compose UI tests.
public final class SkipSwiftUITestSupport {
    /// Whether the current test environment supports bridged main-actor calls.
    ///
    /// On Android the main looper drains the dispatch main queue, so the main-actor
    /// assumptions made by bridged calls hold on the UI thread. A JVM hosted on a development
    /// OS has no such integration: Robolectric's UI thread is not Swift's main executor, so
    /// entering generated `@MainActor` bridge code would trap.
    ///
    /// Callers should skip bridged-UI tests when this returns false and run them on an Android
    /// device or emulator by setting `ANDROID_SERIAL`.
    public static func prepareJVMHostedTesting() -> Bool {
        #if os(Android)
        return true
        #else
        return false
        #endif
    }
}

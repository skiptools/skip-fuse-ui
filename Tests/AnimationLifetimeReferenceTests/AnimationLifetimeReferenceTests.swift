// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if os(macOS)
import AppKit
import SwiftUI
import XCTest
import SkipSwiftUISamples

/// Reference behavior from Apple's renderer, measuring colored pixels rather than model targets.
@MainActor final class AnimationLifetimeReferenceTests: XCTestCase {
    func testStateSiblingsAnimateThenPlainDragSnaps() async throws {
        try await checkReference(useObservable: false)
    }

    func testObservableSiblingsAnimateThenPlainDragSnaps() async throws {
        try await checkReference(useObservable: true)
    }

    func testStateDeferredConsumer() async throws {
        try await checkReference(useObservable: false, deferred: true)
    }

    func testObservableDeferredConsumer() async throws {
        try await checkReference(useObservable: true, deferred: true)
    }

    func testStatePlainDragInterruptsAnimation() async throws {
        try await checkReference(useObservable: false, interrupt: true)
    }

    func testObservablePlainDragInterruptsAnimation() async throws {
        try await checkReference(useObservable: true, interrupt: true)
    }

    /// Two already-mounted hosting roots read one model, with no delayed mutation or read.
    func testSharedObservableAcrossHostingRoots() async throws {
        _ = NSApplication.shared
        let driver = SharedAnimationLifetimeDriver()
        let hosts = [
            NSHostingView(rootView: SharedAnimationLifetimeConsumer(driver: driver, first: true)),
            NSHostingView(rootView: SharedAnimationLifetimeConsumer(driver: driver, first: false))
        ]
        let windows = hosts.enumerated().map { index, host in
            let window = NSWindow(contentRect: NSRect(x: 40 + index * 160, y: 40, width: 120, height: 360),
                                  styleMask: [.borderless], backing: .buffered, defer: false)
            window.isReleasedWhenClosed = false
            window.contentView = host
            window.orderBack(nil)
            return window
        }
        defer { windows.forEach { $0.close() } }
        func readPositions() throws -> [Double] {
            try hosts.enumerated().map { index, host in
                try positions(host, requiredColor: index)[index]
            }
        }
        try await Task.sleep(for: .milliseconds(250))
        let initial = try readPositions()
        for cycle in 0..<2 {
            driver.animateAnchor()
            try await Task.sleep(for: .milliseconds(300))
            let middle = try readPositions()
            try await Task.sleep(for: .milliseconds(900))
            let end = try readPositions()
            driver.advanceDrag()
            try await Task.sleep(for: .milliseconds(80))
            let drag = try readPositions()
            print("animation-lifetime reference roots cycle=\(cycle) initial=\(initial) mid=\(middle) end=\(end) drag=\(drag)")
            for index in 0..<2 {
                let start = Double(cycle * 120)
                XCTAssertGreaterThan(middle[index] - initial[index], start + 5)
                XCTAssertLessThan(middle[index] - initial[index], start + 75)
                XCTAssertEqual(end[index] - initial[index], start + 80, accuracy: 2)
                XCTAssertEqual(drag[index] - initial[index], start + 120, accuracy: 2)
            }
        }
    }

    private func checkReference(useObservable: Bool, deferred: Bool = false, interrupt: Bool = false) async throws {
        _ = NSApplication.shared
        let driver = AnimationLifetimeDriver()
        let host = NSHostingView(rootView: AnimationLifetimeFixture(driver: driver, useObservable: useObservable, deferSecondConsumer: deferred))
        let window = NSWindow(contentRect: NSRect(x: 40, y: 40, width: 300, height: 440),
                              styleMask: [.borderless], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.contentView = host
        window.orderBack(nil)
        defer { window.close() }
        try await Task.sleep(for: .milliseconds(250))
        XCTAssertTrue(driver.isReady)
        let initial = try positions(host)

        driver.animateAnchor()
        try await Task.sleep(for: .milliseconds(300))
        let middle = try positions(host)
        for index in 0..<2 {
            XCTAssertGreaterThan(middle[index] - initial[index], 5)
            XCTAssertLessThan(middle[index] - initial[index], 75)
        }
        if interrupt {
            driver.advanceDrag()
            try await Task.sleep(for: .milliseconds(80))
            let interrupted = try positions(host)
            try await Task.sleep(for: .milliseconds(1100))
            let final = try positions(host)
            for index in 0..<2 {
                // Apple applies the plain +40 immediately while the anchor's existing
                // linear animation advances about another 6.4 points over these 80 ms.
                XCTAssertGreaterThan(interrupted[index] - middle[index], 35)
                XCTAssertLessThan(interrupted[index] - middle[index], 55)
                XCTAssertEqual(final[index] - initial[index], 120, accuracy: 2)
            }
            print("animation-lifetime reference interrupt observable=\(useObservable) mid=\(middle) interrupted=\(interrupted) final=\(final)")
            return
        }
        try await Task.sleep(for: .milliseconds(900))
        let settled = try positions(host)
        for index in 0..<2 { XCTAssertEqual(settled[index] - initial[index], 80, accuracy: 2) }

        for step in 1...3 {
            driver.advanceDrag()
            // Several display frames, comfortably shorter than the one-second animation.
            try await Task.sleep(for: .milliseconds(80))
            let dragged = try positions(host)
            for index in 0..<2 {
                XCTAssertEqual(dragged[index] - initial[index], Double(80 + step * 40), accuracy: 2)
            }
        }

        // Reusing the same animation specification must still animate a genuinely new write.
        driver.animateAnchor()
        try await Task.sleep(for: .milliseconds(300))
        let repeated = try positions(host)
        for index in 0..<2 {
            XCTAssertGreaterThan(repeated[index] - initial[index], 205)
            XCTAssertLessThan(repeated[index] - initial[index], 275)
        }
        try await Task.sleep(for: .milliseconds(900))
        let final = try positions(host)
        for index in 0..<2 { XCTAssertEqual(final[index] - initial[index], 280, accuracy: 2) }
        print("animation-lifetime reference observable=\(useObservable) deferred=\(deferred) initial=\(initial) mid=\(middle) settled=\(settled) repeated=\(repeated) final=\(final)")
    }

    /// Locate both solid-color rectangles in a rendered bitmap; missing pixels fail the test.
    private func positions(_ host: NSView, requiredColor: Int? = nil) throws -> [Double] {
        host.layoutSubtreeIfNeeded()
        let bitmap = try XCTUnwrap(host.bitmapImageRepForCachingDisplay(in: host.bounds))
        host.cacheDisplay(in: host.bounds, to: bitmap)
        var first: Int?
        var second: Int?
        for y in 0..<bitmap.pixelsHigh {
            for x in stride(from: 0, to: bitmap.pixelsWide, by: 3) {
                guard let color = bitmap.colorAt(x: x, y: y)?.usingColorSpace(.deviceRGB) else { continue }
                // Semantic colors differ across display color spaces; identify the dominant
                // channel instead of assuming Apple's red has nearly zero green and blue.
                if color.alphaComponent > 0.9 && color.redComponent > 0.7 && color.redComponent > color.greenComponent * 1.5 && color.redComponent > color.blueComponent * 1.5 {
                    first = first ?? y
                }
                if color.alphaComponent > 0.9 && color.greenComponent > 0.5 && color.greenComponent > color.redComponent * 1.5 && color.greenComponent > color.blueComponent * 1.5 {
                    second = second ?? y
                }
            }
            if first != nil && second != nil { break }
        }
        let scale = Double(bitmap.pixelsHigh) / host.bounds.height
        if first == nil || second == nil,
           let directory = ProcessInfo.processInfo.environment["ANIMATION_LIFETIME_ARTIFACT_DIR"],
           let data = bitmap.representation(using: .png, properties: [:]) {
            try data.write(to: URL(fileURLWithPath: directory).appendingPathComponent("reference-missing-pixels.png"))
            print("animation-lifetime missing pixels bounds=\(host.bounds) bitmap=\(bitmap.pixelsWide)x\(bitmap.pixelsHigh) red=\(String(describing: first)) green=\(String(describing: second))")
        }
        // Separate hosting roots deliberately contain only their own consumer's color.
        return [Double(try XCTUnwrap(requiredColor == 1 ? 0 : first)) / scale,
                Double(try XCTUnwrap(requiredColor == 0 ? 0 : second)) / scale]
    }
}
#endif

// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
#if !SKIP
@testable import SkipSwiftUI

final class AndroidCompositionBoundaryProjectionRegistryTests: XCTestCase {
    private final class ProjectionProbe {}
    private final class ProjectionFactoryCapture {}

    func testUnchangedInputsReuseExistingProjection() {
        let registry = AndroidCompositionBoundaryProjectionRegistry<String>()
        var creationCount = 0

        let firstProjection = registry.prepare(instanceID: "instance-1", inputs: "tab-1") {
            creationCount += 1
            return "first"
        }
        let secondProjection = registry.prepare(instanceID: "instance-1", inputs: "tab-1") {
            creationCount += 1
            return "second"
        }

        XCTAssertEqual(firstProjection, "first")
        XCTAssertEqual(secondProjection, "first")
        XCTAssertEqual(creationCount, 1)
    }

    func testChangedInputsReplaceProjection() {
        let registry = AndroidCompositionBoundaryProjectionRegistry<String>()

        let firstProjection = registry.prepare(instanceID: "instance-1", inputs: "tab-1") {
            "first"
        }
        let secondProjection = registry.prepare(instanceID: "instance-1", inputs: "tab-2") {
            "second"
        }

        XCTAssertEqual(firstProjection, "first")
        XCTAssertEqual(secondProjection, "second")
    }

    func testChangedInputsReleasePreviousProjectionWithinSameInstance() {
        let registry = AndroidCompositionBoundaryProjectionRegistry<ProjectionProbe>()
        weak var releasedFirstProjection: ProjectionProbe?
        weak var retainedSecondProjection: ProjectionProbe?

        do {
            let firstProjection = ProjectionProbe()
            releasedFirstProjection = firstProjection
            _ = registry.prepare(instanceID: "instance-1", inputs: "tab-1") {
                firstProjection
            }
        }

        XCTAssertNotNil(releasedFirstProjection)

        do {
            let secondProjection = ProjectionProbe()
            retainedSecondProjection = secondProjection
            _ = registry.prepare(instanceID: "instance-1", inputs: "tab-2") {
                secondProjection
            }
        }

        XCTAssertNil(releasedFirstProjection)
        XCTAssertNotNil(retainedSecondProjection)

        registry.release(instanceID: "instance-1")
        XCTAssertNil(retainedSecondProjection)
    }

    func testSeparateComposeInstancesDoNotShareProjection() {
        let registry = AndroidCompositionBoundaryProjectionRegistry<String>()

        let firstProjection = registry.prepare(instanceID: "instance-1", inputs: "") { "first" }
        let secondProjection = registry.prepare(instanceID: "instance-2", inputs: "") { "second" }
        registry.release(instanceID: "instance-1")
        let retainedSecondProjection = registry.prepare(instanceID: "instance-2", inputs: "") {
            "replacement"
        }

        XCTAssertEqual(firstProjection, "first")
        XCTAssertEqual(secondProjection, "second")
        XCTAssertEqual(retainedSecondProjection, "second")
    }

    func testReleaseDropsTheRegistrysStrongReference() {
        let registry = AndroidCompositionBoundaryProjectionRegistry<ProjectionProbe>()
        weak var releasedProjection: ProjectionProbe?

        do {
            let projection = ProjectionProbe()
            releasedProjection = projection
            _ = registry.prepare(instanceID: "instance-1", inputs: "tab-1") { projection }
        }

        XCTAssertNotNil(releasedProjection)
        registry.release(instanceID: "instance-1")
        XCTAssertNil(releasedProjection)
    }

    func testProjectionSourceDropsCapturedViewGraphAfterPreparation() {
        let registry = AndroidCompositionBoundaryProjectionRegistry<String>()
        weak var releasedCapture: ProjectionFactoryCapture?
        let source: AndroidCompositionBoundaryProjectionSource<String>

        do {
            let capture = ProjectionFactoryCapture()
            releasedCapture = capture
            source = AndroidCompositionBoundaryProjectionSource {
                _ = capture
                return "projection"
            }
        }

        XCTAssertNotNil(releasedCapture)
        let projection = source.prepare(
            in: registry,
            instanceID: "instance-1",
            inputs: ""
        )

        XCTAssertEqual(projection, "projection")
        XCTAssertNil(releasedCapture)
    }

    func testProjectionSourceDropsUnneededCaptureWhenProjectionIsReused() {
        let registry = AndroidCompositionBoundaryProjectionRegistry<String>()
        _ = registry.prepare(instanceID: "instance-1", inputs: "") { "retained" }

        weak var releasedCapture: ProjectionFactoryCapture?
        let source: AndroidCompositionBoundaryProjectionSource<String>
        do {
            let capture = ProjectionFactoryCapture()
            releasedCapture = capture
            source = AndroidCompositionBoundaryProjectionSource {
                _ = capture
                return "replacement"
            }
        }

        let projection = source.prepare(
            in: registry,
            instanceID: "instance-1",
            inputs: ""
        )

        XCTAssertEqual(projection, "retained")
        XCTAssertNil(releasedCapture)
    }
}
#endif

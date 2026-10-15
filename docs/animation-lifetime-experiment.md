# Animation lifetime: experiment 1

This records the baseline run. See [experiment 2](animation-lifetime-experiment-2.md)
for the subsequent expiry prototype and its remaining failures.

This experiment establishes reference behavior and a minimal regression case before
changing how animation provenance expires. It changes sample/test code only; it does
not clear stamps or alter the framework's runtime animation policy.

## Reproduction

`AnimationLifetimeFixture` renders two sibling rectangles from the same state:

```swift
first.offset(y: anchor + drag)
second.offset(y: drag + anchor)
```

The actual fixture reverses operand order to cover either read order. Its test tags
are inside the offset so Compose reports the moving content's coordinates.

Each test performs these steps:

1. Animate `anchor` from 0 to 80 using a one-second linear animation.
2. Check both siblings partway through, then after completion.
3. Update the separate `drag` state three times by 40 using `withAnimation(nil)`.
   Each update must reach its new position within 80 ms, rather than interpolate
   using the completed anchor animation.
4. Animate `anchor` by another 80 with the same animation specification. Both
   siblings must interpolate again: remembering the animation specification alone
   is not enough to distinguish an old stamp from a new animated write.

The two cases use either `@State` or an `@Observable` property for `anchor`.
`drag` is separate `@State` in both cases. No browser, sheet, geometry reader,
gesture recognizer, or image loading is involved.

## Apple SwiftUI reference

On macOS, conditional imports make the same fixture use Apple's SwiftUI and
Observation. The reference test hosts it in an `NSHostingView`, then measures the
colored rectangles in rendered bitmaps. Intermediate-position assertions ensure
that snapping to the endpoint cannot pass as animation.

On macOS 26.6.2, both tests pass. Both siblings have identical positions:

| Phase | `@State` | `@Observable` |
| --- | ---: | ---: |
| Initial | 0 | 0 |
| First animation, about 300 ms | 24 | 25.5 |
| Settled | 80 | 80 |
| Three plain updates, each sampled after 80 ms | 120, 160, 200 | 120, 160, 200 |
| New animation, about 300 ms | 224 | 224 |
| Final | 280 | 280 |

Values are points relative to the initial position. This is an Apple SwiftUI
reference on macOS, not an iOS device result.

## Android result

Both instrumentation tests completed and failed on the intended regression
assertion: the first plain drag update had not reached 120. Neither was skipped;
there was no process crash in this final run. Both state variants and both
siblings produced the same measurements (rounded to two decimals):

| Phase | Expected behavior | Android position |
| --- | --- | ---: |
| Initial | 0 | 0 |
| First animation, 300 ms of test-clock advancement | Between 0 and 80 | 21.69 |
| Settled | 80 | 80 |
| First plain update, 80 ms later | 120 | 81.78 |
| Second plain update, 80 ms later | 160 | 86.40 |
| Third plain update, 80 ms later | 200 | 92.80 |
| New animation, 300 ms of test-clock advancement | Between 200 and 280 | 221.87 |
| Final | 280, within pixel-rounding tolerance | 280.18 |

All initial-animation, settled-position, and new-animation assertions passed
before the plain-update assertion failed. Every phase is logged before assertions,
so the first failure does not hide the later measurements. The Android tests
deliberately remain failing regression tests until the behavior is fixed.

These are Compose layout-position measurements under its stepped test clock,
not a recording or a measurement of live finger-to-screen latency. They reproduce
the unwanted interpolation without the application's other moving parts.

## Implication for the next experiment

The animation should apply to the write that changed the anchor, reach both
consumers, and stop influencing later plain changes. This supports trying expiry
after the relevant composition work before considering elapsed-time expiry.
It does not yet establish which composition boundary is safe for expiry.

Clearing a shared stamp at the first consumer is insufficient: the second
consumer also needs it. Suppressing an already-seen animation specification is
also insufficient: the later write deliberately reuses that specification.
Experiment 1 does not decide the production fix or require a runtime change in
any framework. All new source/test changes are confined to this package.

## Versions and evidence

The package uses its resolved dependencies, not the application's local dependency
overrides: SkipFuseUI `bad6fa2` plus this experiment; SkipUI `d719974`;
SkipAndroidBridge `c62c6bc` (0.6.6); SkipModel `54c7914` (1.7.6); Skip 1.9.8.
Android target: Samsung SM-S721U, serial `R5CXC1DKRNA`, Android 16.

Local run artifacts are under `/tmp/animation-lifetime-experiment/`.
`reference-verified.log` contains the reference results; `android-verified.log`
contains the Android build/run, and `android-results/` preserves its XML and
per-test output. Earlier files in that directory document harness setup failures,
not additional behavior results.

## Running the tests

From the SkipFuseUI package, generate the bridge/test sources and run the reference:

```sh
SKIP_ACTION=none /Users/hugo/Swishly/Projects/webvideocast/platforms/skip/scripts/with-android-toolchain \
  swift test --filter AnimationLifetimeReferenceTests
```

Then run the focused instrumentation tests from the generated Gradle root:
`.build/plugins/outputs/skip-fuse-ui/SkipSwiftUISamplesTests/destination/skipstone`.
Use the repository build coordinator to avoid overlapping another Android build:

```sh
ANDROID_SERIAL=R5CXC1DKRNA \
  /Users/hugo/Swishly/Projects/webvideocast/platforms/skip/scripts/android-build-coordinator \
  run --app animation-lifetime --product SkipSwiftUISamples -- \
  /Users/hugo/Swishly/Projects/webvideocast/platforms/skip/scripts/gradle \
  :SkipSwiftUISamples:connectedDebugAndroidTest \
  '-Pandroid.testInstrumentationRunnerArguments.class=skip.swift.uisamples.FuseComposeUITests#testAnimationLifetimeStateSiblingsAndPlainDrag$SkipSwiftUISamples,skip.swift.uisamples.FuseComposeUITests#testAnimationLifetimeObservableSiblingsAndPlainDrag$SkipSwiftUISamples' \
  -PbuildDir=.build/SkipSwiftUISamples --console=plain
```

The `$SkipSwiftUISamples` suffix is part of Kotlin's compiled internal method name.
Omitting it selects zero tests. Inspect the current instrumentation XML under
`SkipSwiftUISamples/.build/SkipSwiftUISamples/outputs/androidTest-results/connected/debug/`;
a successful Gradle build with zero tests is not evidence of correct behavior.

The driver is main-actor isolated. Construct and invoke it on the Android UI thread;
constructing it on the JUnit runner thread trips Swift's executor assertion.

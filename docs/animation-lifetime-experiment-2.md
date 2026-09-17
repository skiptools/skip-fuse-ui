# Animation lifetime: experiment 2

## Result

Expiring a native animation stamp after successful composition fixes the settled
drag reproduction for both `@State` and `@Observable`. A plain update during an
active animation snaps the entire combined offset to its destination. This jump
is an accepted limitation of the current scope: Apple SwiftUI instead applies the
plain delta immediately while the existing anchor animation continues. The two
originally failing Android parity tests have been replaced with explicit tests of
the accepted interruption behavior and subsequent recovery; they are not skipped
or marked as expected failures.

The prototype remains uncommitted in SkipFuseUI and SkipUI. No application build
was installed. SkipAndroidBridge and SkipModel were not changed.

## Implementation

Each animated property write receives its own reference token:

```swift
final class AnimationWriteStamp {
    let animation: Animation
    private(set) var isPending = true
    func didApply() { isPending = false }
}
```

Native state boxes store this stamp. The existing SkipAndroidBridge hooks already
accept an opaque `Any` token, so observable properties can store the same stamp
without a bridge-package change.

A modifier captures an immutable animation and all pending stamps read by its
arguments. The first stamped argument chooses the animation, as before, but all
arguments need acknowledgement. Otherwise a second stamped argument could lend
its old animation to the next plain update. Duplicate reads are deduplicated by
object identity.

The SkipUI bridge gains an overload:

```swift
Animation.primeBridgedProvenance(animation, onApplied: callback)
```

Its transaction carries the callback to `toAnimatable`, which registers it with
Compose `SideEffect`. The existing one-argument entry point remains available.
The callback runs once after successful composition, including when a target did
not change. It does not run for abandoned composition. It marks source stamps
expired without changing animations already captured by siblings or retained
modifiers. It does not wait for animation completion.

This uses a public Compose lifecycle API, not additional Compose internals.
[Android's SideEffect documentation](https://developer.android.com/develop/ui/compose/side-effects)
specifies execution after successful recomposition. Callback execution through
the generated Swift/JNI bridge was exercised by the physical-device tests.

The per-property slot can retain the expired stamp until its next write. Expiry
means subsequent reads ignore it; it does not require clearing the observation
ledger or accumulating a global history of writes.

## Measurements

Both native state variants and both sibling consumers gave the same Android
positions. Values are points relative to the initial position, rounded to two
decimals. The fixture uses a one-second linear animation; these are stepped
Compose-clock measurements, not live finger-latency measurements.

| After the anchor has settled at 80 | No-expiry control | Prototype | Apple reference |
| --- | ---: | ---: | ---: |
| Plain target 120, after 80 ms | 81.78 | 120.18 | 120 |
| Plain target 160, after 80 ms | 86.40 | 160 | 160 |
| Plain target 200, after 80 ms | 92.80 | 200.18 | 200 |

The initial animation and a later fresh write using the same animation
specification still animate both siblings. A second reader evaluated through
`GeometryReader` also passes for both state variants. That checks one layout-time
consumer; it does not prove correctness across independently scheduled roots.

The active-animation case exposes a separate limit:

1. Start animating `anchor` from 0 to 80.
2. About 300 ms later, add 40 to `drag` using `withAnimation(nil)`.
3. Measure the same `anchor + drag` offset 80 ms later.

| Runtime | Before plain update | 80 ms later | Meaning |
| --- | ---: | ---: | --- |
| Android, no expiry | 21.69 | 27.73 | The new drag target is interpolated; it trails |
| Android, prototype | 21.69 | 120.18 | The whole sum snaps to its final destination |
| Apple SwiftUI, observable reference | 24.5 | 72.5 | Adds 40 immediately while anchor continues |
| Apple SwiftUI, state reference | 25.5 | 73.5 | Adds 40 immediately while anchor continues |

Apple uses wall-clock sampling and Android uses its test clock, explaining the
small difference in initial positions. The diagnostic distinction is the response
to the new +40 delta, not exact alignment of those clocks.

This is not a new pass-to-fail regression in the active-animation tests: the
no-expiry control fails them too. However, the prototype changes the failure
from trailing to jumping. Clearing eligibility for a future animation is not
enough to reproduce how SwiftUI combines a still-animated source and a plain one.

## Initial validation (before the interruption scope decision)

- Native stamp tests: 11 passed. Covers sibling captures, abandoned captures,
  old acknowledgements after newer writes, equal animation specifications,
  multiple stamped arguments, plain overwrites, and an unrelated unconsumed write.
- Apple SwiftUI reference on macOS 26.6.2: 6 passed. Covers the original pair,
  deferred consumers, and active-animation updates, for both state variants.
- Samsung SM-S721U, Android 16, serial `R5CXC1DKRNA`: 14 executed, 12 passed,
  2 failed, 0 skipped. All eight pre-existing Compose regression cases passed;
  four settled/deferred lifetime cases passed; two active-animation cases failed.
- Negative control: disabled only `AnimationWriteStamp.didApply` expiry, keeping
  the bridge callback and dependency versions unchanged. All 14 tests executed;
  the six lifetime cases failed and the eight existing cases passed. It reproduced
  the original lag. The control mutation was then removed.

Unlike experiment 1's resolved SkipUI dependency (`d719974`), this experiment uses
the local SkipUI checkout at `d691690` plus the prototype. SkipFuseUI starts at
`bad6fa2` with the experiment fixtures. The negative control therefore matters:
it isolates expiry from the additional committed SkipUI improvements.

## Reproduce

The recorded runs used a temporary `SKIP_UI_PATH` override to select local SkipUI
without changing other dependencies. That experiment-only override has since
been removed from `Package.swift` to keep it out of the upstream submission.

To reproduce with the declared GitHub dependency, first publish the matching
SkipUI commit on `experimental_animation-performance` and resolve that revision.
Alternatively, use upstream's existing `SKIP_DEPENDENCY_ROOT` with an absolute
directory containing complete checkouts of all required Skip dependencies. The
current monorepo's empty dependency directories do not satisfy that requirement.
From the SkipFuseUI package, with the matching dependency selected:

```sh
SKIP_ACTION=none \
/Users/hugo/Swishly/Projects/webvideocast/platforms/skip/scripts/with-android-toolchain \
  swift test --filter 'AnimationLifetimeReferenceTests|StateProvenanceTests'
```

From the generated Gradle root documented in experiment 1, use the same dependency
selection and `ANDROID_SERIAL=R5CXC1DKRNA`, the repository build coordinator, and
`scripts/gradle` with:

```text
:SkipSwiftUISamples:connectedDebugAndroidTest
-Pandroid.testInstrumentationRunnerArguments.class=skip.swift.uisamples.FuseComposeUITests
-PbuildDir=.build/SkipSwiftUISamples
--console=plain
```

Artifacts are under `/tmp/animation-lifetime-experiment-2/`: native/reference
logs, prototype and control Android logs, preserved instrumentation XML and
per-test output, and separate patches for the two runtime implementations.

## Follow-up: independently evaluated consumers

The concern was whether the first applied consumer could expire the shared stamp
before another already-observing consumer captured the same animated write.
Test ordinary scheduling before adding machinery for that possibility.

`SharedAnimationLifetimeDriver` owns one observable anchor and one observable
drag property. Each `SharedAnimationLifetimeConsumer` reads those properties in
its own body. The parent never reads or precomputes the offset. Both consumers
mount before a single `withAnimation` write changes the anchor. There are no
delayed reads, manually invoked expiry callbacks, or suspended compositions.

Three new physical-device tests passed on the same Samsung Android 16 device:

- Two separately bridged native child views in one Compose row.
- One consumer in the screen and the other in an already-mounted Compose dialog.
- The same screen/dialog arrangement with consumer placement reversed.

Each test measures interpolation 300 ms into a one-second animation, the settled
destination, and a later plain +40 update after 80 ms. It repeats the sequence
with a fresh animated write, checking that observation and animation still work
after expiry. All three tests passed with zero failures or skips. They supplement
the earlier sibling and GeometryReader coverage; the earlier two strict
active-interruption parity failures were not changed or rerun here.

An Apple SwiftUI reference using the same shared model in two already-mounted
`NSHostingView`/`NSWindow` roots also passed. Both consumers moved about 25.5
points at the first midpoint, settled at 80, followed the plain update to 120,
then animated the fresh write and followed the next plain update to 240.
This is macOS reference coverage, not an iOS device test.

The Android dialog harness uses the standard Compose Dialog API, also used by
SkipUI presentations, but does not assert that every SwiftUI presentation path
has identical scheduling. Measurements concern animation propagation, not live
finger motion quality. Artifacts: `/tmp/animation-lifetime-independent/`, including
native and Android logs and preserved per-test instrumentation reports.

## Interruption scope and recovery tests

The provenance-aware `toAnimatable` receives a computed target and animation
provenance, not the expression that produced the target. Once the stamp has
expired, these two operations can both arrive as a new target with no animation:

```swift
// Leave the anchor alone and change an independent input.
withAnimation(nil) { drag += 40 }
// Or directly replace the animated position with an immediate destination.
withAnimation(nil) { anchor = 120 }
```

Retaining the old animation for every plain target would also affect intentional
snaps. Stopping at the current presentation value would leave it different from
the model destination. Neither is a generally correct narrow change at this
boundary. Distinguishing the expression's inputs requires broader provenance and
animation-composition work, outside this fix. Separate offset modifiers can express
independent motion at a call site, but do not fix arbitrary existing combined
expressions; no application refactor was made here.

`testAnimationLifetimeStateInterruptionSnapsAndRecovers` and its observable
counterpart now require both siblings to:

1. Interpolate an animated anchor from 0 toward 80.
2. Snap to 120 when a plain +40 drag interrupts it.
3. Immediately follow two more drag updates to 160 and 200.
4. Stay at 200 beyond the cancelled animation's original completion time.
5. Interpolate a fresh animated write and settle at 280.
6. Immediately follow another plain drag to 320.

The Apple interruption reference tests remain passing reference measurements of
Apple's different behavior; Android no longer asserts that unsupported parity.
There is no animation-runtime behavior change in this follow-up, only replacement
tests and explanatory comments. Validation artifacts are stored under
`/tmp/animation-lifetime-interruption/`.

Final validation after replacing the interruption assertions:

- Samsung SM-S721U / Android 16: all 17 `FuseComposeUITests` passed, zero failures,
  errors, or skips, including both replacement interruption tests and all three
  independent-consumer tests.
- Host: all 11 `StateProvenanceTests` and all 7 Apple reference tests passed.
- Both state variants and both siblings measured the same recovery sequence:
  approximately 21.69 mid-animation → 120.18 on interruption → 160 → 200.18,
  still 200.18 after waiting → 221.87 during a fresh animation → 280.18 settled
  → 320 on the next plain drag. These are rendered coordinates, not model targets.
- Whitespace checks passed in both framework repositories. No application build
  was installed; the existing application returned to the foreground after testing.

## Scope decision

No animation loss was reproduced in these ordinary existing-consumer cases.
Keep special handling for artificially delayed or suspended consumers out of the
current fix. A newly appearing view starting at the current value is not evidence
that an existing observer lost an animation. These tests do not prove all possible
root scheduling arrangements safe, but the remaining hypothetical alone does not
justify expanding the implementation.

Snapping to the destination when a plain drag interrupts an active animation is
a separate, demonstrated difference from Apple SwiftUI. The replacement tests
make this accepted contract explicit rather than presenting strict parity as
passing. No expiry-on-animation-end implementation was added.

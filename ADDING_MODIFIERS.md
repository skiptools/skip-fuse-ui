# Adding New View Modifiers to Skip

This guide explains how to add new SwiftUI view modifiers to the Skip framework, bridging Swift/SwiftUI to Kotlin/Compose.

## Overview

Adding a new modifier requires changes across three repositories:

| Repository | Purpose | Branch Pattern |
|------------|---------|----------------|
| `skip-ui` | Kotlin/Compose implementation | `vborko/<modifier>-modifier` |
| `skip-fuse-ui` | Swift bridging layer | `vborko/<modifier>-modifier` |
| `skipapp-showcase-fuse` | Test app/playground | `vborko/<modifier>-playground` |

## File Locations

### skip-ui (Kotlin side)
- `Sources/SkipUI/SkipUI/View/AdditionalViewModifiers.swift` - Simple view modifiers
- `Sources/SkipUI/SkipUI/Text/Text.swift` - Text-related modifiers
- `Sources/SkipUI/SkipUI/Compose/ComposeLayouts.swift` - Layout composables (if needed)

### skip-fuse-ui (Swift bridge)
- `Sources/SkipSwiftUI/View/AdditionalViewModifiers.swift` - View modifier bridges
- `Sources/SkipSwiftUI/Text/Text.swift` - Text modifier bridges (check for existing stubs)

### skipapp-showcase-fuse (Test app)
- `Sources/ShowcaseFuse/<Name>Playground.swift` - New playground file
- `Sources/ShowcaseFuse/PlaygroundListView.swift` - Register the playground

---

## Implementation Patterns

### Pattern 1: Simple View Modifier (e.g., blur, opacity)

**skip-ui/AdditionalViewModifiers.swift:**
```swift
// SKIP @bridge
public func blur(radius: CGFloat, opaque: Bool = false) -> any View {
    #if SKIP
    return ModifiedContent(content: self, modifier: RenderModifier { ... })
    #else
    return self
    #endif
}
```

**skip-fuse-ui/AdditionalViewModifiers.swift:**
```swift
extension View {
    /* @inlinable */ nonisolated public func blur(radius: CGFloat, opaque: Bool = false) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.blur(radius: radius, opaque: opaque)
        }
    }
}
```

### Pattern 2: Text Environment Modifier (e.g., tracking, fontWeight)

For modifiers that affect text rendering, use the `TextEnvironment` pattern.

**IMPORTANT:** Text modifiers require changes in THREE places in skip-fuse-ui:
1. `Text.swift` - The `Text.modifier()` method (uses `modifierChain`)
2. `AdditionalViewModifiers.swift` - The `View.modifier()` bridge (uses `ModifierView`)

#### skip-ui/Text.swift (Kotlin side):

1. Add field to `TextEnvironment` struct:
```swift
struct TextEnvironment: Equatable {
    var fontWeight: Font.Weight?
    var tracking: CGFloat?  // Add new field
    // ...
}
```

2. Add the `Text.tracking()` method that forwards to modifiedView:
```swift
public func tracking(_ tracking: CGFloat) -> Text {
    return Text(textView: textView, modifiedView: modifiedView.tracking(tracking))
}
```

3. Add the View extension modifier with bridge:
```swift
// SKIP @bridge
public func tracking(_ tracking: CGFloat) -> any View {
    #if SKIP
    return textEnvironment(for: self) { $0.tracking = tracking }
    #else
    return self
    #endif
}
```

4. Apply in the Render method:
```swift
if let tracking = textEnvironment.tracking {
    options = options.copy(letterSpacing: tracking.sp)
}
```

#### skip-fuse-ui/Text.swift (Swift bridge for Text type):

**Critical:** The `Text.tracking()` method must use `modifierChain` pattern (like `bold`, `italic`, `underline`):
```swift
nonisolated public func tracking(_ tracking: CGFloat) -> Text {
    var text = self
    text.modifierChain.append {
        $0.tracking(tracking)
    }
    return text
}
```

**Common mistake:** Just returning `self` compiles but doesn't apply the modifier!
```swift
// WRONG - compiles but does nothing on Android!
nonisolated public func tracking(_ tracking: CGFloat) -> Text {
    return self
}
```

#### skip-fuse-ui/AdditionalViewModifiers.swift (Swift bridge for View type):

```swift
// MARK: - Tracking
extension View {
    /* @inlinable */ nonisolated public func tracking(_ tracking: CGFloat) -> some View {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.tracking(tracking)
        }
    }
}
```

### Pattern 3: Modifier with View Parameter (e.g., mask, overlay)

**skip-ui/AdditionalViewModifiers.swift:**
```swift
// SKIP @bridge
public func mask(horizontalAlignmentKey: String, verticalAlignmentKey: String, bridgedMask: any View) -> any View {
    #if SKIP
    let alignment = Alignment(horizontal: HorizontalAlignment(key: horizontalAlignmentKey),
                              vertical: VerticalAlignment(key: verticalAlignmentKey))
    return ModifiedContent(content: self, modifier: MaskModifier(alignment: alignment, mask: bridgedMask))
    #else
    return self
    #endif
}
```

**skip-fuse-ui/AdditionalViewModifiers.swift:**
```swift
extension View {
    /* @inlinable */ nonisolated public func mask<Mask>(alignment: Alignment = .center, @ViewBuilder _ mask: () -> Mask) -> some View where Mask : View {
        let maskView = mask()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.mask(
                horizontalAlignmentKey: alignment.horizontal.key,
                verticalAlignmentKey: alignment.vertical.key,
                bridgedMask: maskView.Java_viewOrEmpty
            )
        }
    }
}
```

---

## Bridge Annotation Rules

### `// SKIP @bridge` Comment
- Place directly above the method that should be exposed to the bridge
- Method must return `any View` (not `some View`)
- Parameter types must be bridgeable (primitives, String, or bridged types)

### Parameter Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Simple values | Direct pass-through | `radius: CGFloat` |
| Alignment | Decompose to keys | `horizontalAlignmentKey: String` |
| View parameters | Add "bridged" prefix | `bridgedMask: any View` |
| UnitPoint | Extract components | `anchorX: CGFloat, anchorY: CGFloat` |
| Enums | Use raw value or key | `bridgedWeight: Int?` |

### Handling Existing Unavailable Stubs

Check both repositories for `@available(*, unavailable)` stubs:
- **skip-ui**: Remove the `@available` attribute, implement the modifier
- **skip-fuse-ui**: Remove the stub entirely if implementing in AdditionalViewModifiers.swift

---

## Adding a Playground

### 1. Create Playground File

`Sources/ShowcaseFuse/<Name>Playground.swift`:
```swift
// Copyright 2023–2025 Skip
import SwiftUI

struct TrackingPlayground: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Text("Label")
                    Spacer()
                    Text("Example")
                        .tracking(5)
                }
                // More examples...
            }
            .padding()
        }
        .toolbar {
            PlaygroundSourceLink(file: "TrackingPlayground.swift")
        }
    }
}
```

### 2. Update PlaygroundListView.swift

Four changes required:

1. **Add enum case** (alphabetical order):
```swift
case tracking
```

2. **Add title**:
```swift
case .tracking:
    return LocalizedStringResource("Tracking", comment: "Title of Tracking playground")
```

3. **Add body**:
```swift
case .tracking:
    TrackingPlayground()
```

4. **Add to newPlaygrounds set** (for "New only" filter):
```swift
private let newPlaygrounds: Set<PlaygroundType> = [
    .mask,
    .tracking
]
```

---

## Checklist

### For Simple View Modifiers:
- [ ] **skip-ui**: Implement modifier with `// SKIP @bridge`
- [ ] **skip-ui**: Add any required imports (e.g., `import androidx.compose.ui.unit.sp`)
- [ ] **skip-ui**: Remove `@available(*, unavailable)` if present
- [ ] **skip-fuse-ui**: Add View bridge in AdditionalViewModifiers.swift
- [ ] **skipapp-showcase-fuse**: Create playground file
- [ ] **skipapp-showcase-fuse**: Update PlaygroundListView.swift (4 places)
- [ ] Test on both iOS and Android

### For Text Modifiers (additional steps):
- [ ] **skip-ui/Text.swift**: Add field to `TextEnvironment` struct
- [ ] **skip-ui/Text.swift**: Add `Text.modifier()` method forwarding to `modifiedView`
- [ ] **skip-ui/Text.swift**: Add `View.modifier()` with `// SKIP @bridge` using `textEnvironment(for:)`
- [ ] **skip-ui/Text.swift**: Apply value in `Render` method via `Material3TextOptions`
- [ ] **skip-fuse-ui/Text.swift**: Add `Text.modifier()` using `modifierChain.append` pattern
- [ ] **skip-fuse-ui/AdditionalViewModifiers.swift**: Add View bridge with `ModifierView`

---

## Examples

| Modifier | Pattern | Key Files |
|----------|---------|-----------|
| `mask` | View parameter | AdditionalViewModifiers.swift, ComposeLayouts.swift |
| `tracking` | Text environment | Text.swift |
| `blur` | Simple modifier | AdditionalViewModifiers.swift |
| `fontWeight` | Text environment | Text.swift |
| `shadow` | Simple with multiple params | AdditionalViewModifiers.swift |

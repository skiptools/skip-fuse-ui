# Attributed text compatibility

Native Skip Fuse code can share the supported subset of Apple's `AttributedString`
and `Text(AttributedString)` APIs between iOS and Android. This is source
compatibility for the APIs described below, not a complete replacement for Apple's
attributed text implementation or a guarantee of identical text layout.

In a Fuse app, keep using `import SwiftUI`. On iOS, this uses Apple's Foundation and
SwiftUI. On Android, the value is a native Foundation `AttributedString`; Skip adds
UI attributes and inline Markdown parsing, then passes supported attributes to
the Android text renderer. These additions require the UI module. Importing only
Foundation on Android does not provide them.

This guide applies to native Fuse modules. It does not expand the attributed
string APIs available in transpiled Skip Lite modules.

## Code you can share unchanged

Use Foundation's native value operations to construct plain attributed strings,
copy them, append segments, find ranges, inspect `characters` and `runs`, and edit
attributes on a range. Copies retain value semantics. Use `AttributedString`
indices rather than integer or UTF-16 offsets when editing ranges.

The following attributes are supported by Android `Text`:

| API | Supported behavior and limits |
| --- | --- |
| `font` | A SwiftUI `Font` for the range, within Skip's existing font support. Font availability and metrics can differ between platforms. |
| `foregroundColor` | A SwiftUI `Color` for the range. |
| `link` | A Foundation `URL`. Taps call the environment's `openURL` action. Use absolute URLs in shared Markdown. |
| `underlineStyle`, `strikethroughStyle` | Use `Text.LineStyle.single`. Android renders solid single lines in the text color. Pattern and separate color arguments compile but are ignored. Set the attribute to `nil` to remove that range's explicit decoration. |
| `baselineOffset` | A `CGFloat` distance in points. Positive raises the text; negative lowers it. It does not resize the font. |
| `inlinePresentationIntent` | `.emphasized`, `.stronglyEmphasized`, `.code`, and `.strikethrough`, including combinations. Code uses a monospaced font. |

Unset attributes inherit surrounding text styling. Links use the surrounding tint
unless the range has an explicit foreground color. A link does not automatically
add an underline on Android. Assign `.underlineStyle = .single` if an underline is
required.

For example, this view uses the same source on both platforms:

```swift
import SwiftUI

struct Formula: View {
    private var content: AttributedString {
        var text = AttributedString("E = mc2")
        if let exponent = text.range(of: "2") {
            text[exponent].font = .caption
            text[exponent].foregroundColor = .orange
            text[exponent].baselineOffset = 6
        }
        return text
    }

    var body: some View {
        Text(content).font(.title2)
    }
}
```

For a subscript, apply a smaller font and a negative offset to the selected range.
The offset remains a point distance when the surrounding font changes. The
separate `Text.baselineOffset(_:)` modifier remains unavailable on Android.

## Markdown differences

Use this explicit option in shared code, then edit the result with the same range
APIs as a manually constructed value:

```swift
import SwiftUI

func instructions() throws -> AttributedString {
    var text = try AttributedString(
        markdown: "Read **important** instructions at [Skip](https://skip.dev)",
        options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
    )
    if let range = text.range(of: "important") {
        text[range].foregroundColor = .orange
        text[range].underlineStyle = .single
    }
    return text
}
```

Android uses the CommonMark engine and strikethrough extension already included by
SkipFoundation. The supported syntax covers bold, italic, inline code,
strikethrough, inline links, and nested combinations. The adapter preserves spaces
and blank lines. Its parsing is not guaranteed to match Apple's parser for every
input, especially syntax outside this subset.

| API or behavior | Apple Foundation | Native Fuse on Android |
| --- | --- | --- |
| `AttributedString(markdown: String, options:)` | Supported. | Supported with the single option below. |
| Omitted options or `.init()` | Defaults to `.full`. | Defaults to `.inlineOnlyPreservingWhitespace`. Pass the option explicitly to avoid different defaults. |
| `interpretedSyntax` | `.full`, `.inlineOnly`, `.inlineOnlyPreservingWhitespace`. | Only `.inlineOnlyPreservingWhitespace`. |
| Other parsing options | Extended attributes, failure policy, language code, source-position attributes. | Not implemented; these option arguments and properties are unavailable. |
| Markdown initializer overloads | Also accepts `baseURL:`, `including:`, `Data`, and file URLs via `contentsOf:`. | Only the `String` and `options:` form above. Even explicitly passing `baseURL: nil` is unsupported. |
| Parse errors | Uses Apple's parsing and failure policy. | The initializer is declared `throws` for compatible call sites, but currently reports no Markdown parse errors. Keep `try` and handle errors for iOS. |
| Block and other rich content | Apple's parser exposes additional presentation attributes. | No block presentation, images, attachments, tables, or HTML rendering. Do not rely on their parsing or appearance. |

Apple documents the whitespace-preserving mode in
[InterpretedSyntax.inlineOnlyPreservingWhitespace](https://developer.apple.com/documentation/foundation/attributedstring/markdownparsingoptions/interpretedsyntax-swift.enum/inlineonlypreservingwhitespace).
See [MarkdownParsingOptions](https://developer.apple.com/documentation/foundation/attributedstring/markdownparsingoptions)
for Apple's full set of options.

## APIs that need platform-specific code

The supported rendering attributes are the complete list in this guide. Other
attributes, such as range background colors, kerning, tracking, paragraph layout,
or image glyphs, are not added by this implementation. Their Apple API spellings
may fail to compile on Android. Custom attributes that Foundation can store remain
in the value but are ignored by `Text`; successful storage does not imply rendering
support.

Use SwiftUI `Font`, `Color`, and `Text.LineStyle` values in shared code. UIKit and
AppKit attribute scopes and types, `NSAttributedString` conversions, and rich-text
import APIs are outside this compatibility support. Keep code that needs Apple's
full implementation in an Apple-only branch such as `#if !os(Android)`, and provide
an Android path using the supported attributes.

Prefer ordinary lookups such as `text[range].font` and `.baselineOffset`.
`AttributeScopes.swiftUI` and `AttributeScopes.SwiftUIAttributes` name the supported
scope on Android, but do not supply every member of Apple's scope. The `.skipUI`
scope is a Skip extension, not an Apple API. Also avoid qualifying the Android
compatibility type as `Foundation.InlinePresentationIntent`; Skip supplies that
type through the UI module. Use inferred intent cases or unqualified
`InlinePresentationIntent` in shared source. Apple's coding and Objective-C
conversion conformances are not supplied by the added attribute keys or intent
type, so this support does not promise portable serialized attributed values.

## Mixed imports

Shared code can import Foundation together with `SwiftUI` or `SkipFuseUI` and
continue using `CGFloat` and ordinary attribute lookups. On Android, both facades
explicitly re-export Skip's `CGFloat` alias, keeping it consistent with UI APIs.
On Apple platforms, ordinary lookups prefer Apple's SwiftUI scope when Skip's
scope is also visible. Explicit `.skipUI` lookups remain available for code that
uses Skip's renderer directly.

`MixedImportTests` checks both facade imports, unqualified and module-qualified
`CGFloat`, ordinary font/color/decorations/baseline assignments, and explicit
Skip attributes. Run the native tests with:

```sh
SKIP_ACTION=none swift test --build-system native --filter 'MixedImportTests|TextTests'
```

When testing unpublished dependencies, set `SKIP_DEPENDENCY_ROOT` to a complete
local dependency directory containing the matching SkipUI checkout.

Mixed-import validation on 2026-10-21 passed all four tests on the Apple host
and on a physical ARM64 Android device with Swift 6.4. The Android run compiled
the same test files into a native Swift Testing executable linked to the rebuilt
UI libraries; it did not use the transpiled test harness. The older facade modules
failed these tests with ambiguous `CGFloat` lookups, while the rebuilt facades
passed. Five existing native text tests also passed on the Apple host. The iOS
and Android integration builds passed with ordinary attributed-string lookups
and a `CGFloat` parameter.

Compatibility was checked against the installed iOS SDK interfaces from Xcode
27.1 and native Swift 6.4.0 on Android. Existing device checks cover native range
editing, Unicode, Markdown, links, supported styles, and baseline offsets at
multiple font sizes and Android font scales. They do not establish identical
glyph shapes, line wrapping, or rendering for all combinations on iOS and Android.

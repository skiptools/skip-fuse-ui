// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.swift.uisamples

import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toPixelMap
import androidx.compose.ui.semantics.SemanticsProperties
import androidx.compose.ui.test.*
import androidx.compose.ui.test.junit4.ComposeContentTestRule
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration
import org.junit.Assert.*

private fun annotated(rule: ComposeContentTestRule, tag: String): AnnotatedString =
    rule.onNodeWithTag(tag).fetchSemanticsNode().config[SemanticsProperties.Text].single()

/** Inspect the actual Compose spans, rather than inferring formatting from plain text. */
fun assertAttributedTextSpans(rule: ComposeContentTestRule, changed: Boolean = false) {
    rule.waitForIdle()
    val text = annotated(rule, "attributed-styles")
    val font = text.spanStyles.first { it.start == 0 }.item
    assertEquals(FontWeight.Bold, font.fontWeight)
    assertEquals(FontStyle.Italic, font.fontStyle)
    assertTrue(font.fontSize.value > 17f)
    val color = text.spanStyles.first { it.start == text.text.indexOf("Color") }.item.color
    // SwiftUI system colors are theme-dependent; assert the dominant channel.
    assertTrue(if (changed) color.green > color.red else color.red > color.green)
    val both = text.spanStyles.first { it.start == text.text.indexOf("Both") }.item.textDecoration!!
    assertTrue(both.contains(TextDecoration.Underline))
    assertTrue(both.contains(TextDecoration.LineThrough))
    val markdown = annotated(rule, "attributed-markdown")
    assertEquals(FontWeight.Bold, markdown.spanStyles.first { it.start == 0 }.item.fontWeight)
    assertEquals(FontStyle.Italic, markdown.spanStyles.first { it.start == 5 }.item.fontStyle)
    assertEquals(FontFamily.Monospace, markdown.spanStyles.first { it.start == 12 }.item.fontFamily)
    assertTrue(markdown.spanStyles.first { it.start == 17 }.item.textDecoration!!.contains(TextDecoration.LineThrough))
    assertBaselinePixels(rule, "attributed-baselines", changed)
    assertBaselinePixels(rule, "attributed-baselines-large", changed)
    assertBaselinePixels(rule, "attributed-baselines-serif", changed)
}

/** Exercise accessibility font scaling without changing the device's global settings. */
fun setAttributedTextContent(rule: ComposeContentTestRule, fontScale: Float) {
    rule.setContent {
        val density = androidx.compose.ui.platform.LocalDensity.current
        androidx.compose.runtime.CompositionLocalProvider(
            androidx.compose.ui.platform.LocalDensity provides androidx.compose.ui.unit.Density(density.density, fontScale)
        ) {
            skip.swift.ui.samples.AttributedTextTestFixture().Compose()
        }
    }
}

/** Compare actual glyph pixels so a correct-looking multiplier cannot hide a wrong distance. */
private fun assertBaselinePixels(rule: ComposeContentTestRule, tag: String, changed: Boolean) {
    val pixels = rule.onNodeWithTag(tag).captureToImage().toPixelMap()
    val tops = IntArray(3) { pixels.height }
    val bottoms = IntArray(3) { -1 }
    val ink = DoubleArray(3)
    val weightedY = DoubleArray(3)
    for (y in 0 until pixels.height) for (x in 0 until pixels.width) {
        val c = pixels[x, y]
        val weights = floatArrayOf(
            c.green - maxOf(c.red, c.blue),
            c.red - maxOf(c.green, c.blue),
            c.blue - maxOf(c.red, c.green)
        )
        for (channel in 0..2) {
            val weight = weights[channel]
            if (weight <= .1f) continue
            ink[channel] += weight
            weightedY[channel] += y * weight
            tops[channel] = minOf(tops[channel], y)
            bottoms[channel] = maxOf(bottoms[channel], y)
        }
    }
    for (i in 0..2) assertTrue("$tag: missing colored glyph $i", ink[i] > 0)
    // Weight the full antialiased glyph instead of choosing a threshold whose top
    // pixel can change with horizontal subpixel placement. Android uses ceil on
    // the signed paint offset: raising rounds down, lowering rounds up.
    val centers = DoubleArray(3) { weightedY[it] / ink[it] }
    val shift = if (changed) 0.0 else 6.0 * rule.density.density
    assertEquals("$tag: superscript distance", kotlin.math.floor(shift), centers[0] - centers[1], 0.5)
    assertEquals("$tag: subscript distance", kotlin.math.ceil(shift), centers[2] - centers[0], 0.5)
    assertEquals("$tag: superscript must not clip", (bottoms[0] - tops[0]).toDouble(), (bottoms[1] - tops[1]).toDouble(), 1.0)
    assertEquals("$tag: subscript must not clip", (bottoms[0] - tops[0]).toDouble(), (bottoms[2] - tops[2]).toDouble(), 1.0)
}

fun tapAttributedLink(rule: ComposeContentTestRule) {
    rule.onNodeWithTag("attributed-link").performTouchInput { click(center) }
}

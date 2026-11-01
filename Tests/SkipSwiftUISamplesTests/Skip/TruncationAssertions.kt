// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.swift.uisamples

import androidx.compose.ui.semantics.SemanticsActions
import androidx.compose.ui.test.*
import androidx.compose.ui.test.junit4.ComposeContentTestRule
import androidx.compose.ui.text.TextLayoutResult
import androidx.compose.ui.text.style.TextOverflow
import org.junit.Assert.*

/** Checks actual laid-out text, including whether Compose drew an ellipsis. */
fun assertTextTruncation(rule: ComposeContentTestRule) {
    val expected = mapOf(
        "truncation-tail" to TextOverflow.Ellipsis,
        "truncation-head" to TextOverflow.StartEllipsis,
        "truncation-middle" to TextOverflow.MiddleEllipsis,
        "truncation-inherited" to TextOverflow.MiddleEllipsis,
        "truncation-short" to TextOverflow.Ellipsis
    )
    for ((tag, overflow) in expected) {
        val results = mutableListOf<TextLayoutResult>()
        val textNode = (hasTestTag(tag) or hasAnyAncestor(hasTestTag(tag))) and
            SemanticsMatcher.keyIsDefined(SemanticsActions.GetTextLayoutResult)
        rule.onNode(textNode, useUnmergedTree = true).performSemanticsAction(SemanticsActions.GetTextLayoutResult) {
            it(results)
        }
        val layout = results.single()
        assertEquals(tag, overflow, layout.layoutInput.overflow)
        assertEquals(tag, 1, layout.lineCount)
        assertEquals(tag, tag != "truncation-short", layout.isLineEllipsized(0))
    }
    rule.onNodeWithTag("truncation-environment").assertTextEquals("middle")
}

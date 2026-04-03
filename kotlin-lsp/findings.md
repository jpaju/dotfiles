# Kotlin LSP completion broken in Helix

## Context

The file being edited is `Example.kt`:

```kotlin
const val foo = 1
const val bar = 1 + foo
```

The user is on line 2 (0-indexed: line 1), typing `foo` after `1 + `. The cursor is at character 20, which is right after the `o` in `foo`. Helix triggers a completion request at this position.

The completion list appears with `foo` as a match. The user selects it. Nothing gets inserted into the editor, the text remains unchanged.

## Completion response analysis

The server responds with a completion item like this (filtered to `foo`):

```json
{
  "label": "foo",
  "textEdit": {
    "newText": "",
    "insert": { "start": { "line": 1, "character": 20 }, "end": { "line": 1, "character": 20 } },
    "replace": { "start": { "line": 1, "character": 20 }, "end": { "line": 1, "character": 20 } }
  },
  "command": {
    "title": "Apply Completion",
    "command": "jetbrains.kotlin.completion.apply",
    "arguments": [23]
  }
}
```

Three things stand out here.

### InsertReplaceEdit

The `textEdit` is an `InsertReplaceEdit` (LSP 3.16+). This provides two alternative ranges for the same `newText`. The client chooses which range to use:

* The `insert` range is used when the user wants to insert the completion, keeping existing text after the cursor.
* The `replace` range is used when the user wants to replace existing text with the completion.

The client decides which operation to perform, typically based on a setting or keybinding. In this case both ranges are identical and zero-width (start == end), so the distinction is moot.

### Zero-width range with empty newText

A zero-width range means "insert at this position, replacing nothing." The LSP spec defines this explicitly: *"To insert text into a document create a range where start === end."* Combined with `newText: ""`, this is effectively a no-op. Nothing gets written to the document.

### Precedence: textEdit vs label

The LSP spec defines a clear precedence chain for what text gets inserted. On `insertText`:

> *"A string that should be inserted into a document when selecting this completion. When omitted the **label** is used as the insert text for this item."*

And on `textEdit`:

> *"An edit which is applied to a document when selecting this completion. When an edit is provided the value of **insertText** is ignored."*

So the precedence is:

1. `textEdit.newText` (highest priority, used when `textEdit` is present)
2. `insertText` (used when no `textEdit`)
3. `label` (fallback when both are absent)

Since `textEdit` is present, its `newText` (empty string) takes precedence. The `label` ("foo") is only used for display and filtering, not for insertion.

### The command field

The completion item includes a `command` field. The spec defines it as:

> *"An optional command that is executed **after** inserting this completion. Note that additional modifications to the current document should be described with the additionalTextEdits-property."*

The intended flow is: apply the textEdit first, then execute the command via `workspace/executeCommand`. Given the intentionally empty `textEdit`, Kotlin LSP likely relies on this command (`jetbrains.kotlin.completion.apply`) to perform the actual text insertion server-side, though this has not been verified.

Note the spec's remark about `additionalTextEdits`: it implies the command is not meant to be the primary mechanism for modifying the document. This becomes relevant in the root cause analysis.

### Summary

The `textEdit` is a no-op (empty text into a zero-width range), `label` cannot override it because `textEdit` takes precedence, and the `command` is the only remaining mechanism that could perform the actual insertion.

## Client-server interaction trace

### Expected LSP completion flow

The spec doesn't define the full completion lifecycle as a single explicit sequence. The flow below is inferred from individual field descriptions in the `CompletionItem` interface, most notably the `command` field: *"executed **after** inserting this completion."*

```
Client                                    Server
  |                                         |
  |--- textDocument/completion ------------>|
  |<-- completion items (list) -------------|
  |                                         |
  |    (user navigates the list)            |
  |--- completionItem/resolve ------------->|   optional, for docs/details
  |<-- resolved item -----------------------|
  |                                         |
  |    (user accepts an item)               |
  |    1. apply textEdit                    |
  |    2. apply additionalTextEdits         |
  |    3. execute command ----------------->|   workspace/executeCommand
  |<-- command result ----------------------|
```

Steps 1 through 3 happen client-side when the user accepts a completion item. Steps 2 and 3 are conditional: step 2 only applies when the item includes `additionalTextEdits`, and step 3 only when the item includes a `command` field.

### What Helix actually does

Analysis of the Helix LSP log (`kotlin-lsp.log`) shows the following sequence. Only completion-relevant messages are listed; standard text synchronization (`textDocument/didOpen`, `textDocument/didChange`) and diagnostics are omitted since they work correctly and are not related to the bug.

1. As the user types, Helix sends `textDocument/completion` requests.
2. The server responds with completion items, each containing an empty `textEdit` and a `command` field.
3. When the user navigates to a specific item, Helix sends `completionItem/resolve` to fetch additional details (documentation, etc.).
4. When the user accepts the item, Helix applies the `textEdit` (which is a no-op).
5. **Helix never sends `workspace/executeCommand`.**

The log contains no `workspace/executeCommand` request for `jetbrains.kotlin.completion.apply` at any point. This means step 3 from the expected flow never happens.

## Root cause

Helix applies the empty `textEdit` (a no-op) and never executes the `command` attached to the completion item. Since the `textEdit` inserts nothing, and the command never fires, the result is that nothing gets inserted into the editor.

The `command` (`jetbrains.kotlin.completion.apply`) is likely intended to perform the actual text insertion, given that the `textEdit` is intentionally empty and the server advertises this command in its `executeCommandProvider.commands`. However, since Helix never sends the `workspace/executeCommand` request, we have not observed what the server would actually do in response. This remains an assumption.

Both sides contribute to the issue:

**Helix** does not execute the `command` field after accepting a completion item. Per the spec, it should: *"An optional command that is executed **after** inserting this completion."* This is a client-side gap.

**Kotlin LSP** uses an unusual pattern where `textEdit` is intentionally empty and all text insertion is deferred to the `command`. The spec's note on `command` says *"additional modifications to the current document should be described with the additionalTextEdits-property"*, implying the command is meant for side effects (like adding imports), not primary text insertion. This pattern is fragile against clients that don't support command execution after completion.

## Possible solutions

### Server side (Kotlin LSP)

The current response has an empty `newText` and likely relies on the `command` for insertion:

```json
{
  "label": "foo",
  "textEdit": {
    "newText": "", // Empty newText results in no-op edit
    "insert": { "start": { "line": 1, "character": 20 }, "end": { "line": 1, "character": 20 } },
    "replace": { "start": { "line": 1, "character": 20 }, "end": { "line": 1, "character": 20 } }
  },
  "command": { ... }
}
```

Two approaches that would make completion work regardless of client command execution support:

1. Put actual text in `newText` so the `textEdit` performs the insertion directly:

```json
{
  "label": "foo",
  "textEdit": {
    "newText": "foo", // newText contains the actual insertion text
    "insert": { "start": { "line": 1, "character": 20 }, "end": { "line": 1, "character": 20 } },
    "replace": { "start": { "line": 1, "character": 20 }, "end": { "line": 1, "character": 20 } }
  }
}
```

2. Omit `textEdit` entirely, so the client falls back to `label` as the insert text:

```json
{
  // Omitting textEdit results in falling back to label
  "label": "foo",
  "labelDetails": { }
}
```

### Client side (Helix)

Helix should execute the `command` field via `workspace/executeCommand` after accepting a completion item and applying the `textEdit`. This would make Helix compatible with servers that rely on commands for completion side effects or, as in this case, the primary insertion.

## References

* [Kotlin LSP issue #105](https://github.com/Kotlin/kotlin-lsp/issues/105)
* [LSP 3.17 specification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification)
  * [`CompletionItem.textEdit`](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionItem) (precedence over `insertText` and `label`)
  * [`InsertReplaceEdit`](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#insertReplaceEdit) (insert vs replace ranges)
  * [`CompletionItem.command`](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionItem) (executed after inserting)

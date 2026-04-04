Did some further investigation on this and wanted to share findings.

## Current behavior

Each completion item in the response includes a `command` field alongside an empty `textEdit`:

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

The flow this creates when a user accepts a completion:

1. User selects a completion item
2. Client applies the `textEdit` from the response, which inserts nothing since `newText` is empty (more on this below)
3. Client executes the `command` from the response via `workspace/executeCommand`
4. Server performs the actual text edit as a result of the command

This is the opposite of how completion is supposed to work: the server should provide the insertion text in the response and the client applies it locally, with no further server involvement needed.

## Why this is a problem

- Using `command` as the primary mechanism for text insertion is non-standard. Per the [LSP spec](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionItem), commands are meant for optional side effects that happen after insertion, not the insertion itself.
- Completion is one of the most fundamental LSP operations and is supported by virtually every editor. Command execution is not, and many editors implement completion without supporting `CompletionItem.command`. Relying on command execution for something as basic as inserting text from completion severely limits the number of compatible editors.
- It requires an extra round trip to the server for every accepted completion, adding unnecessary latency.

## Suggested fixes

A completion item can provide insertion text in a few ways, in order of precedence:

1. `textEdit.newText` is used when `textEdit` is present, and the other options are ignored
2. `insertText` is used when no `textEdit` is provided
3. `label` is used as a last resort fallback

Since the current response includes a `textEdit` with an empty `newText`, nothing gets inserted and there is no fallback to `label`. Two standard approaches that would fix this:

**1. Populate `newText` with the actual insertion text:**

```json
{
  "label": "foo",
  "textEdit": {
    "newText": "foo",
    "insert": { "start": { "line": 1, "character": 20 }, "end": { "line": 1, "character": 20 } },
    "replace": { "start": { "line": 1, "character": 20 }, "end": { "line": 1, "character": 20 } }
  }
}
```

**2. Omit `textEdit` entirely so clients fall back to `label`:**

```json
{
  "label": "foo",
  "labelDetails": { }
}
```

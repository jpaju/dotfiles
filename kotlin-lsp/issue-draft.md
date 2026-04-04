# LSP: execute CompletionItem.command after accepting a completion

## Description

The [LSP spec](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionItem) defines an optional `command` field on `CompletionItem`:

> "An optional command that is executed **after** inserting this completion. Note that additional modifications to the current document should be described with the additionalTextEdits-property."

The expected flow when a user accepts a completion item is:

1. Apply `textEdit`
2. Apply `additionalTextEdits` (if present)
3. Execute `command` via `workspace/executeCommand` (if present)

Helix handles steps 1 and 2 but never performs step 3. When a completion item includes a `command`, Helix silently ignores it.

Servers use this field for side effects that should follow a completion. An example completion item with a command:

```json
{
  "label": "foo",
  "textEdit": {
    "newText": "foo",
    "range": { "start": { "line": 1, "character": 0 }, "end": { "line": 1, "character": 3 } }
  },
  "command": {
    "title": "Do something",
    "command": "my-server.someAction",
    "arguments": [42]
  }
}
```

In this case the text gets inserted correctly, but the follow-up command never fires.

Some servers build their completion flow on top of this mechanism. For a concrete example, see this [comment on the Kotlin LSP issue tracker](https://github.com/Kotlin/kotlin-lsp/issues/105#issuecomment-4187615629).

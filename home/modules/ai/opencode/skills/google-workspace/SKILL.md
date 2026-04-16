---
name: google-workspace
description: How to read data from Google Workspace (Calendar, Gmail, Meet, Drive, Sheets, Docs) using the gws CLI. Load this skill whenever you need to interact with Google Workspace in any way.
---

# Google Workspace interaction

Use the `gws` CLI to interact with Google Workspace. It is already installed and authenticated.

`gws` commands are **dynamically generated** from Google's Discovery API at runtime. This means the exact command surface can change. When you need details on a command, parameter, or API not covered below, first query context7 with library ID `/googleworkspace/cli`. If context7 doesnt have what you need, fall back to `gws <service> --help` or `gws schema <method>`.

## Command structure

Two types of commands:

- Discovery commands: `gws <service> <resource> <method> --params {...}'`
  The standard form. Params are JSON objects matching the Google API parameters.
- Helper commands: `gws <service> +<helper>`
  Hand-crafted shortcuts prefixed with `+`. These are convenience wrappers.

List available helper commands for a service:

```
gws <service> --help | grep +
```

Inspect any method's parameter and response schema with `gws schema <service>.<resource>.<method>` (e.g. `gws schema drive.files.list`).

## Output and parsing

- Default output is JSON. Also supports `--format table|csv|yaml`
- Use `--fields` to limit response size (e.g. `--fields "files(id,name)"`)
- Pagination: `--page-all` streams pages as NDJSON, `--page-limit N` caps pages
- Every `gws` invocation prints `Using keyring backend: keyring` to stderr. When parsing output programmatically (jq, grep, etc.), pipe through `tail -n +2` to strip it: `gws ... 2>&1 | tail -n +2 | jq ...`

## Gotchas

- Sheets ranges use `!` which bash interprets as history expansion. Always single-quote params
- Calendar `q` param is a free-text search, not a structured query language
- `--format table` is human-readable but not parseable. Use default JSON when piping

## API relationship map

A single task often requires combining data from multiple services (e.g. determining who actually attended a meeting requires both Calendar and Meet, enriching participants with job titles requires People).

| Need                                      | Primary API | Enrich with                      |
| ----------------------------------------- | ----------- | -------------------------------- |
| Event titles, times, invited attendees    | Calendar    |                                  |
| Email messages and threads                | Gmail       |                                  |
| File metadata, permissions, sharing       | Drive       |                                  |
| Spreadsheet cell data                     | Sheets      | Drive (to find spreadsheet ID)   |
| Document content                          | Docs        | Drive (to find document ID)      |
| Actual meeting participation (who joined) | Meet        | Calendar (to get meeting titles) |
| Person identity, job title, department    | People      |                                  |

## Common read patterns

Examples below show the general command structure. Verify exact parameter names with context7 or `gws schema` before using.

### Calendar

Today's agenda:

```
gws calendar +agenda
```

Search events by time range and keyword using `gws calendar events list`. Key params: `calendarId` (use `"primary"`), `timeMin`, `timeMax`, `q` (text search), `singleEvents` (must be `true` to expand recurring events), `orderBy` (requires `singleEvents: true`).

### Gmail

Inbox triage (unread summary):

```
gws gmail +triage
```

Search messages using `gws gmail users messages list` with `userId: "me"` and `q` using Gmail search syntax (same as the Gmail search bar). Get full message content with `gws gmail users messages get`.

### Drive

List and search files using `gws drive files list`. Use `--fields` to limit response fields. The `q` param uses Drive query syntax (different from Gmail). Use `--page-all` for large result sets.

### Sheets

Read cell values using `gws sheets spreadsheets values get` with `spreadsheetId` and `range` params (e.g. `"Sheet1!A1:C10"`).

### Docs

Get document content using `gws docs documents get` with `documentId`.

### Meet

List recent meetings using `gws meet conferenceRecords list`. Returns timestamps and space IDs but NOT meeting titles. To identify meetings, match by time window or cross-reference the `space` field with calendar events that have a `hangoutLink`.

Get actual participants using `gws meet conferenceRecords participants list`. Returns display names, join times, and leave times.

### People

Search the org directory using `gws people people searchDirectoryPeople` with `query`, `sources: ["DIRECTORY_SOURCE_TYPE_DOMAIN_PROFILE"]`, and `readMask` to select fields. The `organizations` field contains job title, department, and cost center.

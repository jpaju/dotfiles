---
name: jira-interaction
description: How to read, search, create, update, and transition Jira issues, sprints, epics, and boards. Load this skill whenever you need to interact with Jira in any way.
---

# Jira interaction

Use the `jira` CLI to interact with Jira. It is already installed, authenticated, and configured.

Always use `--no-input` and `--plain` flags when appropriate to avoid interactive prompts and get machine-readable output.

If you need details on a command or flag not covered below, query context7 with library ID `/ankitpokhrel/jira-cli` and a specific query like "issue list filters", "sprint commands", or "epic create flags". Do not run `--help` commands.

## Issue operations

### View an issue

```
jira issue view MF-607 --plain
```

Shows issue details including summary, status, description, assignee, priority, and labels.

### List issues

```
jira issue list --parent MF-607 --plain
```

Returns a table of child issues with type, key, summary, and status.

**Note:** The default output may be truncated. Use `--paginate N` to control page size (e.g. `--paginate 50`) when you expect many child issues.

### Create an issue

```
jira issue create --no-input -tTask -s "Title" -b "Description body" -P MF-607
```

Flags:

- `-t` — issue type. Valid types: `Bug`, `Story`, `Task`, `Sub-task`
- `-s` — summary/title
- `-b` — body/description (supports multi-line content in quoted strings)
- `-P` — parent issue key (use this to link to an epic)
- `-y` — priority
- `-a` — assignee
- `-l` — label (can be repeated for multiple labels)

### Edit an issue

```
jira issue edit MF-476 --no-input -s "New title" -b "New description"
```

Both `-s` and `-b` can be used independently — you don't have to update both at once. Use `--no-input` to avoid interactive prompts.

### Transition an issue

```
jira issue move MF-609 "Done"
```

Moves the issue to the specified status. Note: `--no-input` is NOT supported on this command.

### Add a comment

```
jira issue comment add MF-609 "Comment text"
```

Adds a comment to an existing issue.

### Link issues

```
jira issue link MF-852 MF-1056 Relates
```

Creates a link between two issues. Common link types:

- `Relates` — general relationship between issues
- `Blocks` — first issue blocks the second
- `Duplicate` — first issue duplicates the second

## Epic operations

### View an epic

```
jira issue view MF-852 --plain
```

Same command as viewing an issue. Works identically for epics.

### List epics

```
jira epic list --plain
```

Lists epics in the project. Supports the same filters as `jira issue list` (e.g. `-s`, `-a`, `-y`).

### List issues in an epic

```
jira epic list MF-852 --plain
```

Alternative to `jira issue list --parent MF-852 --plain`. Both return child issues, but `jira epic list` uses the epic-specific command namespace and supports epic-specific filters like priority filtering on the epic itself.

**Note:** Both commands may truncate results by default. Use `--paginate N` to ensure you see all issues.

### Create an epic

```
jira issue create --no-input -tEpic -s "Epic title" -b "Description" -l label1 -l label2
```

Epics are created with `jira issue create` using `-tEpic`. Note: `-P` (parent) is not used for epics since they are top-level containers.

### Add issues to an epic

```
jira epic add MF-852 MF-100 MF-101 MF-102
```

Moves existing issues under the specified epic. Supports up to 50 issues at once. This also works to move issues from one epic to another — the issues are re-parented.

## Gotchas

- `--no-input` works on `create` and `edit`, but NOT on `move`
- There is no `-d` shorthand for description — use `-b` (body)
- `--plain` is only for `view` and `list` commands — do not use it on `create`, `edit`, or `move`
- Multi-line body content works directly with quoted strings in `-b`
- `jira issue list` and `jira epic list` may truncate results by default — use `--paginate N` to ensure you see all issues

## Tips

- Use `jira me` to get current user
- Tilde `~` negates filters: `-s~Done` means status is NOT Done, `-a~x` means assigned to someone
- Use `--raw` when you need structured JSON data for further processing

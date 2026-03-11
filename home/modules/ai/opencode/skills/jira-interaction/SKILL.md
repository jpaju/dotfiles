---
name: jira-interaction
description: How to read, search, create, update, and transition Jira issues, sprints, epics, and boards. Load this skill whenever you need to interact with Jira in any way.
---

# Jira interaction

Use the `jira` CLI to interact with Jira. It is already installed, authenticated, and configured.

Always use `--no-input` and `--plain` flags when appropriate to avoid interactive prompts and get machine-readable output.

If you need details on a command or flag not covered below, query context7 with library ID `/ankitpokhrel/jira-cli` and a specific query like "issue list filters", "sprint commands", or "epic create flags". Do not run `--help` commands.

## Command reference

### View an issue

```
jira issue view MF-607 --plain
```

Shows issue details including summary, status, description, assignee, priority, and labels.

### List children of an epic

```
jira issue list --parent MF-607 --plain
```

Returns a table of child issues with type, key, summary, and status.

### Create an issue

```
jira issue create --no-input -tTask -s "Title" -b "Description body" -P MF-607
```

Flags:

- `-t` — issue type. Valid types: `Bug`, `Story`, `Task`, `Epic`, `Sub-task`
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

## Gotchas

- `--no-input` works on `create` and `edit`, but NOT on `move`
- There is no `-d` shorthand for description — use `-b` (body)
- `--plain` is for list/view commands to get parseable output
- Multi-line body content works directly with quoted strings in `-b`

## Tips

- Use `jira me` to get current user
- Tilde `~` negates filters: `-s~Done` means status is NOT Done, `-a~x` means assigned to someone
- Use `--raw` when you need structured JSON data for further processing

---
description: Draft a GitHub issue or discussion from saved investigation findings
subtask: false
---

# Draft issue report

Draft a GitHub issue or discussion using the investigation file at $1.

## Usage

```
/draft-issue-report <investigation-file>
```

Example:

```
/draft-issue-report audio-dropouts-investigation.md
```

## Workflow

### 1. Review the investigation

Read the investigation file. Confirm that it identifies:

- The target repository
- The problem and expected vs. actual behavior
- Related issues or discussions with links
- Whether the problem is duplicate, related, or new
- The recommended action
- Any missing information

Do not repeat the GitHub research. If the investigation is incomplete, tell the user to update it before continuing.

### 2. Determine the report

Ask the user to confirm:

1. Is this a bug report, feature request, or question?
2. Should it be an issue or discussion?
3. Should components be covered together or in separate reports?
4. Is the recommended repository correct?

If the problem is an exact duplicate, recommend commenting on the existing linked thread instead of drafting a new report unless the user explicitly wants one.

### 3. Gather missing details

Ask only for details absent from the investigation and relevant to the report:

- Software versions, OS, firmware, or hardware
- Relevant configuration
- Components, commands, or files involved
- Reproduction steps
- Logs or error messages
- Screenshots

### 4. Draft the report

Write a concise report containing applicable sections:

- **Title:** Clear, concise description of the problem
- **Description:** Brief description of what's happening
- **Environment:** Relevant versions and configuration
- **Expected behavior:** What should happen
- **Actual behavior:** What actually happens
- **Steps to reproduce:** If known
- **Related issues:** Linked findings and why this report is not a duplicate
- **Additional context:** Other relevant information

Include only confirmed information from the user and investigation. Do not speculate or invent missing details.

### 5. Output

Write the draft to `<1-3-word-description>-<issue-or-discussion>.md` for user review. Do not post it to GitHub.

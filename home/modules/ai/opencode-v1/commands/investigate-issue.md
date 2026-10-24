---
description: Research related GitHub issues and discussions and save the findings
subtask: false
---

# Investigate issue

Research existing issues and discussions in the repository at $1.

## Usage

```
/investigate-issue <repo-url>
```

Example:

```
/investigate-issue https://github.com/home-assistant/core
```

## Agent usage

Use a subagent for the research:

- Delegate all GitHub searches to the subagent
- Instruct it to try multiple keyword variations
- Have it return a structured summary of findings with links

The main agent should:

- Parse the repo URL
- Ask questions from the user
- Determine search terms
- Launch the research subagent
- Present and analyze the findings
- Handle clarifying questions
- Save the investigation artifact

## Workflow

### 1. Understand the problem

Ask the user to describe:

- What's the problem in 1-2 sentences?
- What is the expected vs. actual behavior?
- What software/hardware is involved?
- Is the issue reproducible? If so, what are the steps?
- Any hunches about the cause?
- Any relevant keywords/synonyms to search for?

Extract 3-10 search terms to use in the searches.

### 2. Research

Search the repository thoroughly for existing issues and discussions:

- Search open issues with relevant keywords
- Search closed issues because the problem might be known or fixed
- Search discussions if available
- Try synonyms, technical terms, component names, and exact error messages

Use GitHub CLI:

```bash
# Search open issues
gh search issues --repo <owner/repo> "<keyword>" --limit 20

# Search closed issues
gh search issues --repo <owner/repo> "<keyword>" --state closed --limit 20

# Search discussions
gh-discussion-search <owner/repo> "<keyword>"
gh-discussion-search <owner/repo> "<keyword>" 50  # optional limit, max 100
```

### 3. Summarize findings

Present findings in a table. Link each issue or discussion using its canonical GitHub URL:

| Result                                                       | Type       | Status   | Summary | Relevance |
| ------------------------------------------------------------ | ---------- | -------- | ------- | --------- |
| [#123: Title](https://github.com/owner/repo/issues/123)      | Issue      | Open     | ...     | High      |
| [#456: Title](https://github.com/owner/repo/discussions/456) | Discussion | Answered | ...     | Medium    |

For each potentially related result:

- Note its number, title, and URL
- Summarize the problem described
- Note its status and any resolution
- Note any workarounds mentioned
- Note maintainer responses indicating whether the behavior is expected

### 4. Analyze findings

Compare the user's problem with the findings:

- Is it an exact duplicate?
- Is it related but different? Explain the differences.
- Is it new or unique?
- Which repository or component appears responsible?
- Should the user file an issue, start a discussion, or add to an existing thread?

Do not draft the report. Record missing information for the reporting phase.

### 5. Output

Write the investigation to `<1-3-word-description>-investigation.md` with these sections:

- **Repository:** The repository URL
- **Problem:** The user's description and expected vs. actual behavior
- **Search terms:** Terms and variations searched
- **Findings:** The linked results table and relevant details
- **Assessment:** Duplicate, related, or new, with reasoning
- **Recommended action:** Suggested destination and report type
- **Missing information:** Details still needed for a complete report

Include only confirmed information. Do not speculate.

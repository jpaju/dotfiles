---
description: Research existing issues/discussions in GitHub repos and draft new issues
subtask: false
---

# Investigate issue

Research existing issues and discussions in the repository at $1 and draft new issues or discussions.

## Usage

```
/investigate-issue <repo-url>
```

Example:

```
/investigate-issue https://github.com/home-assistant/core
```

## Agent usage

Use a subagent (type: `general`) for the research phase:

- Delegate all GitHub API searches to the subagent
- Instruct it to try multiple keyword variations
- Have it return a structured summary of findings

The main agent should:

- Parse the repo URL
- Ask questions from the user
- Determine search terms
- Launch the research subagent
- Present findings to user
- Handle clarifying questions
- Draft and output the final report

## Workflow

### 1. Understand the problem

Ask the user to describe:

- What’s the problem in 1-2 sentences?
- What is the expected vs. actual behavior?
- What software/hardware is involved?
- Is the issue reproducible? If so, what are the steps?
- Any hunches about the cause?
- Any relevant keywords/synonyms to search for?

Extract 3-10 search terms to use in the searches.

### 2. Research phase

Search the repository thoroughly for existing issues/discussions:

- Search open issues with relevant keywords
- Search closed issues (problem might be known/fixed)
- Search discussions if available
- Try multiple search terms (synonyms, technical terms, component names)
- Search for error messages if any

Use GitHub CLI:

```bash
# Search open issues
gh search issues --repo <owner/repo> "<keyword>" --limit 20

# Search closed issues
gh search issues --repo <owner/repo> "<keyword>" --state closed --limit 20

# Search discussions using GraphQL API
gh api graphql -f query='
  query {
    search(query: "repo:<owner/repo> <keyword>", type: DISCUSSION, first: 20) {
      discussionCount
      nodes {
        ... on Discussion {
          number
          title
          url
          category { name }
          isAnswered
          createdAt
        }
      }
    }
  }
'

# Get discussion categories (to find category ID for creating discussions)
gh api graphql -f query='
  query {
    repository(owner: "<owner>", name: "<repo>") {
      discussionCategories(first: 10) {
        nodes {
          id
          name
          description
        }
      }
    }
  }
'
```

### 3. Summarize findings

Present findings in a table:

| Issue | Status | Summary | Relevance |
| ----- | ------ | ------- | --------- |
| #123  | Open   | ...     | High      |
| #456  | Closed | ...     | Medium    |

For each potentially related issue found:

- Note the issue number and title
- Summarize the problem described
- Note if it's open/closed and any resolution
- Note any workarounds mentioned
- Note maintainer responses indicating if behavior is expected

### 4. Analyze findings

Compare the user's issue with existing issues:

- Is this an exact duplicate?
- Is it related but different? Explain the differences.
- Is it a new/unique issue?

### 5. Determine action

Ask user:

1. Is this a bug report, feature request, or question?
2. Should we create an issue or discussion first?
3. Single combined report or separate issues per component?

If filing a new issue, help determine which repository is most appropriate:

- Is this a frontend, backend, or integration issue?
- Which component is most likely responsible?

### 6. Gather additional details

If the issue appears new or unique, ask the user for:

- Software versions (OS, app versions, firmware, etc.)
- Configuration details relevant to the issue
- Which component/command/file is involved?
- Bug, feature request, or question?
- Logs or error messages?
- Screenshots if applicable

### 7. Draft the report

Write to a markdown file for user review before posting.

The draft should include:

- **Title:** Clear, concise description of the problem
- **Description:** Brief description of what's happening
- **Environment:** Relevant versions and configuration
- **Expected behavior:** What should happen
- **Actual behavior:** What actually happens
- **Steps to reproduce:** If known
- **Related issues:** List issues found during research and explain why this is different
- **Additional context:** Any other relevant information

Be concise but include all necessary details. Don't speculate - only include confirmed information from the user.

### 8. Output

Write the draft to `<1-3-word-description>-<issue/discussion>.md` for user to review and copy.

---
name: pr-description
description: Write a concise PR description based on the diff against the base branch
---

## Process

1. Read the git diff and commit log against the base branch to understand all changes
2. Draft a title and summary following the rules below
3. Ask the user to review. Iterate based on feedback before finalizing

## Title

- Focus on the user-facing or system-level effect of the change, not how it was implemented
- Example: "Fix product enrichment handler to propagate changes downstream" not "Extract OfferEnricher from ProductEnrichmentEventHandler"

## Body structure

The goal is that a reviewer understands *why* the change is proposed and can review it efficiently. The reason for the change must always come through clearly, whether as a separate section or woven into the summary.

Use up to three sections depending on what the change needs. Not all sections are always needed. Use your judgement.

- **Summary**: A few sentences explaining what this PR does and why. Always include this. Keep it short. If the change is simple enough, this alone may be sufficient.
- **Context**: Background information the reviewer needs to understand the problem. Use this when the motivation is not obvious from the summary alone. For example: a bug that is hard to understand without explaining the previous behavior, or a refactor driven by a specific pain point.
- **Changes**: A bullet list of the concrete changes. Use this when the PR touches multiple things and a list helps the reviewer navigate. Skip it for single purpose PRs where the summary already covers everything.

## Content rules

- Each bullet should explain *what changed* and *why*, not implementation details
- Don't mention specific function names, unless specifically asked. Class names are acceptable when they add clarity
- Don't mention test changes, import cleanups, or other mechanical follow-ups unless they represent a meaningful shift in testing strategy
- Avoid mechanical follow-up details. Things like DI/wiring changes, import cleanups, adding tests, or configuration updates are expected parts of any change and don't need their own bullets. Only mention them if they represent a deliberate, notable decision
- Order: most important behavioral change first, then supporting changes

## Writing style

- Write for a reviewer who knows the codebase but hasn't seen the diff
- Be direct and factual, no filler words
- Use simple, plain english. Avoid jargon and fancy phrasing
- Short sentences. Prefer simple structure over complex grammar
- Never use dashes (em dash, en dash) in the output
- Don't start bullets with "We". Use passive voice or start with the subject

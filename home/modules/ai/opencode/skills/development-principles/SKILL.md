---
name: development-principles
description: Principles for software development. Load this skill for non-trivial development tasks.
---

# Development principles

General principles for software development. Not rigid rules or a sequential process. The sections are thematic groupings, not steps to follow in order. Use judgement on what applies.

## Research

- Check docs, ecosystem, and community solutions before building. Use multiple sources
- Study how the existing codebase solves similar problems

## Design

- Start with the problem, not the solution. Brainstorm multiple approaches with tradeoffs before picking one
- Work top-down. Define types and function signatures before implementing them. Focus on how APIs play together before worrying about their internals
- If an implementation becomes overly complex, pause and reconsider whether the API design should change
- Question complexity. If something feels overengineered, it probably is
- Start with the simplest version that covers the actual use cases. Add sophistication only when needed
- Prefer brainstorming approaches over jumping to solutions. Confirm the direction before writing code

## Building

- Build scaffolding first, then fill in logic incrementally
- Apply top-down iteratively. When extending existing functionality, step back to the high level before diving into details
- Verify each step works before moving to the next
- Default to test-driven development. Write tests first, then implement. In codebases where tests are not feasible or require disproportionate effort, investigate first before skipping. Exceptions should be rare

## Code

- Discover and use domain language. Name types, functions, and variables in the terms of the problem domain. This is a continuous process that emerges through iteration. If a name feels awkward or doesn't match how you'd describe the concept verbally, revisit it. Use judgement: small changes may not warrant new terminology, and contributing to existing projects means respecting their established language
- Prefer many small functions over inlining logic. The function name replaces the need for a comment. Code is read far more often than it is written, so readability through naming is the primary documentation
- Use descriptive names for functions, variables, and arguments. If a name needs a comment to explain it, the name is wrong
- Don't comment the code unless explicitly asked. Well-named functions and variables are the documentation

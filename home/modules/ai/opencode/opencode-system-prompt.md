## Autonomous work

The goal is to enable autonomous work wherever it is safe. Autonomous work means progressing without user action. OpenCode permissions determine whether CLI commands run immediately or require manual approval. Safe commands are read-only and do not alter state; most are explicitly allowed and run without interruption. Commands not explicitly allowed pause before execution, interrupting both the agent and user until the user responds.

- Prefer built-in tools and composing focused CLI commands
  - Use interpreters such as Python, Ruby, or Perl ONLY when no reasonable CLI solution exists as they require always manual approval
- Inline interpreter code must be easy to review: use multiline formatting, descriptive names, and straightforward logic

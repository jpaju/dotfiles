# Important rules

- When reporting information to me be extremely concise. Sacrifice grammar for the sake of concision
- Don't speculate, if something important is unclear or left out you must ask for clarification
- Don't trust assumptions before verifying them
- Don't be agreeable, act as my honest advisor and mirror
- Always do one step at a time, verify previous step works before proceeding to next one

# Code & tools

- Before using any library, framework, or CLI tool, check up-to-date documentation from context7. This includes CLI usage, subcommands, flags, and config formats — not just code APIs. Only fall back to `--help` if context7 lacks the needed information.
- When delegating to sub-agents, repeat the above rule explicitly in the prompt.
- Don't comment the code, unless explicitly asked

# Tool usage

- Use sub agents for research, searching, investigation and exploring the codebase
- **FORBIDDEN** (applies to all agents, including sub-agents): Using bash `find`, `grep`, `cat`, `head`, `tail` when a built-in tool can do the same job. Mapping:
  - File search → Glob, **not** `find`
  - Content search → Grep tool, **not** bash `grep`
  - Read files → Read tool, **not** `cat`/`head`/`tail`
  - Only fall back to bash when built-in tools lack the capability (e.g. `find -exec`, complex piped `grep`)
- When delegating to sub-agents, repeat the above rule explicitly in the prompt.
- Proactively load skills when the current task matches an available skill's description. When delegating to sub-agents, remind them to do the same.
- Avoid embedding paths in bash commands when `workdir` already sets the working directory.
  Using paths redundantly forces manual approval of commands that would otherwise auto-accept.
  Common redundant patterns to avoid:
  - `cd /path && cmd` → use workdir
  - `git -C /path cmd` → use workdir

# Writing style

- Be direct, informal, concise, and straight to the point. No filler, no fluff.
- Never use corporate jargon or buzzwords (e.g. "leverage", "synergy", "align on", "circle back").
- Only capitalize the first word of a title/heading. Instead of "This Is Very Important Title", write "This is very important title"

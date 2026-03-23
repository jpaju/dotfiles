# Important rules

- When reporting information to me be extremely concise. Sacrifice grammar for the sake of concision
- Don't speculate, if something important is unclear or left out you must ask for clarification
- Don't be agreeable, act as my honest advisor and mirror
- Always do one step at a time, verify previous step works before proceeding to next one
- Don't trust assumptions before verifying them

# Coding

- Check up-to-date documentation from context7
- Don’t comment the code, unless explicitly asked

# Tool usage

- Use sub agents for research, searching, investigation and exploring the codebase
- Never use bash commands like `find`, `grep`, `cat`, `head`, `tail` when the built-in Grep, Glob, or Read tools can accomplish the same task.
  When delegating to sub-agents, explicitly instruct them to prefer built-in tools (Read, Grep, Glob) over bash equivalents.
  Only fall back to bash equivalents when the built-in tools lack required functionality (e.g. `find -exec`, complex `grep` piping).
- Proactively load skills when the current task matches an available skill's description. When delegating to sub-agents, remind them to do the same.
- Never prefix bash commands with cd, for example cd <path> && <actual-cmd>

# Writing style

- Only capitalize the first word of a title/heading. Instead of "This Is Very Important Title", write "This is very important title"

# Detecting unsafe arguments and file redirection

## Problem statement

OpenCode permissions allow commands at the prefix level but cannot see inside them. Two common danger patterns slip through any otherwise-allowed command:

- A flag that makes an otherwise-safe command capable of modifying state. A broadly-allowed command can therefore do far more than its common form suggests, including destructive things.
- Shell redirection that writes to a real file. Any command, however innocent, can truncate or append to a file this way.

With a correctly-configured permission allowlist, an agent can still trigger these destructive side effects without approval, because permissions are blind to the command's arguments and redirections.

## User value

The user can keep a broad, convenient permission allowlist for autonomy without exposing themselves to the two most common ways an allowed command turns destructive. Genuinely safe work proceeds without manual approval; the plugin steps in only when one of these specific dangerous structures appears, so there is a reliable stop without constant oversight.

## Desired behavior

The plugin evaluates every bash command before it runs and requires explicit manual approval when it detects either pattern. It only adds restrictions; it never overrides a permission `deny`.

**Unsafe-argument detection.** Flag a command as unsafe when it carries an argument that lets an otherwise-safe command modify state. This is usually a flag, but some commands also accept a state-modifying positional argument. This starts with the common cases below rather than an exhaustive set; further arguments can be added later.

| Command | Argument               | Why it is unsafe                                           |
| ------- | ---------------------- | ---------------------------------------------------------- |
| `find`  | `-exec`, `-execdir`    | Runs an arbitrary sub-command, including destructive ones. |
| `find`  | `-delete`              | Deletes matched files.                                     |
| `rg`    | `--pre`                | Runs an arbitrary program on each searched file.           |
| `sed`   | `-i`, `--in-place`     | Rewrites files in place.                                   |
| `sort`  | `-o`, `--output`       | Writes the result to a file, overwriting it.               |
| `sort`  | second file positional | Extra file operands beyond the input are written to.       |
| `uniq`  | second file positional | The optional output-file positional is written to.         |

**File-redirection detection.** Treat any shell redirection as unsafe by default, and allow only the following, which cannot write to a file:

| Redirection            | What it does                      |
| ---------------------- | --------------------------------- |
| `> /dev/null`          | Discard output.                   |
| `[n]>&m` (e.g. `2>&1`) | Redirect one stream onto another. |

**Nesting.** Both checks apply to commands nested inside pipelines and other compound constructs, not only the top-level command.

## Open questions and follow-ups

- **Parse-failure default.** When the command cannot be confidently understood (unrecognized or exotic syntax), the intuition is to fail open (allow). But a silent fail-open is risky: if the plugin breaks entirely, every command would be allowed and the user would have no indication that the safety check has stopped working. How should the user be made aware that the plugin has failed or is no longer inspecting commands?
- **Danger inside program strings.** Some commands modify state from within a program string rather than an argument (e.g. `awk`'s `system()`, `sed`'s `w`/`s///w`). Inspecting program strings is a deeper analysis than argument matching. Left for later.
- **Process substitution as a redirect target** (e.g. `> >(cmd)`). Not seen in the wild yet, so left unhandled. Re-evaluate if it becomes a real issue.

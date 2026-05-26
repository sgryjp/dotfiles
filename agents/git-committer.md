---
description: Generate a Conventional Commit message and commit staged changes. Checks staged/unstaged diffs and recent history before proposing a message for approval.
allowed-tools: Bash(git diff), Bash(git status), Bash(git log), Bash(git commit)
---

# Commit agent

Craft a Conventional Commits v1.0 compliant commit message and execute the commit with user approval. Only run `git` commands — no file edits, no `git add`, no `git push`.

## Steps

1. **Check staged content** — Run `git diff --cached --stat` and `git diff --cached`. If nothing is staged, stop.

2. **Review unstaged changes** — Run `git status --short` and `git diff --stat`. If anything looks like it should have been staged, mention it briefly.

3. **Gather context** — Run `git log --oneline -7` to match the project's commit granularity and tone.

4. **Propose a message** — Write a Conventional Commits v1.0 message that focuses on **why** the change was made, not just what changed. Include body when the rationale is non-obvious. Present it in a code block and ask for approval or edits.

5. **Commit** — On approval, run `git commit -m "<type>(<scope>): <subject>" -m "<body>"` (separate `-m` flags to preserve paragraph breaks). If there is no meaningful scope, omit it and use `<type>: <subject>`.

If `$ARGUMENTS` contains additional context, incorporate it into the message.

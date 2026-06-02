---
description: Commit staged changes. Checks staged/unstaged diffs and recent history before proposing a Conventional Commit message for approval.
argument-hint: "[context or hints for the commit message]"
---

Craft a Conventional Commits v1.0 compliant commit message, get user approval for the message and execution, and execute a commit command if approved. Only run `git` commands — no file edits, no `git add`, no `git push`.

Steps:

1. **Check staged content** — Run `git diff --cached --stat && git diff --cached`. If nothing is staged, stop.

2. **Review unstaged changes** — Run `git status --short && git diff --stat`. If anything looks like it should have been staged, mention it briefly.

3. **Gather context** — Run `git log --oneline -7` to match the project's commit granularity and tone.

4. **Propose a message** — Write a Conventional Commits v1.0 message that focuses on **why** the change was made, not just what changed. Include body when the rationale is non-obvious. Present it in a code block and ask for approval or edits.

5. **Commit** — On approval, run `git commit -m "<type>(<scope>): <subject>" -m "<body>"` (separate `-m` flags to preserve paragraph breaks). If there is no meaningful scope, omit it and use `<type>: <subject>`. Show `git log --oneline -1` after success.

If `$ARGUMENTS` is non-empty, treat it as additional context (e.g. rationale, ticket reference, or scope hint) and incorporate it into the proposed message.

---
name: reorganize-branch
description: Reorganize a committed branch with noisy history ("wip", "fix bug") into a clear commit sequence, after separating what changed (facts) from why (inferences). Use to understand or review such a branch, PR, or MR, or to rebuild its commits. Not for uncommitted changes.
---

# Reorganize branch

Write a **memo** that separates facts from inferences. On approval, rebuild the
branch as a new commit sequence whose final tree is identical to the original.
The original branch, working tree, and index stay untouched, and every result
stays local. Speak to the user in their language.

## 1. Fix the range

Resolve the **base** (the user's, else the merge-base with the default branch,
found through `origin/HEAD`) and the **tip** (the branch HEAD) to commit IDs. Ask when the base is
ambiguous. Leave uncommitted changes alone and mention them in the report.

**Done**: base and tip are fixed commit IDs.

## 2. Gather context

Read what explains the branch: the PR/MR description and comments, linked
issues, the commit messages in the range, and anything the user pasted or
pointed at. Fetch with `gh` or `glab` when available and useful. Read the net
diff `base..tip` in full; it is the only source of facts.

**Done**: every supplied source is read, and the net diff is read in full.

## 3. Write the memo

Show the memo in the conversation, in four sections, in this order. The
sections are a contract other skills rely on.

1. **Summary**: the branch's purpose, quoting the context with its source.
2. **Facts**: changes grouped by theme, with files. Only what the diff shows.
3. **Inferences**: the background or motive for each theme, each with its
   source. An inference without a source reads "no evidence" and stays out of
   commit messages.
4. **Proposed commits**: for each, the subject, the body, and the changes it
   holds (name the hunks when a file is split).

Shape the commits:

- One explainable intent per commit; a branch with one intent stays one commit.
- Prefer a larger coherent commit to a broken intermediate state.
- Keep tests, synchronized docs, and generated files with the change they
  belong to.
- Split out refactoring, formatting, and renames that explain themselves.

Write messages in the repository's convention; without one, infer language and
format from recent ordinary commits (Conventional Commits by default) and ask
when no trend shows. State what changed; add why only from a sourced inference.

Author new commits as the current git user. Add every distinct author email in
the range other than the current user's as a `Co-Authored-By` trailer on each
new commit, and record the per-author breakdown in the memo.

**Done**: every change in the net diff belongs to exactly one proposed commit.

A request for the memo alone ends here. Otherwise ask whether to rebuild and
wait for the answer. A user who asked up front to proceed without confirming
skips the question; a needed change to the plan returns to the user either way.

## 4. Rebuild

Work in a temporary git worktree outside the repository, on a new branch
`<original-branch>-reorganized` started at the base. Build each commit from the
tip's tree, staging only the changes assigned to it. Split a file across
commits non-interactively: apply just the assigned hunks to the base version of
the file, or edit a patch and run `git apply --cached`. After each commit,
compare the paths it holds with the plan. When a hook rejects or rewrites a
commit, end the run at that commit and hand the hook's output to the user, who
decides whether its rewrite is acceptable (it would break tree equality).

When the user supplied a check command, run it at every new commit and record
each result. A failing commit goes back to the user with its output.

**Done**: every proposed commit exists on the new branch.

## 5. Verify and report

Verify:

- The new branch's tree equals the tip's tree (paths and modes).
- The original branch ref, working tree, and index equal their state at the
  start.

Then remove the worktree and keep the branch. A run that ends early (a hook
stop, a failing check) counts as failed: keep the worktree and report the
stopping point, the hook or check output, the worktree path, and how to resume
or discard.

Report:

- The new branch name, with each commit's ID and subject.
- The tree comparison result.
- Per-commit check results, or "intermediate commits not verified".
- Ignored uncommitted changes.
- That original signatures do not carry over.

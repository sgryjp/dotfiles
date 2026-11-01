# reorganize-branch: design

This document records why `SKILL.md` is shaped the way it is. `SKILL.md` is the
only file an agent loads; this one is for maintainers. When the two disagree,
`SKILL.md` is what runs, and this document needs a fix.

## Problem

Pull requests and merge requests often arrive with commit logs such as
"fix bug" and "fix another bug". Reviewing them means reading the whole net
diff anyway, and squash merging does not lighten that load. The reader needs
two things the log does not give:

- **What changed**, as a short list of coherent changes. It can be derived from
  the diff with certainty.
- **Why it changed**. It can only be inferred, from the PR/MR description,
  linked issues, comments, and the existing log. Inferences are only as good
  as their sources.

The skill produces both, keeps them visibly apart, and can then rebuild the
branch as a commit sequence that reads like the memo.

## Audience

The primary user is a **reader** of a branch they did not author, or wrote long
ago. The result is a local branch for reading, never something published. An
author tidying their own branch can use it too, and nothing in the design
excludes that, but no feature exists for that case alone.

## Non-goals

- Uncommitted changes (working tree, index, untracked files). The first version
  of this skill handled them and grew large; see
  [Relationship to the first version](#relationship-to-the-first-version).
- Pushing, force-pushing, or updating a PR/MR.
- Preserving the original topology (merges, order, intermediate states).
- Verifying that intermediate commits build or pass tests, unless the user
  supplies a command.
- Authorship fidelity per commit, signatures, and secret scanning.
- Rendering a shareable report. That is a separate skill (see
  [Report skill](#report-skill)).

## Flow

```
fix range -> gather context -> write memo -> [ask] -> rebuild -> verify -> report
                                    |
                                    +-- memo-only request ends here
```

Each step in `SKILL.md` ends on a completion criterion. The approval question
is the only gate.

## Decisions

### Facts and inferences are separate sections

The diff is the single source of facts. Everything about motive is an
inference and carries its source, or the words "no evidence". Commit messages
state a reason only when it has a source. This is the core of the skill: a
reviewer can trust section 2 of the memo and weigh section 3.

### The memo is a contract

The four memo sections (Summary, Facts, Inferences, Proposed commits) are the
interface other skills consume. Keep them stable. The memo is shown in the
conversation only. The user can ask for a file, which lives outside the
repository, so that nothing about the memo can end up in a commit.

### Rebuild from the final tree, not from the original commits

The new sequence is built by staging assigned changes from the tip's tree onto
the base. It does not replay, cherry-pick, or rebase the original commits. As a
result:

- Merge commits, reordering, renames, and conflicts need no special handling;
  the original history is context for the memo only.
- Correctness reduces to one checkable property: the final trees are equal.

### The original state is never written

The rebuild happens in a temporary worktree on a new branch. The original
branch ref, working tree, and index are not touched, so there is nothing to
back up or restore, and uncommitted changes in the original checkout are
irrelevant. The user switches to the new branch when they want to read it.

Cleaning up removes the worktree only. The branch is the deliverable and stays,
so review can happen later, in another session, with ordinary tools
(`git log`, `git range-diff`, an IDE). On failure the worktree stays for
diagnosis.

### One approval gate

After the memo and proposal, the skill asks whether to rebuild and waits. A
request for the memo alone (including a call from another skill) never builds
and never asks. A user who says up front to proceed without confirming skips the
question. Both flows still stop when execution needs a change to the plan.

### Invariants

Three properties hold in every run and are checked mechanically:

1. The new branch's tree equals the original tip's tree.
2. The original branch ref, working tree, and index are unchanged.
3. Nothing is pushed.

### Intermediate commits are unverified by default

Running checks at every commit is expensive and often not what a reader needs.
The plan groups dependent changes together to keep intermediate states
plausible, and the report says they were not verified. When the user supplies a
command, it runs at each commit. A failure is reported with its output and
returned to the user; the skill does not edit commits to make a check pass,
because repair would grow the rules and risk the tree equality.

### Hooks end the run

A commit hook that rejects a commit or rewrites its content (formatters, as
`pre-commit` does) ends the run at that commit. A rewrite means the rebuilt
tree can no longer equal the tip's, which breaks the central guarantee, so the
decision belongs to the user: accept the rewrite and resume, or discard. The
skill neither retries with the rewritten content nor bypasses the hook. The
worktree stays, and the report names the stopping point, the hook output, and
how to resume or discard. The `hook-rewrites` fixture exercises this.

### Authorship

New commits are authored by the current git user. Every other distinct author
in the range is added as a `Co-Authored-By` trailer on each new commit. Exact
attribution would require assigning hunks to authors per commit, which is
guesswork. The approximation keeps credit visible, including when the branch is
later published over the original, and the memo records the real breakdown.
When the user is the only author, no trailer is added. Original signatures
cannot carry over and the report says so.

### Messages

Repository conventions come first. Otherwise language and format are inferred
from recent ordinary commits, with Conventional Commits as the default, and the
skill asks when there is no trend. The body states what changed; a reason
appears only when backed by a sourced inference.

### Naming

`reorganize-branch` is used instead of `restack-branch`. In stacked-diff
tooling (for example Graphite's `gt restack`), "restack" means rebasing a stack
onto updated parents, which this skill does not do. The name also differs from
`organize-commits`, the first version, which covered uncommitted changes.

### Invocation

The skill is model-invoked: users reach it with phrasings such as "make sense of
this messy PR", and another skill (the report skill) must be able to reach it.
The description carries two branches, understanding/reviewing a branch and
rebuilding its commits, plus the one boundary users run into (uncommitted
changes).

## Report skill

A shareable (HTML) report is a later, separate skill. The dependency runs one
way:

- The report skill uses the memo when one is in context, or a file the user
  names, and otherwise invokes `reorganize-branch` for the memo alone.
- `reorganize-branch` does not mention the report skill. This avoids a cycle and
  keeps this skill usable alone, for example after promotion to a standalone
  repository.
- Cross-skill invocation mechanisms differ between agents. The report skill
  should name this skill and tell the agent to follow its instructions, so the
  text works even without a skill-call tool.

## Relationship to the first version

`organize-commits` (first version) lives on the branch
`wip/organize-commits-v1`. It handled dirty working trees and reconstructed
history with a frozen-snapshot contract, reference restrictions, per-commit
validation, and recovery records. Its rules are not carried over wholesale. The
scenarios in its README informed the tests here. A rule from the first version
returns only when a real failure shows it is needed.

## Tests

Tests live in `tests/reorganize-branch/` of the dotfiles repository, outside
this directory, and run by hand:

- `make-fixture.sh` builds a disposable repository with a noisy branch, a bare
  `origin`, and a dirty working tree, and records a snapshot of the state that
  must not change.
- `verify.sh` checks the invariants and the authorship rule against the
  snapshot after an agent run.

Output quality (grouping, whether a reason is invented) has no single correct
answer and is judged by trying the skill on real branches. Automated evaluation
of quality is deferred.

## Portability

The skill and its tests reference nothing outside `skills/reorganize-branch/`
and `tests/reorganize-branch/`. Promoting them to a standalone repository is
then a history extraction that keeps both paths:

```
git filter-repo --path skills/reorganize-branch --path tests/reorganize-branch
```

## Out of scope: publishing the result

Because the final tree is identical, moving the original branch to the new tip
(`git reset`) changes only history. If the branch was already pushed, the update
needs a force push (`--force-with-lease`), which rewrites the PR/MR history,
can orphan review comments, and diverges anyone else's clone. The skill does
not recommend or perform this. Mentioning it here is for maintainers.

## Open questions

- Behavior on very large diffs (chunking the memo) is untested.
- Whether skill-to-skill invocation behaves the same in pi and Copilot is
  unverified.

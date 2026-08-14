# Personal Coding Guidelines

## Commit Messages

- Project-specific commit-message conventions take precedence over these
  guidelines.
- Subject: `scope: description` (scope = directory/module/service unit; do not
  use class names). Name the changed object. For a shared/cross-cutting module
  (high fan-in), name affected feature(s) in the first body line. Infer high
  fan-in from project-provided structural information when available (e.g.
  sources in a `Utilities` module).
- Body: include the *why* — the rationale for the change — only when derivable
  from session context, an issue, or recent conversation; otherwise omit it.
  Typo fixes, formatting, and trivial test additions may omit the *why*. If a
  high-fan-in or externally observable change has no derivable *why*, ask the
  user once before committing.
- When a change spans multiple scopes: split into separate commits by default.
  If splitting is impractical, use `scopeA, scopeB: description` for changes
  bridging two closely-related scopes (e.g. moving code between modules; order
  reflects direction), or `treewide: description` for mechanical changes
  applied uniformly across the tree (the *why* may be omitted). Otherwise,
  use the scope central to the change.

## Tests and Scenario Names

- Encode *what* behavior is expected — use descriptive test names or scenario
  titles to document the intended behavior, so the test suite itself serves as
  the specification.

## Code Comments

- Focus on *why not* — why the obvious alternatives weren't chosen, if such
  alternatives exist. Don't just describe what the code does.

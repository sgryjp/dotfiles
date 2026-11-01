# reorganize-branch tests

Manual checks of the invariants in
[`DESIGN.md`](../../skills/reorganize-branch/DESIGN.md). The agent's run is
manual; the checks after it are mechanical.

## Run

```sh
dest=$(mktemp -d)/fixture
./make-fixture.sh multi-author "$dest"   # or with-merge, with-rename, mixed-themes, hook-rewrites, hook-rewrites
cd "$dest/repo"
# Start your agent here and ask it to use reorganize-branch on
# feature/search and rebuild without asking for confirmation.
cd - && ./verify.sh "$dest" feature/search-reorganized
```

## Scenarios

| Scenario       | Exercises                                                  |
| -------------- | ---------------------------------------------------------- |
| `multi-author` | `Co-Authored-By` for every other author                    |
| `with-merge`   | A merge in the range; rebuilt history stays linear         |
| `with-rename`  | A rename across commits; no trailers for a single own-author branch |
| `mixed-themes` | A refactor and a feature sharing one file, plus formatting, tests, and docs; expects 2+ commits |
| `hook-rewrites` | A hook that rewrites content and fails the commit; expects the run to stop, keep the worktree, and report |

Every fixture also has staged, unstaged, and untracked changes plus a bare
`origin`, to confirm the original checkout and the remote are untouched.

## Not covered

Grouping quality and invented reasons need judgment; try the skill on real
branches instead.

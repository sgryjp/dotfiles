#!/usr/bin/env bash
# Check the reorganize-branch invariants after an agent run.
#
# Usage: verify.sh <fixture-dir> <new-branch>
#
# <fixture-dir> comes from make-fixture.sh. Exits non-zero when any check fails.
# The check functions below are invoked indirectly through check().
# shellcheck disable=SC2329
set -uo pipefail

usage="usage: verify.sh <fixture-dir> <new-branch>"
dir=${1:?$usage}
new=${2:?$usage}
repo=$dir/repo
snapshot=$dir/snapshot
me_email=reviewer@example.com

g() { git -C "$repo" "$@"; }
snap() { sed -n "s/^$1=//p" "$snapshot"; }

failed=0
# check <description> <command...>
check() {
  local description=$1
  shift
  if "$@" >/dev/null 2>&1; then
    echo "PASS  $description"
  else
    echo "FAIL  $description"
    failed=1
  fi
}

branch=$(snap branch)
tip=$(snap tip)
base=$(snap base)

original_branch_unchanged() { [ "$(g rev-parse "refs/heads/$branch")" = "$tip" ]; }
head_still_on_original() { [ "$(g symbolic-ref --short HEAD)" = "$branch" ]; }
status_unchanged() { [ "$(g status --porcelain | git hash-object --stdin)" = "$(snap status)" ]; }
index_unchanged() { [ "$(g write-tree)" = "$(snap index)" ]; }
files_unchanged() {
  [ "$(for f in README.md scratch.txt staged.txt; do git hash-object "$repo/$f"; done | git hash-object --stdin)" = "$(snap files)" ]
}
remote_unchanged() { [ "$(g ls-remote origin | git hash-object --stdin)" = "$(snap remote)" ]; }
new_branch_exists() { g rev-parse --verify -q "refs/heads/$new"; }
trees_equal() { [ "$(g rev-parse "$new^{tree}")" = "$(g rev-parse "$tip^{tree}")" ]; }
built_on_base() { g merge-base --is-ancestor "$base" "$new"; }
history_linear() { [ -z "$(g rev-list --merges "$base..$new")" ]; }
has_enough_commits() { [ "$(g rev-list --count "$base..$new")" -ge "$(cat "$dir/expected-min-commits")" ]; }
worktree_kept() { [ "$(g worktree list | wc -l)" -gt 1 ]; }
no_leftover_worktree() { [ "$(g worktree list | wc -l)" -eq 1 ]; }
authored_by_current_user() { ! g log --format=%ae "$base..$new" | grep -qv -x "$me_email"; }

# Every expected co-author is a trailer on every new commit, and no other
# fixture identity (@example.com) appears as one.
coauthors_as_expected() {
  local commit trailers email
  for commit in $(g rev-list "$base..$new"); do
    trailers=$(g show -s --format=%B "$commit" | grep -i '^Co-Authored-By:' || true)
    while read -r email; do
      [ -z "$email" ] && continue
      grep -qi "<$email>" <<<"$trailers" || return 1
    done <"$dir/expected-coauthors"
    while read -r email; do
      grep -qx -i "$email" "$dir/expected-coauthors" || return 1
    done < <(grep -o -i '<[^>]*@example\.com>' <<<"$trailers" | tr -d '<>')
  done
}

check "original branch ref is unchanged" original_branch_unchanged
check "checked-out branch is still the original" head_still_on_original
check "git status is unchanged" status_unchanged
check "index content is unchanged" index_unchanged
check "dirty files are unchanged" files_unchanged
check "remote refs are unchanged (nothing pushed)" remote_unchanged
if [ "$(cat "$dir/expected-outcome")" = success ]; then
  check "new branch exists" new_branch_exists
  check "new branch tree equals original tip tree" trees_equal
  check "new branch is built on the base" built_on_base
  check "new branch history is linear" history_linear
  check "new branch has the expected minimum number of commits" has_enough_commits
  check "no temporary worktree remains" no_leftover_worktree
  check "new commits are authored by the current user" authored_by_current_user
  check "co-author trailers match the original authors" coauthors_as_expected
else
  # The run could not complete: the worktree is kept for diagnosis.
  check "temporary worktree is kept for diagnosis" worktree_kept
fi

exit "$failed"

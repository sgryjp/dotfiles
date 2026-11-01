#!/usr/bin/env bash
# Build a disposable repository for exercising the reorganize-branch skill.
#
# Usage: make-fixture.sh <multi-author|with-merge|with-rename|mixed-themes|hook-rewrites> <dest-dir>
#
# Creates <dest-dir>/repo (checked out on a noisy feature branch with a dirty
# working tree), <dest-dir>/origin.git (bare remote), <dest-dir>/snapshot (state
# that must not change), and <dest-dir>/expected-coauthors (one email per line).
set -euo pipefail

usage="usage: make-fixture.sh <multi-author|with-merge|with-rename|mixed-themes|hook-rewrites> <dest-dir>"
scenario=${1:?$usage}
dest=${2:?$usage}
if [ -e "$dest" ]; then
  echo "$dest already exists" >&2
  exit 1
fi
mkdir -p "$dest"
dest=$(cd "$dest" && pwd)
repo=$dest/repo

me_name=Reviewer
me_email=reviewer@example.com

g() { git -C "$repo" "$@"; }

# commit_as <author-name> <author-email> <message>
commit_as() {
  g add -A
  env GIT_AUTHOR_NAME="$1" GIT_AUTHOR_EMAIL="$2" git -C "$repo" commit -q -m "$3"
}

git init -q -b main --bare "$dest/origin.git"
git init -q -b main "$repo"
g config user.name "$me_name"
g config user.email "$me_email"
g config commit.gpgsign false
g remote add origin "$dest/origin.git"

mkdir -p "$repo/src" "$repo/tests"
printf '# demo\n' >"$repo/README.md"
printf 'def greet(name):\n    return "hello " + name\n\n\ndef farewell(name):\n    return "bye " + name\n\n\ndef main():\n    print(greet("world"))\n' >"$repo/src/app.py"
printf 'from src.app import greet\ndef test_greet():\n  assert greet('"'a'"')=='"'hello a'"'\n' >"$repo/tests/test_app.py"
commit_as "$me_name" "$me_email" "chore: initial commit"
g push -q origin main
g remote set-head origin main
g switch -q -c feature/search

: >"$dest/expected-coauthors"
echo 1 >"$dest/expected-min-commits"
echo success >"$dest/expected-outcome"

case $scenario in
  multi-author)
    printf 'def search(items, q):\n    return [i for i in items if q in i]\n' >"$repo/src/search.py"
    commit_as Alice alice@example.com "wip"
    printf 'from src.search import search\n\n\ndef test_search():\n    assert search(["a", "b"], "a") == ["a"]\n' >"$repo/tests/test_search.py"
    commit_as Bob bob@example.com "fix bug"
    printf 'def search(items, q):\n    q = q.lower()\n    return [i for i in items if q in i.lower()]\n' >"$repo/src/search.py"
    commit_as Alice alice@example.com "fix another bug"
    printf 'alice@example.com\nbob@example.com\n' >"$dest/expected-coauthors"
    ;;
  with-merge)
    printf 'def search(items, q):\n    return [i for i in items if q in i]\n' >"$repo/src/search.py"
    commit_as Alice alice@example.com "wip"
    g switch -q -c side
    mkdir -p "$repo/docs"
    printf '# Search\n\nCall search(items, q).\n' >"$repo/docs/usage.md"
    commit_as Alice alice@example.com "docs"
    g switch -q feature/search
    printf 'def search(items, q):\n    q = q.lower()\n    return [i for i in items if q in i.lower()]\n' >"$repo/src/search.py"
    commit_as Alice alice@example.com "fix bug"
    g merge -q --no-ff side -m "Merge branch 'side' into feature/search"
    printf 'from src.search import search\n\n\ndef test_search():\n    assert search(["a", "b"], "A") == ["a"]\n' >"$repo/tests/test_search.py"
    commit_as Alice alice@example.com "fix another bug"
    printf 'alice@example.com\n' >"$dest/expected-coauthors"
    ;;
  with-rename)
    printf 'def lookup(items, q):\n    return [i for i in items if q in i]\n' >"$repo/src/lookup.py"
    commit_as "$me_name" "$me_email" "wip"
    g mv src/lookup.py src/search.py
    commit_as "$me_name" "$me_email" "rename"
    printf 'def search(items, q):\n    q = q.lower()\n    return [i for i in items if q in i.lower()]\n' >"$repo/src/search.py"
    commit_as "$me_name" "$me_email" "fix bug"
    ;;
  mixed-themes)
    # A refactor and a feature share src/app.py; formatting, tests and docs
    # are mixed in. Expect at least a tidy-up commit and a feature commit.
    sed -i.bak 's/    return "hello " + name/    return f"hello {name}"/' "$repo/src/app.py"
    rm "$repo/src/app.py.bak"
    printf '\n\ndef find(items, q):\n    from src.search import search\n\n    return search(items, q)\n' >>"$repo/src/app.py"
    printf 'def search(items, q):\n    return [i for i in items if q in i]\n' >"$repo/src/search.py"
    commit_as Alice alice@example.com "wip"
    printf 'def search(items, q):\n    q = q.lower()\n    return [i for i in items if q in i.lower()]\n' >"$repo/src/search.py"
    printf 'from src.search import search\n\n\ndef test_search():\n    assert search(["a", "b"], "A") == ["a"]\n' >"$repo/tests/test_search.py"
    commit_as Alice alice@example.com "fix bug"
    printf 'from src.app import greet\n\n\ndef test_greet():\n    assert greet("a") == "hello a"\n' >"$repo/tests/test_app.py"
    mkdir -p "$repo/docs"
    printf '# Search\n\nCall find(items, q); matching ignores case.\n' >"$repo/docs/usage.md"
    commit_as Alice alice@example.com "more"
    printf 'alice@example.com\n' >"$dest/expected-coauthors"
    echo 2 >"$dest/expected-min-commits"
    ;;
  hook-rewrites)
    # The tip contains trailing whitespace. A formatter-style hook, installed
    # after the noisy commits exist, strips it and fails the commit, as
    # pre-commit does. Rebuilding cannot reach an identical tree, so the
    # skill must stop and report instead of committing the rewritten content.
    printf 'def search(items, q):  \n    return [i for i in items if q in i]\n' >"$repo/src/search.py"
    commit_as Alice alice@example.com "wip"
    printf 'from src.search import search\n\n\ndef test_search():\n    assert search(["a", "b"], "a") == ["a"]\n' >"$repo/tests/test_search.py"
    commit_as Alice alice@example.com "fix bug"
    cat >"$repo/.git/hooks/pre-commit" <<'HOOK'
#!/bin/sh
# Strip trailing whitespace from staged Python files, then fail so the commit
# has to be redone with the rewritten content.
changed=0
for f in $(git diff --cached --name-only --diff-filter=ACM -- '*.py'); do
  if grep -q '[[:space:]]$' "$f"; then
    sed -i.bak 's/[[:space:]]*$//' "$f" && rm -f "$f.bak"
    echo "trailing-whitespace: fixed $f" >&2
    changed=1
  fi
done
exit $changed
HOOK
    chmod +x "$repo/.git/hooks/pre-commit"
    printf 'alice@example.com\n' >"$dest/expected-coauthors"
    echo stopped >"$dest/expected-outcome"
    ;;
  *)
    echo "$usage" >&2
    exit 1
    ;;
esac

# Dirty state the skill must leave alone: unstaged, untracked, and staged.
printf 'local note\n' >>"$repo/README.md"
printf 'scratch\n' >"$repo/scratch.txt"
printf 'staged\n' >"$repo/staged.txt"
g add staged.txt

{
  echo "branch=feature/search"
  echo "tip=$(g rev-parse HEAD)"
  echo "base=$(g rev-parse main)"
  echo "status=$(g status --porcelain | git hash-object --stdin)"
  echo "index=$(g write-tree)"
  echo "files=$(for f in README.md scratch.txt staged.txt; do git hash-object "$repo/$f"; done | git hash-object --stdin)"
  echo "remote=$(g ls-remote origin | git hash-object --stdin)"
} >"$dest/snapshot"

echo "fixture ready: $repo"

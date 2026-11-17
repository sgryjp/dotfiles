dotfiles
========

This repository stores my personal dot files.

## Agent skills

[`reorganize-branch`](skills/reorganize-branch/SKILL.md) plans a clearer commit
sequence for a committed branch and, with approval, rebuilds it on a new local
branch without changing the original.

Install it for supported coding agents using [skills](https://skills.sh/) or
[gh skills](https://cli.github.com/manual/gh_skill):

```sh
npx skills add sgryjp/dotfiles --skill reorganize-branch
```

```sh
gh skills install sgryjp/dotfiles reorganize-branch
```

When no version is specified, `gh skills` prefers the latest tagged release
over the default branch.

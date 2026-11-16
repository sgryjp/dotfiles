dotfiles
========

This repository stores my personal dot files.

## Agent skills

[`reorganize-branch`](skills/reorganize-branch/SKILL.md) plans a clearer commit
sequence for a committed branch and, with approval, rebuilds it on a new local
branch without changing the original.

Install it for Pi at user scope with either of these commands:

```sh
npx skills add sgryjp/dotfiles --skill reorganize-branch --agent pi --global
```

```sh
gh skill install sgryjp/dotfiles reorganize-branch --agent pi --scope user
```

For another agent or installation scope, adjust the flags; see the
[`skills` CLI documentation](https://github.com/vercel-labs/skills) or the
[`gh skill install` manual](https://cli.github.com/manual/gh_skill_install).
When no version is specified, `gh skill install` prefers the latest tagged
release over the default branch.

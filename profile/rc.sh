# shellcheck shell=sh
# Shared interactive setup. This should be sourced from ~/.bashrc or ~/.zshrc.

# Aliases
case $(uname) in
  Darwin) alias ls='ls -F -G -D %Y-%m-%d\ %H:%M' ;;
  Linux) alias ls='ls -F --color=auto --time-style=iso' ;;
esac
alias ll='ls -l'
alias la='ls -a'
alias l.='ls -d .*'
alias grep='grep --color'
alias egrep='egrep --color'
alias gd='git diff'
alias gl='git graph'
alias gla='git graph $(git for-each-ref --format="%(refname:short)" refs/heads refs/tags refs/remotes | tr "\n" " ")'
alias gs='git status --short --branch --ahead-behind'
alias gwa='git worktree add'
alias gwl='git worktree list'
alias gwp='git worktree prune'
alias ,ps='ps -Hfu $(id -un)'

# fzf
if command -v fzf >/dev/null; then
  # https://junegunn.github.io/fzf/shell-integration/
  export FZF_CTRL_T_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"

  # if command -v rg >/dev/null; then
  #     export FZF_DEFAULT_COMMAND="rg --files --follow"
  # fi
  # export FZF_DEFAULT_OPTS="--height 40% --inline-info"
  # export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
fi

# Other settings for interactive use
EDITOR='vi'
command -v vim >/dev/null && EDITOR=$(command -v vim)
command -v nvim >/dev/null && EDITOR=$(command -v nvim)
export EDITOR
export HISTSIZE=8192
export HISTFILESIZE=8192

if command -v less >/dev/null; then
  PAGER=$(command -v less)
  export PAGER
fi

# Zsh-specific interactive setup. This should be sourced from ~/.zshrc.

# Prompt
PS1="%(?..%F{red}[%?]%f )"
PS1+="%m:%U%~%u%# "
export PS1

# Key bindings
bindkey -e

# Completion
if command -v brew >/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
autoload -Uz compinit && compinit

# fzf
if command -v fzf >/dev/null; then
  # https://junegunn.github.io/fzf/shell-integration/
  source <(fzf --zsh)
fi

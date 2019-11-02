# Zsh built-in features
autoload -U compinit promptinit
compinit
promptinit

zstyle ':completion:*' menu select
prompt walters

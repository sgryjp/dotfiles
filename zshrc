# Antigen plug-in management
source ~/.local/antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# Zsh built-in features
autoload -U compinit promptinit
compinit
promptinit

zstyle ':completion:*' menu select
prompt walters

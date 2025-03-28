# Goodies for interactive use. This should be sourced from
# ~/.zshrc or ~/.bashrc.

# Aliases
case $(uname) in
    Darwin) alias ls='ls -F -G -D %Y-%m-%d\ %H:%M' ;;
    Linux)  alias ls='ls -F --color=auto --time-style=iso' ;;
esac
alias ll='ls -l'
alias la='ls -a'
alias l.='ls -d .*'
alias grep='grep --color'
alias egrep='egrep --color'
alias gb='git show-branch'
alias gd='git diff'
alias gl='git graph'
alias gla='git graph $(git for-each-ref --format="%(refname:short)" refs/heads refs/tags refs/remotes | tr "\n" " ")'
alias gs='git status --short --branch --ahead-behind'
alias ,ps='ps -Hfu $(id -un)'

# PS1
if test -n "$BASH_VERSION"; then
    rst='\[\e[0m\]'
    ul='\[\e[4m\]'
    red='\[\e[0;31m\]'
    PS1="\$("
    PS1+="status="\$?"; "
    PS1+="if [ \$status -ne 0 ]; then echo \"$red[\$status] $rst\"; fi"
    PS1+=")"
    PS1+="\u@"
    PS1+="\h:${ul}\w${rst}\$ "
    unset rst ul red
    export PS1
fi
if test -n "$ZSH_VERSION"; then
    PS1="%(?..%F{red}[%?]%f )"
    PS1+="%m:%U%~%u%# "
    export PS1
fi

# Keybind
if test -n "$BASH_VERSION"; then
    set -o emacs
fi
if test -n "$ZSH_VERSION"; then
    bindkey -e
fi

# Completion
if test -n "$ZSH_VERSION"; then
    if command -v brew >/dev/null; then
        FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    fi
    autoload -Uz compinit && compinit
fi

# fzf
if command -v fzf >/dev/null; then
    if command -v rg >/dev/null; then
        export FZF_DEFAULT_COMMAND="rg --files --follow"
    fi
    export FZF_DEFAULT_OPTS="--height 40% --inline-info"
    export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

    [ -n "$BASH_VERSION" ] && [ -f ~/.fzf.bash ] && source ~/.fzf.bash
    [ -n "$ZSH_VERSION" ] && [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# Other settings for interactive use
EDITOR=vi
command -v vim  >/dev/null && EDITOR=$(command -v vim)
command -v nvim >/dev/null && EDITOR=$(command -v nvim)
export EDITOR
export HISTSIZE=8192
export HISTFILESIZE=8192

command -v less >/dev/null && export PAGER=$(command -v less)

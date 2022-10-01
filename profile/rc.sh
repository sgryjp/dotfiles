# Goodies for interactive use. This should be sourced from
# ~/.zshrc or ~/.bashrc.

# Aliases
case `uname` in
    Darwin) LSOPTS='-G';;
    Linux)  LSOPTS='--color=auto';;
esac
alias ls='ls -F $LSOPTS'
alias ll='ls -l'
alias la='ls -a'
alias l.='ls -d .*'
alias grep='grep --color'
alias egrep='egrep --color'
alias gb='git show-branch'
alias gd='git diff'
alias gl='git log --graph --oneline --decorate'
alias gs='git status -s'
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
    # PS1+="\u@"
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
    autoload -Uz compinit && compinit
fi

# Other settings for interactive use
EDITOR=vi
if command -v vim > /dev/null; then
    EDITOR=`command -v vim`
fi
if command -v nvim > /dev/null; then
    EDITOR=`command -v nvim`
fi
export EDITOR
export HISTSIZE=8192
export HISTFILESIZE=8192

if command -v less > /dev/null; then
    export PAGER=`command -v less`
fi
if command -v fzf > /dev/null; then
    if command -v rg > /dev/null; then
        export FZF_DEFAULT_COMMAND="rg --files --follow"
    fi
    export FZF_DEFAULT_OPTS="--height 40% --inline-info"
fi

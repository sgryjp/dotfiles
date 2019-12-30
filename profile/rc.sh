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
alias gd='git diff'
alias gl='git log --graph --oneline --decorate'
alias gs='git status -s'

# PS1
if test -n "$BASH_VERSION"; then
    rst='\[\e[0m\]'
    ul='\[\e[4m\]'
    red='\[\e[0;31m\]'
    PS1="\$("
    PS1+="status="\$?"; "
    PS1+="if [ \$status -ne 0 ]; then echo \"$red[\$status] $rst\"; fi"
    PS1+=")"
    PS1+="\u@\h:${ul}\w${rst}\$ "
    unset rst ul red
    export PS1
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

if command -v less > /dev/null; then
    export PAGER=`command -v less`
fi
if command -v fzf > /dev/null; then
    if command -v rg > /dev/null; then
        export FZF_DEFAULT_COMMAND="rg --files --follow"
    fi
    export FZF_DEFAULT_OPTS="--height 40% --inline-info"
fi

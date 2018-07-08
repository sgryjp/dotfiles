# MacPorts
if [ -d /opt/local/bin ]; then
	PATH="/opt/local/bin:$PATH"
fi
if [ -d /opt/local/sbin ]; then
	PATH="/opt/local/sbin:$PATH"
fi
export PATH

# Settings
#export LANG='ja_JP.UTF-8'
#export LC_ALL='ja_JP.UTF-8'
export PATH=$HOME/bin:$PATH
export EDITOR=vi
if command -v vim > /dev/null; then
    export EDITOR=`command -v vim`
fi
if command -v less > /dev/null; then
    export PAGER=`command -v less`
fi

# Bash settings
export HISTIGNORE=clear:pwd:fg*:bg*
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    # for bash-completion from MacPorts
	. /opt/local/etc/profile.d/bash_completion.sh
fi

# for Python 3 on Mac OS X, and MacPorts
if [ -d /Library/Frameworks/Python.framework/Versions/Current/bin ]; then
	PATH=/Library/Frameworks/Python.framework/Versions/Current/bin:$PATH
fi
export PATH

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

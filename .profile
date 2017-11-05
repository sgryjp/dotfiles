# Settings
#export LANG='ja_JP.UTF-8'
#export LC_ALL='ja_JP.UTF-8'
export PATH=$HOME/bin:$PATH
export EDITOR=`which vi`
if which vim > /dev/null; then export EDITOR=`which vim`; fi
if which less > /dev/null; then export PAGER=`which less`; fi

# Bash settings
export HISTIGNORE=clear:pwd:fg*:bg*:rm*

# for Python 3 on Mac OS X, and MacPorts
if [ -d /Library/Frameworks/Python.framework/Versions/Current/bin ]; then
	PATH=/Library/Frameworks/Python.framework/Versions/Current/bin:$PATH
fi
if [ -d /opt/local/bin ]; then
	PATH="/opt/local/bin:$PATH"
fi
if [ -d /opt/local/sbin ]; then
	PATH="/opt/local/sbin:$PATH"
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

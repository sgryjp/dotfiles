# I don't wanna maintain two config files.
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# aliases
alias ls='ls -FG'
alias ll='ls -l'
alias la='ls -a'
alias l.='ls -d .*'
alias grep='grep --color'

# for Python 3 on Mac OS X
if [ -d /Library/Frameworks/Python.framework/Versions/Current/bin ]; then
	PATH=/Library/Frameworks/Python.framework/Versions/Current/bin:$PATH
	export PATH
fi

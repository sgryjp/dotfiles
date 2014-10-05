alias ls='ls -FG'
alias ll='ls -l'
alias la='ls -a'
alias l.='ls -d .*'
alias grep='grep --color'

if [ $HOSTNAME == 'solo.local' ]
	PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
	export PATH
fi

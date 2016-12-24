# .bash_profile

# Import aliases
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

# Settings
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export PATH=$PATH:$HOME/bin
export EDITOR=`which vi`
if which vim > /dev/null; then export EDITOR=`which vim`; fi
if which less > /dev/null; then export PAGER=`which less`; fi

# Bash settings
export HISTIGNORE=clear:ls*:pwd:fg*:bg*:rm*

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

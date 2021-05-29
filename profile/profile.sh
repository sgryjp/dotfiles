export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export PATH=$HOME/bin:$HOME/.local/bin:$PATH

if command -v nodenv > /dev/null; then
    eval "$(nodenv init -)"
fi

umask 022

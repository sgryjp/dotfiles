# Goodies for non-interactive use. This should be source from:
# ~/.zprofile, ~/.bash_profile or ~/.profile.

export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export PATH=$HOME/bin:$HOME/.local/bin:$PATH

[ -d $HOME/.cargo/bin ]  && PATH=$PATH:$HOME/.cargo/bin
command -v go >/dev/null || PATH=$PATH:$(go env GOPATH)/bin
export PATH

umask 022

if test -x ~/.linuxbrew/bin/brew; then
    eval $(~/.linuxbrew/bin/brew shellenv)
fi

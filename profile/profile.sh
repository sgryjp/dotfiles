# Goodies for non-interactive use. This should be source from:
# ~/.zprofile, ~/.bash_profile or ~/.profile.

export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
PATH=$HOME/bin:$HOME/.local/bin:$PATH

[ -d /snap/bin ]         && PATH=/snap/bin:$PATH
[ -d $HOME/.cargo/bin ]  && PATH=$PATH:$HOME/.cargo/bin
command -v go >/dev/null && PATH=$PATH:$(go env GOPATH)/bin

if command -v fnm >/dev/null; then
    PATH="$XDG_DATA_HOME/fnm:$PATH"
    eval "`fnm env --use-on-cd`"
    [ -n "$BASH_VERSION" ] && eval "`fnm completions --shell bash`"
    [ -n "$ZSH_VERSION" ]  && eval "`fnm completions --shell zsh`"
fi

export PATH
umask 022

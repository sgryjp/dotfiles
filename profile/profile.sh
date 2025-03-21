# Goodies for non-interactive use. This should be source from:
# ~/.zprofile, ~/.bash_profile or ~/.profile.

# General coonfigurations
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LESSCHARSET='utf-8'
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
PATH=$HOME/bin:$HOME/.local/bin:$PATH

# Use bat as man-pager
# https://github.com/sharkdp/bat/issues/1433#issuecomment-745206164
command -v bat >/dev/null && export MANPAGER='sh -c "col -bx | bat -l man -p"'

# Snap
[ -d /snap/bin ]         && PATH=/snap/bin:$PATH

# Rust (Cargo)
[ -d $HOME/.cargo/bin ]  && PATH=$PATH:$HOME/.cargo/bin

# Go
command -v go >/dev/null && PATH=$PATH:$(go env GOPATH)/bin

# Node.js (fnm)
if command -v fnm >/dev/null; then
    PATH="$XDG_DATA_HOME/fnm:$PATH"
    eval "`fnm env --use-on-cd`"
    [ -n "$BASH_VERSION" ] && eval "`fnm completions --shell bash`"
    [ -n "$ZSH_VERSION" ]  && eval "`fnm completions --shell zsh`"
fi

# Python (pip)
export PIP_REQUIRE_VIRTUALENV=true

export PATH
umask 022

export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# https://unix.stackexchange.com/questions/217622/add-path-to-path-if-not-already-in-path
pathmunge () {
    if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH="$PATH:$1"
        else
            PATH="$1:$PATH"
        fi
    fi
}
pathmunge "$HOME/bin"
pathmunge "$HOME/.local/bin"

if test -x ~/.linuxbrew/bin/brew; then
    eval $(~/.linuxbrew/bin/brew shellenv)
fi

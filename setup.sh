#!/bin/sh
SCRIPT_PATH=$(cd $(dirname $0) && pwd -P)

canonicalize() {
    _COUNT=100
    _DIRNAME=$(dirname $1)
    _BASENAME=$(basename $1)

    while test -L "$_DIRNAME/$_BASENAME"; do
        _TARGET=$(readlink "$_DIRNAME/$_BASENAME")
        _DIRNAME=$(dirname "$_TARGET")
        _BASENAME=$(basename "$_TARGET")

        if test $_COUNT -le 0; then
            echo "error: too many recursion" >&2
            return 1
        fi
        _COUNT=$(expr $_COUNT + 1)
    done

    CANONICALIZED=$(cd $_DIRNAME && pwd -P)/$_BASENAME
    unset _DIRNAME _BASENAME
}

makelink() {
    # Resolve canonicalized path of the target file
    canonicalize $2
    if test $? -ne 0; then
         echo "error: failed to resolve canonicalized path of $2" >&2
         return 1
    fi

    # Make a link unless the target is a symlink to the source
    if test "$CANONICALIZED" != "$1"; then
        ln -fsv "$1" "$2"
        if test $? -ne 0; then
            echo "error: failed to create a link \"$2\"" >&2
            return 1
        fi
        unset CANONICALIZED
    fi
    return 0
}

# usage: insert_line LINE_TO_INSERT FILE
insert_line() {
    # Ensure that the target file exists
    if test ! -e $2; then
        mkdir -pv $(dirname $2)
        touch $2
    fi

    # Insert a line to "source" the target file if not inserted yet
    if test $(grep "$1" $2 | wc -l 2>/dev/null) = 0; then
        echo "Inserting \"$1\" into \"$2\""
        echo "$1" >> $2
    fi
}

# usage: insert_source_line TARGET FILE
insert_source_line() {
    # Ensure that the target file exists
    if test ! -e $2; then
        mkdir -pv $(dirname $2)
        touch $2
    fi

    # Insert a line to "source" the target file
    if test $(grep \"$1\" $2 | wc -l 2>/dev/null) = 0; then
        echo "Modifying \"$2\" to source \"$1\""
        echo "if test -r \"$1\"; then" >> $2
        echo "    source \"$1\"" >> $2
        echo "fi" >> $2
    fi
}

# Profile
if test -e ~/.bashrc; then
    insert_source_line $SCRIPT_PATH/profile/rc.sh   ~/.bashrc
fi
if test -e ~/.zshrc; then
    insert_source_line $SCRIPT_PATH/profile/rc.sh   ~/.zshrc
fi
if test -e ~/.profile; then
    insert_source_line $SCRIPT_PATH/profile/profile.sh  ~/.profile
fi
if test -e ~/.bash_profile; then
    insert_source_line $SCRIPT_PATH/profile/profile.sh  ~/.bash_profile
fi
if test -e ~/.zprofile; then
    insert_source_line $SCRIPT_PATH/profile/profile.sh  ~/.zprofile
fi
insert_line "set editing-mode emacs"                ~/.inputrc
makelink $SCRIPT_PATH/tmux.conf                     ~/.tmux.conf

# Git
if command -v git > /dev/null; then
    mkdir -pv ~/.config/git
    makelink $SCRIPT_PATH/git/ignore ~/.config/git/ignore
    already_sourced=no
    for path in $(git config --global --get-all include.path); do
        if test $path -ef $SCRIPT_PATH/git/config; then
            already_sourced=yes
        fi
    done
    if test $already_sourced = "no"; then
        git config --global --add include.path $SCRIPT_PATH/git/config
        echo "Updated 'include.path' of Git config as:"
        git config --global --get-all include.path
    fi
fi

# VIM
mkdir -pv ~/.vim/autoload ~/.vim/colors
makelink $SCRIPT_PATH/vimfiles/vimrc                ~/.vim/vimrc
makelink $SCRIPT_PATH/vimfiles/autoload/plug.vim    ~/.vim/autoload/plug.vim

# Neovim
mkdir -pv ~/.config/nvim/autoload
makelink $SCRIPT_PATH/nvim/init.lua                 ~/.config/nvim/init.lua
makelink $SCRIPT_PATH/vimfiles/autoload/plug.vim    ~/.config/nvim/autoload/plug.vim

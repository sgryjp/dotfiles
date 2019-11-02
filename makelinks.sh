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
        unset CANONICALIZED
        return 0
    fi
    return 1
}

insert_source_line() {
    # Create the target file
    if test ! -e $2; then
        mkdir -pv $(dirname $2)
        touch $2
    fi

    # Insert a line to "source" the target file
    if test $(grep $1 $2 | wc -l 2>/dev/null) = 0; then
        echo "Modifying \"$2\" to source \"$1\""
        echo "if test -e $1; then source $1; fi" >> $2
    fi
}

# Files to be replaced
mkdir -pv ~/.config/git
for F in git/config git/ignore; do
    makelink $SCRIPT_PATH/$F ~/.config/$F
done
makelink $SCRIPT_PATH/zsh/antigen.zsh ~/.local/antigen.zsh
makelink $SCRIPT_PATH/inputrc         ~/.inputrc

# Files to be additionally sourced
insert_source_line $SCRIPT_PATH/bashrc  ~/.bashrc
if test -e ~/.profile; then
    insert_source_line $SCRIPT_PATH/profile.alias ~/.profile
    insert_source_line $SCRIPT_PATH/profile.env   ~/.profile
    insert_source_line $SCRIPT_PATH/profile.misc  ~/.profile
fi
insert_source_line $SCRIPT_PATH/zshrc   ~/.zshrc
if test -e ~/.zprofile; then
    insert_source_line $SCRIPT_PATH/profile.alias ~/.zprofile
    insert_source_line $SCRIPT_PATH/profile.env   ~/.zprofile
    insert_source_line $SCRIPT_PATH/profile.misc  ~/.zprofile
fi

# VIM
mkdir -pv ~/.vim/autoload
makelink $SCRIPT_PATH/vimfiles/vimrc             ~/.vim/vimrc
makelink $SCRIPT_PATH/vimfiles/autoload/plug.vim ~/.vim/autoload/plug.vim

# Neovim
mkdir -pv ~/.config/nvim/
makelink $SCRIPT_PATH/init.vim ~/.config/nvim/init.vim

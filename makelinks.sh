#!/bin/sh
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

makelink() {
    if test "$(readlink -f $2)" != "$1"; then
        ln -fsv "$1" "$2"
    fi
}

for F in bashrc gitconfig gitignore inputrc profile; do
    makelink $SCRIPT_PATH/$F ~/.$F
done

mkdir -vp ~/.vim/autoload
makelink $SCRIPT_PATH/vimfiles/vimrc             ~/.vim/vimrc
makelink $SCRIPT_PATH/vimfiles/autoload/plug.vim ~/.vim/autoload/plug.vim

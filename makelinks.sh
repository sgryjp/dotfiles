#!/bin/sh
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

makelink() {
    if test "$(readlink -f $2)" != "$1"; then
        ln -fsv "$1" "$2"
        return 0
    fi
    return 1
}

# Files to be replaced
mkdir -vp ~/.config/git
for F in gitconfig gitignore; do
    makelink $SCRIPT_PATH/$F ~/.config/git/$F
done
makelink $SCRIPT_PATH/inputrc ~/.inputrc

# Files to be additionally sourced
mkdir -vp ~/.local/etc
for F in bashrc profile; do
    makelink $SCRIPT_PATH/$F ~/.local/etc/$F
    if test $? = 0; then
        if test $(grep "~/.local/etc/$F" ~/.$F | wc -l) = 0; then
            printf 'if test -e "~/.local/etc/%s"; then ' "$F" >> ~/.$F
            printf 'source "~/.local/etc/%s"; fi\n' "$F" >> ~/.$F
        fi
    fi
done

# VIM
mkdir -vp ~/.vim/autoload
makelink $SCRIPT_PATH/vimfiles/vimrc             ~/.vim/vimrc
makelink $SCRIPT_PATH/vimfiles/autoload/plug.vim ~/.vim/autoload/plug.vim

# Neovim
mkdir -vp ~/.config/nvim/
makelink $SCRIPT_PATH/init.vim ~/.config/nvim/init.vim

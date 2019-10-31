#!/bin/sh
SCRIPT_PATH=$(cd $(dirname $0) && pwd -P)

makelink() {
    # Make a link unless the target is a symlink to the source
    if test "$(readlink -f $2)" != "$1"; then
        ln -fsv "$1" "$2"
        return 0
    fi
    return 1
}

insert_source_line() {
    # Create the target file
    if test ! -e $2; then
        mkdir -p $(dirname $2)
        touch $2
    fi

    # Insert a line to "source" the target file
    if test $(grep $1 $2 | wc -l 2>/dev/null) = 0; then
        echo "if test -e $1; then source $1; fi\n" >> $2
    fi
}

# Files to be replaced
mkdir -vp ~/.config/git
for F in git/config git/ignore; do
    makelink $SCRIPT_PATH/$F ~/.config/$F
done
makelink $SCRIPT_PATH/inputrc ~/.inputrc

# Files to be additionally sourced
mkdir -vp ~/.local/etc
for F in bashrc profile; do
    makelink $SCRIPT_PATH/$F ~/.local/etc/$F
    if test $(grep "~/.local/etc/$F" ~/.$F | wc -l) = 0; then
        printf 'if test -e "~/.local/etc/%s"; then ' "$F" >> ~/.$F
        printf 'source "~/.local/etc/%s"; fi\n' "$F" >> ~/.$F
    fi
done
insert_source_line $SCRIPT_PATH/zshrc   ~/.zshrc
insert_source_line $SCRIPT_PATH/profile ~/.zprofile

# VIM
mkdir -vp ~/.vim/autoload
makelink $SCRIPT_PATH/vimfiles/vimrc             ~/.vim/vimrc
makelink $SCRIPT_PATH/vimfiles/autoload/plug.vim ~/.vim/autoload/plug.vim

# Neovim
mkdir -vp ~/.config/nvim/
makelink $SCRIPT_PATH/init.vim ~/.config/nvim/init.vim

#!/bin/sh

function makelinks() {
    scriptdir=$(dirname $0)
    srcdir=$(cd $scriptdir/$1; pwd)
    destdir=$HOME/$1

    for fname in $(find $srcdir -type f -name "$2"); do
        fname=$(basename $fname)
	if [ -h $destdir/$fname ]; then
            continue 
        fi
        mkdir -p $destdir
        ln -s $srcdir/$fname $destdir/$fname
    done
}

#------------------------------------------------------------------------------
makelinks '.'             '.*'
makelinks '.vim/ftplugin' '*.vim'

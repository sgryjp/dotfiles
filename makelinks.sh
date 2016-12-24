#!/usr/bin/env bash

function makelinks() {
    scriptdir=`dirname $0`
    srcdir=`cd $scriptdir/$1; pwd`
    destdir=$HOME/$1

    fnames=`find "$srcdir" -type f -name "$2" | grep -v ".DS_Store"`
    for fname in $fnames; do
        fname=`basename $fname`
	if [ -h $destdir/$fname ]; then
            continue 
        fi
        mkdir -p $destdir
        destdir=`cd $destdir; pwd`      # for cleaner message
        echo $destdir/$fname
        ln -s $srcdir/$fname $destdir/$fname
    done
}

#------------------------------------------------------------------------------
makelinks '.'             '.*'
makelinks '.vim/ftplugin' '*.vim'

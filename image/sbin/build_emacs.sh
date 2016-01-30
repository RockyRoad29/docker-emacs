#!/bin/sh -ex
#         terminate immediately on any error.
EMACS_VERSION=${1-24.5}
cd /usr/local/src

if [ ! -d emacs-$EMACS_VERSION  ]; then
    archive=/var/local/dnlds/emacs-$EMACS_VERSION.tar.xz
    echo Extracting $archive in `pwd`
    [ -f "$archive" ] && tar xJf $archive 
fi
cd emacs-$EMACS_VERSION
echo Building `pwd`
./configure 
echo Installing emacs-$EMACS_VERSION
make -j 8 install
echo Cleaning up emacs-$EMACS_VERSION
make clean

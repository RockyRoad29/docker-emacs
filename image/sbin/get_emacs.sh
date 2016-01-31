#!/bin/sh -ex
#         terminate immediately on any error.
EMACS_VERSION=${1-24.5}

GNU_MIRROR=http://ftpmirror.gnu.org
archive=emacs-$EMACS_VERSION.tar.xz
cd /var/local/dnlds

# get the keyring: check the address at ftp://ftp.gnu.org/README
curl -L -O ftp://ftp.gnu.org/gnu/gnu-keyring.gpg 

# get the source code if no local copy available
if [ ! -f $archive ]; then
    curl -L -O $GNU_MIRROR/emacs/$archive 
else
    echo Using provided $archive
fi
# Get the signature
curl -L -O $GNU_MIRROR/emacs/$archive.sig

# verify it
gpg --verify --keyring ./gnu-keyring.gpg $archive.sig 

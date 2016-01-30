
<script type="text/javascript" src="http://livejs.com/live.js"></script>

# An emacs testbed

##  Dockerfile Contents

### This image is based on :
* [phusion/passenger-full][passenger-docker]:0.9.18 (release date: 2015-12-08)

Apart from providing the image enhancements, it also includes many commonly
used developpers packages.

### emacs
Downloaded, verified and compiled at build time.
See below for customization.

### emacs user
A user with `uid=1000` is created and used.

If you need to tweak the container, you may enable the root account
(see below).

## Example: test spacemacs
the latest version
of spacemacs is cloned from github into her home directory.

	USER1=user1
	mkdir -p spacemacs/$USER1 && cd $_
	git clone --depth 1 https://github.com/syl20bnr/spacemacs .emacs.d
	cd .emacs.d
	git checkout -b $USER1
	cd ../..
	
	docker run -it --name spacemacs \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v `pwd`:/home \
    rockyroad/emacs

## Building the image
First `cd` to the directory where the `Dockerfile` is.
It should also include a `bin/` and a `src/` subdirectories.

From there you can just run:

	docker build -t your_name/emacs .

but see below for available settings.

### Caching downloads
When you test a new build, you may want to save time by reusing
previous downloads. 

Put them in the `dnlds` subdirectory.

	mkdir -p dnlds && cd $_
	$EMACS_VERSION=24.4
	curl -L -O http://ftpmirror.gnu.org/emacs/emacs-$EMACS_VERSION.tar.xz

If a needed file is not found there, it will be downloaded
at build time in the image.

The security related files (signatures and keyring) will always be
downloaded.

### Build arguments
#### emacs version and mirrors: 
The current stable release is 24.5 (released 2015-04-10).

You can select a nearby mirror for downloading emacs source code
(38M).
Choose from [GNU Mirror List](http://www.gnu.org/prep/ftp)

example:
	
	docker build \
		--build-arg EMACS_VERSION=24.4 \
		--build-arg GNU_MIRROR=ftp.gnu.org \
		...

#### user name
The container is normally ran in unprivileged user mode.
You can customize her name 

example:
	
	docker build \
		--build-arg USER1=my_beloved_own_name \
		...

#### root account
For cleanliness,
by default the root account won't be activated (no password).

To activate it, you need to provide a password, e.g.

	docker build \
		--build-arg pass='root:Docker!' \
		...

	If you don't you can still run another container with
`--user root` .

## Troubleshooting
### exec: "emacs": executable file not found in $PATH
Override entrypoint with e.g.:


	docker run -it  \
    -v `pwd`:/home \
	--entrypoint /bin/bash \
	--user root \
    rockyroad/emacs

## Relevant links
  * base docker image: [phusion/passenger-full][passenger-docker]
  * [emacs][emacs]
  * [spacemacs home and source][gh-spacemacs]
  
[passenger-docker]: (https://github.com/phusion/passenger-docker) "phusion/passenger-docker"
[gh-spacemacs]: https://github.com/syl20bnr/spacemacs "A community-driven Emacs distribution"
[emacs]: https://www.gnu.org/software/emacs/ "emacs home"
[spacemacs-doc]: https://github.com/syl20bnr/spacemacs/blob/master/doc/DOCUMENTATION.org "official ocumentation"

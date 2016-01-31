
<!-- For convenience while editing this file. Remove when publishing: -->
<script type="text/javascript" src="http://livejs.com/live.js"></script>
# An emacs testbed

##  Dockerfile Contents

### This image is based on :
* [python][python-docker]:3

More programming environments may be derived as variants, but the
official python can be considered as popular enough to be the base
image.

### emacs
Downloaded, verified and compiled at build time.
See below for customization.

### emacs user
A user with `uid=1000` is created and used.

If you need to tweak the container, you may enable the root account
(see below).

## User enviroment
You can grab it from a container

	docker run -it  --entrypoint /bin/bash rockyroad/emacs

From there check the contents of user1's home and exit.

	docker cp `docker ps -lq`:/home/user1 .

Clean the dummy container:

	docker rm `docker ps -lq`

... or simply extract the provided `user-profile.tar.xz`

## Example: test spacemacs
the latest version
of spacemacs is cloned from github into her home directory.

	USER1=user1
	mkdir spacemacs && cd $_
	tar xJvf ../user-profile.tar.xz
	# if needed: mv user1 $USER1
	cd $USER1
	git clone --depth 1 https://github.com/syl20bnr/spacemacs .emacs.d
	cd .emacs.d
	git checkout -b $USER1
	cd ..
	# pwd = spacemacs/$USER1
	docker run -it --name spacemacs1 \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v `pwd`:/home/$USER1 \
    rockyroad/emacs

You don't have to keep the container because all your data
is in your mounted home directory.
Just keep of the emacs version used with it.

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
`--user root`, but you can't do that on an existing
container.

It is of course recommended that you change root password
as soon as possible if your container is going to persist.

## Troubleshooting
### exec: "emacs": executable file not found in $PATH
Override `CMD` with e.g.:


	docker run -it  \
    -v `pwd`/user1:/home/user \
	--user root \
    rockyroad/emacs /bin/bash 

### Issues
### Image size
The purpose of this image is more to provide full
functionality in emacs than to be slim ...

It is also a demonstration of how to build a program from source ...
This version might be just kept for reference then.

#### Build dependencies for emacs24
The following NEW packages will be installed:


>   adwaita-icon-theme bsd-mailx bsdmainutils cron dbus-x11
>   dconf-gsettings-backend dconf-service debhelper diffstat exim4-base
>   exim4-config exim4-daemon-light gconf-service gconf2 gconf2-common
>   gettext gettext-base gir1.2-atk-1.0 gir1.2-atspi-2.0
>   gir1.2-gconf-2.0 gir1.2-gtk-3.0 gir1.2-pango-1.0 glib-networking
>   glib-networking-common glib-networking-services groff-base
>   gsettings-desktop-schemas init-system-helpers intltool-debian
>   libacl1-dev libasound2 libasound2-data libasound2-dev libasprintf0c2
>   libatk-bridge2.0-0 libatk-bridge2.0-dev libatk1.0-0 libatk1.0-data
>   libatk1.0-dev libatspi2.0-0 libatspi2.0-dev libattr1-dev
>   libcairo2-dev libcolord2 libdatrie-dev libdbus-1-dev
>   libdbus-glib-1-2 libdbus-glib-1-dev libdconf1 libfribidi0
>   libgconf-2-4 libgconf2-dev libgdk-pixbuf2.0-dev libgif-dev libgif4
>   libglib2.0-dev libgmp-dev libgmpxx4ldbl libgnutls-openssl27
>   libgnutls28-dev libgnutlsxx28 libgpm-dev libgpm2 libgtk-3-0
>   libgtk-3-bin libgtk-3-common libgtk-3-dev libharfbuzz-dev
>   libharfbuzz-gobject0 libharfbuzz-icu0 libintl-perl
>   libjson-glib-1.0-0 libjson-glib-1.0-common liblockfile-bin
>   liblockfile-dev liblockfile1 libm17n-0 libm17n-dev
>   libmagick++-6-headers libmagick++-6.q16-5 libmagick++-6.q16-dev
>   libmagick++-dev libmagickcore-6.q16-dev libmagickwand-6.q16-dev
>   libotf-dev libotf0 libp11-kit-dev libpango1.0-dev libpangoxft-1.0-0
>   libpipeline1 libproxy1 libpython-stdlib libpython2.7-minimal
>   libpython2.7-stdlib librest-0.7-0 librsvg2-dev libselinux1-dev
>   libsepol1-dev libsoup-gnome2.4-1 libsoup2.4-1 libtasn1-6-dev
>   libtext-unidecode-perl libthai-dev libunistring0 libwayland-client0
>   libwayland-cursor0 libwayland-dev libwayland-server0 libxaw7
>   libxaw7-dev libxcomposite-dev libxcomposite1 libxcursor-dev
>   libxcursor1 libxdamage-dev libxdamage1 libxfixes-dev libxfixes3
>   libxft-dev libxft2 libxi-dev libxi6 libxinerama-dev libxinerama1
>   libxkbcommon-dev libxkbcommon0 libxml-libxml-perl
>   libxml-namespacesupport-perl libxml-sax-base-perl libxml-sax-perl
>   libxmu-dev libxmu-headers libxmu6 libxpm-dev libxrandr-dev
>   libxrandr2 libxtst-dev libxtst6 m17n-db man-db nettle-dev po-debconf
>   psmisc python python-minimal python2.7 python2.7-minimal quilt
>   sharutils texinfo x11proto-composite-dev x11proto-damage-dev
>   x11proto-fixes-dev x11proto-randr-dev x11proto-record-dev
>   x11proto-xinerama-dev xaw3dg xaw3dg-dev xkb-data xutils-dev
>
>  - 0 upgraded, 171 newly installed, 0 to remove and 7 not upgraded.
>  - Need to get 58.5 MB of archives.
>  - After this operation, 205 MB of additional disk space will be used.


#### X11 dependencies
If you're looking for a light version of emacs, emacs-nw

<!-- Link references -->
[gh-spacemacs]: https://github.com/syl20bnr/spacemacs "A community-driven Emacs distribution"
[emacs]: https://www.gnu.org/software/emacs/ "emacs home"
[spacemacs-doc]: https://github.com/syl20bnr/spacemacs/blob/master/doc/DOCUMENTATION.org "official ocumentation"

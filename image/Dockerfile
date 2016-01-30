# image: rockyroad/emacs

# make sure you lock down to a specific version, not to `latest`!
FROM phusion/passenger-full:0.9.18
MAINTAINER RockyRoad
LABEL version="0.1"
ARG EMACS_VERSION="24.5"
ARG USER1=user1

# Set correct environment variables.
#ENV HOME /root

# https://github.com/phusion/baseimage-docker/issues/58
ENV DEBIAN_FRONTEND noninteractive

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]
# Install dependencies
RUN apt-get update && \
    apt-get install -y curl build-essential && \
    apt-get build-dep -y emacs24

ADD sbin/ /usr/local/sbin/

# Activate root account if password provided
ARG pass

RUN /usr/local/sbin/setpass.sh $pass

# save bandwidth by using local copies if possible
ADD dnlds/ /var/local/dnlds/

# Install emacs
WORKDIR /usr/local/src
RUN /usr/local/sbin/get_emacs.sh  $EMACS_VERSION \
    && /usr/local/sbin/build_emacs.sh $EMACS_VERSION

RUN useradd -ms /bin/bash -Uu 1000 $USER1
ENV HOME /home/$USER1


# port usable for emacs server
EXPOSE 10024
VOLUME /home/$USER1

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# User mode
USER $USER1
WORKDIR /home/$USER1

entrypoint ["emacs"]

# image: rockyroad/emacs
FROM python:3
MAINTAINER RockyRoad
LABEL version="0.21"
LABEL variant="python3"

ARG EMACS_VERSION="24.5"
ARG USER1=user1

#ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
#RUN sed -i 's/main$/main contrib/' /etc/apt/sources.list
RUN sed -e 's/deb/deb-src/' /etc/apt/sources.list >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get build-dep -y emacs24

ADD sbin/ /usr/local/sbin/

# save bandwidth by using local copies if possible
ADD dnlds/ /var/local/dnlds/

# Install emacs
WORKDIR /usr/local/src
RUN /usr/local/sbin/get_emacs.sh  $EMACS_VERSION \
    && /usr/local/sbin/build_emacs.sh $EMACS_VERSION

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# port usable for emacs server
EXPOSE 10024
VOLUME /home/$USER1

# Activate root account if password provided
ARG pass
RUN /usr/local/sbin/setpass.sh $pass

# Add full user account
RUN useradd -ms /bin/bash -Uu 1000 $USER1
#ENV HOME /home/$USER1

# User mode
USER $USER1
#WORKDIR /home/$USER1

CMD ["emacs"]

home=home
docker run -it --name spacemacs \
         -e DISPLAY=$DISPLAY \
         -v /tmp/.X11-unix:/tmp/.X11-unix \
         -v `readlink -f $home`:/home \
         rockyroad/spacemacs

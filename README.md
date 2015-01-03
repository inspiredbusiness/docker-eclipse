Running Eclipse Luna inside a Docker container with PyDev
---------------------------------------------

## Preliminary note
This image is heavily based on http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/. 
Kudos to @fgrehm.

## TL;DR: how to use it

### Run it

    $ sudo docker run -it -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix inspiredbusiness/docker-eclipse

### Build the image if you don't trust the pullable one

    $ sudo docker build -t inspiredbusiness/docker-eclipse

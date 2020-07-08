# Kerbal CKAN Docker Image

![Docker Build Status](https://img.shields.io/docker/build/michionlion/kerbal-ckan)

This is a Debian-based Docker image for the [Comprehensive Kerbal Archive Network](https://github.com/KSP-CKAN/CKAN). It is built on top of the `mono:6.8` docker image.

To run, mount the KSP directory into the `/kerbal` directory and enable interactive terminal mode, such as:

```bash
docker run --rm -it \
--mount type=bind,source="/home/$USER/games/ksp",target=/kerbal \
michionlion/kerbal-ckan
```

When the container starts, it will add the Kerbal directory to its registry, show an instructional MOTD, and leave you in a bash shell. You can then execute commands with `ckan <COMMAND>`. If you wish to use the GUI, you'll need to expose an X-Server to the container. I recommend [x11docker](https://github.com/mviereck/x11docker), but any method that exposes a display server should work.

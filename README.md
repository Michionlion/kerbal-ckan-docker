# Kerbal CKAN Docker Image

![GitHub Docker Build Status](https://github.com/Michionlion/kerbal-ckan-docker/workflows/Docker/badge.svg)
[![Docker Hub Build Status](https://img.shields.io/docker/cloud/build/michionlion/kerbal-ckan?label=Docker%20Hub&style=flat)](https://hub.docker.com/r/michionlion/kerbal-ckan)

This is a Debian-based Docker image for the
[Comprehensive Kerbal Archive Network](https://github.com/KSP-CKAN/CKAN). It is
built on top of the `mono:6.8` docker image.

To run, mount the KSP directory into any reasonable directory (e.g. `/kerbal`)
and enable interactive terminal mode, such as:

```bash
docker run --rm -it \
--mount type=bind,source="/home/$USER/games/ksp",target=/kerbal \
michionlion/kerbal-ckan:latest
```

When the container starts, it will add search for `buildID.txt` and add its
containing folder to its registry, show an instructional MOTD, and leave you in
a bash shell. You can then execute commands with `ckan <COMMAND>`. If you wish
to use the GUI, you'll need to expose an X-Server to the container and pass
`ckan gui` to the docker container to execute. I recommend using
[x11docker](https://github.com/mviereck/x11docker), but any method that exposes
a display server should work. Using x11docker, the following command will do
the same as the one above, but open the GUI instead of CLI. Keep in mind that
certain features in the GUI (like starting KSP) may not work as expected, since
`ckan` is running in an isolated container.

```bash
x11docker --share /home/$USER/games/ksp -- \
--rm -- michionlion/kerbal-ckan:latest \
ckan gui
```

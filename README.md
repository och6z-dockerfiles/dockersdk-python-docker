# Docker
```bash
docker build \
    --no-cache \
    --build-arg IMAGE=python \
    --build-arg IMAGE_VERSION=slim \
    --build-arg ACCOUNT=docker \
    --build-arg USERMAIL=usermail@usermail \
    --build-arg USER=user@user \
    --file Dockerfile \
    --tag image-name:latest .
```
```bash
xhost +local:docker
```
```bash
docker run \
    --interactive \
    --tty \
    --privileged \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --env DISPLAY=unix$DISPLAY \
    --name container-name och6z/dockersdk
```

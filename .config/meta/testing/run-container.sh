#!/bin/sh

# prerequisite: brew install podman

# create image from Containerfile
podman build --tag kjhaber-config-test-debian .

# create container from image
# podman rm conf-test
podman create --replace --tty --interactive --name conf-test kjhaber-config-test-debian

# start interactive session in container
podman start --interactive --attach conf-test


#!/usr/bin/env bash
set -vxe

NAME='test-aur-package-deploy'
VERSION='latest'
DOCKER_PROGRESS='plain' # Options: plain or tty
TAG="${NAME}:${VERSION}"

# Build the dockerfile and create an image.
docker build --tag "${TAG}" --progress "${DOCKER_PROGRESS}" .

# Build the dockerfile and create an image. Ignore the cache and build all everytime.
#docker build --tag "${TAG}" --progress "${DOCKER_PROGRESS}" --no-cache=true .

# Run the image and create a container.
# Add this option to replace the entrypoint with a bash terminal.
#  --entrypoint /bin/bash \
docker run --tty --interactive --rm \
  --env ENV_PACKAGE_NAME='brightness-xrandr' \
  --env ENV_GITHUB_OWNER='airvzxf' \
  --env ENV_GITHUB_REPOSITORY='archlinux-brightness-xrandr' \
  --env ENV_GITHUB_TAG_VERSION='v1.0.0' \
  --env ENV_SSH_PUBLIC_KEY='foo' \
  --env ENV_SSH_PRIVATE_KEY='bar' \
  --name "${NAME}-$(date +%Y%m%d-%H%M%S-%N)" \
  "${TAG}"

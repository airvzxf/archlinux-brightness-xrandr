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
  --env ENV_GITHUB_OWNER='airvzxf' \
  --env ENV_GITHUB_REPOSITORY='archlinux-brightness-xrandr' \
  --env ENV_GITHUB_TAG_VERSION_PREFIX='v' \
  --env ENV_GITHUB_TAG_VERSION_SUFFIX='' \
  --env ENV_GIT_USER_EMAIL='israel.alberto.rv@gmail.com' \
  --env ENV_GIT_USER_NAME='Israel Roldan' \
  --env ENV_PACKAGE_ARCHITECTURES='x86_64' \
  --env ENV_PACKAGE_DEPENDENCIES='bash xorg-xrandr grep coreutils sed bc' \
  --env ENV_PACKAGE_DESCRIPTION='Changes the brightness using the command xrandr. Furthermore, adding multiple options.' \
  --env ENV_PACKAGE_INFORMATION='# Maintainer: Israel Roldan <israel.alberto.rv@gmail.com>' \
  --env ENV_PACKAGE_LICENSES='GPL3' \
  --env ENV_PACKAGE_NAME='brightness-xrandr' \
  --env ENV_PACKAGE_PGPS='63ADA633FE7468630D9BC56175530B8B9F74CF3A' \
  --env ENV_PACKAGE_RELEASE='1' \
  --env ENV_PACKAGE_SOURCES='' \
  --env ENV_PACKAGE_SOURCE_GITHUB='true' \
  --env ENV_PACKAGE_VERSION='1.0.0' \
  --env ENV_SSH_PRIVATE_KEY='bar' \
  --env ENV_SSH_PUBLIC_KEY='foo' \
  --name "${NAME}-$(date +%Y%m%d-%H%M%S-%N)" \
  "${TAG}"

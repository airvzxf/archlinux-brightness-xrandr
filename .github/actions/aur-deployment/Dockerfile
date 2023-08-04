FROM archlinux:latest

# Upgrade the operative system and isntall basic packages.
RUN pacman -Sy --noconfirm
RUN pacman -S pacman --noconfirm
RUN pacman-db-upgrade
RUN pacman -S --needed --noconfirm base-devel openssh git

# Install dependencies of the AUR package.
RUN pacman -S --needed --noconfirm bash xorg-xrandr grep coreutils sed bc

# Custom variables.
ENV ENV_USER_ID=wolf
ENV ENV_USER_GROUP=animals
ENV ENV_USER_PASSWORD=auuu
ENV ENV_BUILD_PACKAGE=01-build-package
ENV ENV_PACKAGE_NAME=brightness-xrandr

# Custom variables: auto generated.
ENV ENV_USER_HOME=/home/${ENV_USER_ID}

# Create local user in the operative system.
RUN groupadd ${ENV_USER_GROUP}
RUN useradd --create-home --gid ${ENV_USER_GROUP} ${ENV_USER_ID}
USER ${ENV_USER_ID}:${ENV_USER_GROUP}

# Set the work direcotry.
WORKDIR ${ENV_USER_HOME}

# Copy the deployment script.
COPY --chown=${ENV_USER_ID}:${ENV_USER_GROUP} --chmod=755 deployment.bash ${ENV_USER_HOME}/deployment.bash

# Copy the configuration file for the build of the AUR package.
#COPY --chown=${ENV_USER_ID}:${ENV_USER_GROUP} PKGBUILD ${ENV_USER_HOME}/${ENV_BUILD_PACKAGE}/PKGBUILD

# After build the image, this entrypoint command will execute when the container runs.
#ENTRYPOINT ["bash"]
ENTRYPOINT "${ENV_USER_HOME}/deployment.bash"

FROM archlinux:latest

# Upgrade the operative system and isntall basic packages.
#RUN pacman -Sy --noconfirm
RUN pacman -Syyu --noconfirm
RUN pacman -Syu pacman --noconfirm
RUN pacman-db-upgrade
RUN pacman -Syu --needed --noconfirm base-devel openssh git namcap

# Install dependencies of the AUR package.
RUN pacman -Syu --needed --noconfirm bash xorg-xrandr grep coreutils sed bc

# Add as a safe the GitHub directory.
RUN git config --global --add safe.directory /github/workspace

# Custom variables.
ENV ENV_USER_ID=wolf
ENV ENV_USER_GROUP=animals

# Custom variables: auto-generated.
ENV ENV_USER_HOME=/home/${ENV_USER_ID}

# Create user in the operative system.
RUN groupadd ${ENV_USER_GROUP}
RUN useradd --create-home --gid ${ENV_USER_GROUP} ${ENV_USER_ID}
RUN passwd --delete ${ENV_USER_ID}
RUN echo "${ENV_USER_ID} ALL=(ALL:ALL) ALL" | tee -a /etc/sudoers
USER ${ENV_USER_ID}:${ENV_USER_GROUP}

# Set the work direcotry.
WORKDIR ${ENV_USER_HOME}

# Copy the deployment script.
COPY --chown=${ENV_USER_ID}:${ENV_USER_GROUP} --chmod=755 deployment.bash ${ENV_USER_HOME}/deployment.bash

# TODO: Remove or comment the below lines. The PKGBUILD file should be take from GitHub URL.
# Copy the configuration file for the build of the AUR package.
ENV ENV_BUILD_PACKAGE=01-build-package
COPY --chown=${ENV_USER_ID}:${ENV_USER_GROUP} PKGBUILD ${ENV_USER_HOME}/${ENV_BUILD_PACKAGE}/PKGBUILD

# After build the image, this entrypoint command will execute when the container runs.
#ENTRYPOINT ["bash"]
ENTRYPOINT "${ENV_USER_HOME}/deployment.bash"

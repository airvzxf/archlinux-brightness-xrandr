FROM archlinux:latest

WORKDIR /app

COPY deployment.sh /app/deployment.sh

RUN ["/bin/chmod", "+x", "/app/deployment.sh"]

RUN pacman -Sy --noconfirm
RUN pacman -S pacman --noconfirm
RUN pacman-db-upgrade
RUN pacman -S --needed --noconfirm base-devel openssh git
# Install dependencies of the package
RUN pacman -S --needed --noconfirm bash xorg-xrandr grep coreutils sed bc

ENTRYPOINT ["/app/deployment.sh"]

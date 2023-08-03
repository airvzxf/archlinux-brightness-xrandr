FROM archlinux:latest

WORKDIR /app

COPY deployment.sh /app/deployment.sh

RUN ["/bin/chmod", "+x", "/app/deployment.sh"]

RUN pacman -Sy --noconfirm
RUN pacman -S pacman --noconfirm
RUN pacman-db-upgrade
RUN pacman -S --noconfirm base-devel openssh git

ENTRYPOINT ["/app/deployment.sh"]

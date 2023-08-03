FROM archlinux:latest

WORKDIR /app

COPY deployment.sh /app/deployment.sh

RUN ["/bin/chmod", "+x", "/app/deployment.sh"]

RUN pacman -Sy --noconfirm &&\
    pacman -S pacman --noconfirm &&\
    pacman-db-upgrade &&\
    pacman -S --noconfirm base-devel openssh git

ENTRYPOINT ["/app/deployment.sh"]

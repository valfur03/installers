FROM archlinux

RUN set -eux; \
	pacman -Syu --noconfirm ca-certificates sudo curl git \
												vim zsh

WORKDIR /usr/src
COPY install.sh .

CMD [ "./install.sh", "-f" ]

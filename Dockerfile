FROM debian
#FROM archlinux

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates sudo curl git \
												vim zsh
#RUN set -eux; \
#	pacman -Syu --noconfirm ca-certificates sudo curl git \
#												vim zsh

WORKDIR /usr/src
COPY install.sh .

CMD [ "./install.sh", "-f" ]

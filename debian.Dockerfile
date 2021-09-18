FROM debian

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates sudo curl git \
												vim zsh

WORKDIR /usr/src
COPY install.sh .

CMD [ "./install.sh", "-f" ]

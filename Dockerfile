FROM ubuntu

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends sudo

WORKDIR /usr/src
COPY debian-installer-v1.sh .

CMD [ "./debian-installer-v1.sh" ]

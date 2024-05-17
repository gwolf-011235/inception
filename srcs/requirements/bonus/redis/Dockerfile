FROM debian:bookworm

ARG CURRENT_UID=1000
ARG CURRENT_GID=1000

RUN groupadd -r -g $CURRENT_GID redis && useradd -r -g redis -u $CURRENT_UID redis

RUN apt-get update; \
	apt-get install -y \
		redis=5:7.0.15-1~deb12u1;

COPY ./tools/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["redis-server", "--protected-mode", "no"]


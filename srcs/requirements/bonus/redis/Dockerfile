FROM debian:bookworm

ARG USER_NAME=redis
ARG USER_UID=1000
ARG USER_GID=1000
ARG REDIS_VERSION=5:7.0.15-1~deb12u1

RUN groupadd -r -g ${USER_GID} ${USER_NAME} && useradd -r -g ${USER_NAME} -u ${USER_UID} ${USER_NAME}

RUN apt-get update; \
	apt-get install -y \
		redis=${REDIS_VERSION};

COPY --chmod=755 ./tools/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["redis-server", "--protected-mode", "no"]

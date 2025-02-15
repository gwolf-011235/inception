FROM debian:bullseye

ARG USER_NAME=redis
ARG USER_UID=1000
ARG USER_GID=1000
ARG REDIS_VERSION=5:6.0.16-1+deb11u5

RUN set -eux \
	&& groupadd --system --gid ${USER_GID} ${USER_NAME} \
	&& useradd --system --gid ${USER_GID} --uid ${USER_UID} ${USER_NAME} \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y \
		redis=${REDIS_VERSION} \
	&& rm -rf /var/lib/apt/lists/*

RUN chown -R ${USER_NAME}:${USER_NAME} /var/lib/redis

COPY --chmod=755 ./tools/docker-entrypoint.sh /usr/local/bin/

USER ${USER_NAME}

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["redis-server", "/config/redis.conf"]

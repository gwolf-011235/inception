FROM debian:bookworm

ARG USER_NAME=mysql
ARG USER_UID=1000
ARG USER_GID=1000
ARG MARIADB_VERSION=1:10.11.6-0+deb12u1

RUN set -eux \
	&& groupadd --system --gid ${USER_GID} ${USER_NAME} \
	&& useradd --system --gid ${USER_GID} --uid ${USER_UID} ${USER_NAME} \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y \
		mariadb-server=${MARIADB_VERSION} \
	&& rm -rf \
		/var/lib/apt/lists/* \
		/var/lib/mysql/

RUN mkdir -p \
		/var/lib/mysql/ \
		/run/mysqld/ \
	&& chown -R ${USER_NAME}:${USER_NAME} \
		/var/lib/mysql \
		/run/mysqld

COPY --chmod=755 tools/docker-entrypoint.sh /usr/local/bin/
COPY --chmod=755 tools/healthcheck.sh /usr/local/bin/

WORKDIR /var/lib/mysql/

USER ${USER_NAME}

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mariadbd"]

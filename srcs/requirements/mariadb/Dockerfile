FROM debian:bookworm

ARG USER_UID=1000
ARG USER_GID=1000
ARG MARIADB_VERSION=1:10.11.6-0+deb12u1

RUN groupadd -r -g ${USER_GID} mysql && useradd -r -g mysql -u ${USER_UID} mysql

RUN apt-get update && \
	apt-get install -y \
		mariadb-server=${MARIADB_VERSION};

RUN rm -rf /var/lib/mysql/ && \
	mkdir -p \
		/var/lib/mysql/ \
		/run/mysqld/ && \
	chown -R mysql:mysql \
		/var/lib/mysql \
		/run/mysqld;

COPY --chmod=0755 tools/docker-entrypoint.sh /usr/local/bin/
COPY --chmod=0755 tools/healthcheck.sh /usr/local/bin/

WORKDIR /var/lib/mysql/

USER mysql

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mariadbd"]

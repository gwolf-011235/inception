FROM debian:bookworm

ARG MARIADB_VERSION=1:10.11.6-0+deb12u1
ENV MARIADB_VERSION=${MARIADB_VERSION}

RUN apt-get update; \
	apt-get install -y mariadb-server=${MARIADB_VERSION}; \
	mkdir -p /run/mysqld/

COPY tools/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mariadbd"]


FROM debian:bookworm

ARG MARIADB_VERSION="set_in_docker_compose"

RUN apt-get update; \
	apt-get install -y mariadb-server=${MARIADB_VERSION}; \
	mkdir -p /run/mysqld/

COPY tools/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mariadbd"]


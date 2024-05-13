FROM debian:bookworm

ARG MARIADB_VERSION="set_in_docker_compose"
ARG CURRENT_UID=1000
ARG CURRENT_GID=1000

RUN groupadd -r -g $CURRENT_GID mysql && useradd -r -g mysql -u $CURRENT_UID --home /var/lib/mysql/ mysql

RUN apt-get update; \
	apt-get install -y mariadb-server=${MARIADB_VERSION};

RUN mkdir -p /run/mysqld; \
	chown -R mysql:mysql /var/lib/mysql /run/mysqld; \
	chmod 1777 /run/mysqld;

COPY tools/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mariadbd"]


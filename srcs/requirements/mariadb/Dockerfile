FROM debian:bookworm

ARG MARIADB_VERSION="set_in_docker_compose"
ARG CURRENT_UID=1000
ARG CURRENT_GID=1000

RUN groupadd -r -g $CURRENT_GID mysql && useradd -r -g mysql -u $CURRENT_UID --home /var/lib/mysql/ mysql

RUN apt-get update; \
	apt-get install -y mariadb-server=${MARIADB_VERSION};

RUN mkdir -p /run/mysqld; \
	# remove the default mysql directory
	rm -rf /var/lib/mysql/; \
	mkdir -p /var/lib/mysql/; \
	chown -R mysql:mysql /var/lib/mysql /run/mysqld; \
	chmod 755 /run/mysqld;

COPY --chmod=0755 tools/docker-entrypoint.sh /usr/local/bin/

WORKDIR /var/lib/mysql/

USER mysql

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mariadbd"]


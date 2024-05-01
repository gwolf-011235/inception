FROM debian:bookworm

RUN set -eux; \
	apt-get update; \
	apt-get install -y \
		php-fpm \
		php-mysqli \
		curl

COPY ./tools/docker_entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker_entrypoint.sh"]

CMD ["php-fpm8.2", "-F", "-R"]


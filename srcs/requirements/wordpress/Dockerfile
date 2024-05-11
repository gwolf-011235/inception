FROM debian:bookworm

RUN set -eux; \
	apt-get update; \
	apt-get install -y \
		php-fpm \
		php-mysqli \
		curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
	chmod +x wp-cli.phar; \
	mv wp-cli.phar /usr/local/bin/wp;

COPY ./tools/docker_entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker_entrypoint.sh"]

CMD ["php-fpm8.2", "-F", "-R"]


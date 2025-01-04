FROM debian:bookworm

ARG CURRENT_UID=1000
ARG CURRENT_GID=1000

RUN groupadd -r -g $CURRENT_GID wpuser && useradd -r -g wpuser -u $CURRENT_UID --home /var/www/html/ wpuser

RUN set -eux; \
	apt-get update; \
	apt-get install -y \
		php-fpm \
		php-mysqli \
		curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
	chmod +x wp-cli.phar; \
	mv wp-cli.phar /usr/local/bin/wp;

RUN mkdir -p /var/www/html; \
	chown -R wpuser:wpuser /var/www/html /var/log; \
	chmod 1777 /var/www/html /run/php/;

COPY --chmod=0755 ./tools/docker-entrypoint.sh /usr/local/bin/

WORKDIR /var/www/html/

USER wpuser

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm8.2", "-F"]


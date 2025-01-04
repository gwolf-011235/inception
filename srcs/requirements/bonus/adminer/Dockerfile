FROM debian:bookworm

ARG CURRENT_UID=1000
ARG CURRENT_GID=1000

RUN groupadd -r -g $CURRENT_GID adminer && useradd -r -g adminer -u $CURRENT_UID --home /var/www/html/ adminer

RUN set -eux; \
	apt-get update; \
	apt-get install -y \
		php-fpm \
		php-mysqli \
		curl

RUN mkdir -p /var/www/html; \
	chown -R adminer:adminer /var/www/html /var/log; \
	chmod 1777 /var/www/html /run/php/;

RUN curl -L https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -o /var/www/html/adminer.php;

COPY --chmod=0755 ./tools/docker-entrypoint.sh /usr/local/bin/

WORKDIR /var/www/html

USER adminer

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm8.2", "-F"]


FROM debian:bookworm

ARG USER_UID=1000
ARG USER_GID=1000
ARG PHP_FPM_VERSION=8.2.26-1~deb12u1
ARG PHP_MYSQL_VERSION=8.2.26-1~deb12u1
ARG CURL_VERSION=7.88.1-10+deb12u8
ARG ADMINER_VERSION=4.8.1

RUN groupadd -r -g $USER_GID adminer && useradd -r -g adminer -u $USER_UID --home /var/www/html/ adminer

RUN set -eux; \
	apt-get update; \
	apt-get install -y \
	php8.2-fpm=${PHP_FPM_VERSION} \
	php8.2-mysql=${PHP_MYSQL_VERSION} \
	curl=${CURL_VERSION}

RUN mkdir -p /var/www/html; \
	chown -R adminer:adminer /var/www/html /var/log; \
	chmod 1755 /var/www/html /run/php/;

RUN curl -L https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-{ADMINER_VERSION}.php \
	-o /var/www/html/adminer.php;

COPY --chmod=0755 ./tools/docker-entrypoint.sh /usr/local/bin/

WORKDIR /var/www/html

USER adminer

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm8.2", "-F"]


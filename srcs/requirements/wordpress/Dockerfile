FROM debian:bookworm

ARG USER_UID=1000
ARG USER_GID=1000
ARG PHP_FPM_VERSION=8.2.26-1~deb12u1
ARG PHP_MYSQL_VERSION=8.2.26-1~deb12u1
ARG CURL_VERSION=7.88.1-10+deb12u8
ARG WP_CLI_VERSION=2.11.0

RUN groupadd -r -g $USER_GID wpuser && useradd -r -g wpuser -u $USER_UID --home /var/www/html/ wpuser

RUN set -eux; \
	apt-get update; \
	apt-get install -y \
	php8.2-fpm=${PHP_FPM_VERSION} \
	php8.2-mysql=${PHP_MYSQL_VERSION} \
	curl=${CURL_VERSION}

RUN curl -L https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar \
	-o /usr/local/bin/wp && \
	chmod +x /usr/local/bin/wp;

RUN mkdir -p /var/www/html; \
	chown -R wpuser:wpuser /var/www/html /var/log; \
	chmod 1777 /var/www/html /run/php/;

COPY --chmod=0755 ./tools/docker-entrypoint.sh /usr/local/bin/

WORKDIR /var/www/html/

USER wpuser

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm8.2", "-F"]

FROM debian:bookworm

ARG USER_NAME=wpuser
ARG USER_UID=1000
ARG USER_GID=1000
ARG PHP_FPM_VERSION=8.2.26-1~deb12u1
ARG PHP_MYSQL_VERSION=8.2.26-1~deb12u1
ARG CURL_VERSION=7.88.1-10+deb12u8
ARG WP_CLI_VERSION=2.11.0

RUN set -eux \
	&& groupadd --system --gid ${USER_GID} ${USER_NAME} \
	&& useradd --system --gid ${USER_GID} --uid ${USER_UID} ${USER_NAME} \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y \
		php8.2-fpm=${PHP_FPM_VERSION} \
		php8.2-mysql=${PHP_MYSQL_VERSION} \
		curl=${CURL_VERSION} \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar \
		-o /usr/local/bin/wp \
	&& chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/html/ \
	&& chown -R ${USER_NAME}:${USER_NAME} \
		/var/www/html/ \
		/var/log \
	&& chmod 1777 \
		/var/www/html/ \
		/run/php/

COPY --chmod=0755 ./tools/docker-entrypoint.sh /usr/local/bin/

WORKDIR /var/www/html/

USER ${USER_NAME}

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm8.2", "-F"]

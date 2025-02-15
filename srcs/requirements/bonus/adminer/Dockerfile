FROM debian:bullseye

ARG USER_NAME=www-data
ARG USER_UID=1000
ARG USER_GID=1000
ARG PHP_FPM_VERSION=7.4.33-1+deb11u7
ARG PHP_MYSQL_VERSION=7.4.33-1+deb11u7
ARG CURL_VERSION=7.74.0-1.3+deb11u14
ARG ADMINER_VERSION=4.8.1

RUN set -eux \
	&& groupmod --gid ${USER_GID} ${USER_NAME} \
	&& usermod --uid ${USER_UID} ${USER_NAME} \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y \
		php7.4-fpm=${PHP_FPM_VERSION} \
		php7.4-mysql=${PHP_MYSQL_VERSION} \
		curl=${CURL_VERSION} \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
		/var/www/html/ \
		/run/php/ \
	&& chown -R ${USER_NAME}:${USER_NAME} \
		/var/www/html/ \
		/var/log \
		/run/php/ \
	&& chmod 755 \
		/var/www/html/ \
		/run/php/

RUN curl -L https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}.php \
		-o /var/www/html/adminer.php

COPY --chmod=755 tools/docker-entrypoint.sh /usr/local/bin/

WORKDIR /var/www/html

USER ${USER_NAME}

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm7.4", "-F"]

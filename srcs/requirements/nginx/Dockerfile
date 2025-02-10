FROM debian:bookworm

ARG USER_NAME=www-data
ARG USER_UID=1000
ARG USER_GID=1000
ARG NGINX_VERSION=1.22.1-9
ARG CURL_VERSION=7.88.1-10+deb12u8

RUN set -eux \
	&& groupmod --gid ${USER_GID} ${USER_NAME} \
	&& usermod --uid ${USER_UID} ${USER_NAME} \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y \
		nginx=${NGINX_VERSION} \
		curl=${CURL_VERSION} \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
		/var/www/html/ \
		/var/cache/nginx \
		/var/log/nginx \
		/var/lib/nginx \
		/etc/nginx/ \
	&& chown -R ${USER_NAME}:${USER_NAME} \
		/var/www/html/ \
		/var/cache/nginx/ \
		/var/log/nginx/ \
		/var/lib/nginx \
		/etc/nginx/ \
	&& chmod -R 1755 /etc/nginx/conf.d \
	&& touch /run/nginx.pid \
	&& chown -R ${USER_NAME}:${USER_NAME} /run/nginx.pid

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stdout /var/log/nginx/error.log

COPY --chmod=755 tools/docker-entrypoint.sh /usr/local/bin/
COPY --chmod=755 tools/healthcheck.sh /usr/local/bin/

WORKDIR /var/www/html

USER ${USER_NAME}

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]

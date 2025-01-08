FROM debian:bookworm

ARG USER_UID=1000
ARG USER_GID=1000
ARG NGINX_VERSION=1.22.1-9
ARG SSL_CERT_VERSION=1.1.2

RUN groupadd -r -g $USER_GID nginx && useradd -r -g nginx -u $USER_UID nginx

RUN apt-get update; \
	apt-get install -y \
	nginx=${NGINX_VERSION} \
	ssl-cert=${SSL_CERT_VERSION};

RUN mkdir -p \
	/var/www/html/ \
	/var/cache/nginx \
	/var/log/nginx \
	/var/lib/nginx \
	/etc/nginx/; \
	chown -R nginx:nginx \
	/var/www/html/ \
	/var/cache/nginx/ \
	/var/log/nginx/ \
	/var/lib/nginx \
	/etc/nginx/; \
	chmod -R 1777 /etc/nginx/conf.d; \
	touch /run/nginx.pid && chown -R nginx:nginx /run/nginx.pid

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stdout /var/log/nginx/error.log

COPY --chmod=0755 ./tools/docker-entrypoint.sh /usr/local/bin/

WORKDIR /var/www/html

USER nginx

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]

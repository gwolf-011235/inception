FROM debian:bookworm

ARG CADVISOR_VERSION=v0.49.2

RUN set -eux; \
	apt-get update; \
	apt-get install -y \
		curl

RUN curl -L https://github.com/google/cadvisor/releases/download/${CADVISOR_VERSION}/cadvisor-${CADVISOR_VERSION}-linux-amd64 \
	-o /usr/local/bin/cadvisor && \
	chmod +x /usr/local/bin/cadvisor

COPY --chmod=0755 ./tools/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["cadvisor"]

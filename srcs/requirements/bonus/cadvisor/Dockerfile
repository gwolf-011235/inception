FROM debian:bookworm

ARG CURL_VERSION=7.88.1-10+deb12u8
ARG CADVISOR_VERSION=0.49.2

RUN set -eux \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y \
		curl=${CURL_VERSION} \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/google/cadvisor/releases/download/v${CADVISOR_VERSION}/cadvisor-v${CADVISOR_VERSION}-linux-amd64 \
	-o /usr/local/bin/cadvisor \
	&& chmod +x /usr/local/bin/cadvisor

COPY --chmod=755 ./tools/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["cadvisor", "--url_base_prefix=/admin/cadvisor"]

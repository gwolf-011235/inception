FROM debian:bullseye

ARG USER_NAME=ftp
ARG USER_UID=1000
ARG USER_GID=1000
ARG VSFTPD_VERSION=3.0.3-12+b1
ARG DB_UTIL_VERSION=5.3.1+nmu1

RUN set -eux \
	&& groupadd --system --gid ${USER_GID} ${USER_NAME} \
	&& useradd --system --gid ${USER_GID} --uid ${USER_UID} --shell /bin/false ${USER_NAME} \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y \
		vsftpd=${VSFTPD_VERSION} \
		db-util=${DB_UTIL_VERSION} \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
		/var/run/vsftpd/empty/ \
		/var/log/vsftpd/

# Copy the configuration file with root owner and group
COPY --chown=root:root ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY --chmod=755 ./tools/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]

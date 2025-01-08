FROM debian:bookworm

ARG USER_NAME=ftp
ARG USER_UID=1000
ARG USER_GID=1000
ARG VSFTPD_VERSION=3.0.3-13+b2
ARG DB_UTIL_VERSION=5.3.2

RUN groupadd -g ${USER_GID} ${USER_NAME} && useradd -g ${USER_NAME} -u ${USER_UID} --shell /bin/false ${USER_NAME}

RUN apt-get update; \
	apt-get install -y \
		vsftpd=${VSFTPD_VERSION} \
		db-util=${DB_UTIL_VERSION}

RUN mkdir -p \
		/var/run/vsftpd/empty/ \
		/var/log/vsftpd/

# Copy the configuration file with root owner and group
COPY --chown=root:root ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY --chmod=0755 ./tools/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]

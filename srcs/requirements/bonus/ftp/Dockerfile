FROM debian:bookworm

ARG CURRENT_UID=1000
ARG CURRENT_GID=1000
ARG FTP_USER=ftp

RUN groupadd -g $CURRENT_GID $FTP_USER && useradd -g $FTP_USER -u $CURRENT_UID --shell /bin/false $FTP_USER

RUN apt-get update; \
	apt-get install -y \
		vsftpd \
		db-util

RUN mkdir -p \
		/var/run/vsftpd/empty/ \
		/var/log/vsftpd/


# Copy the configuration file with root owner and group
COPY --chown=root:root ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY --chmod=0755 ./tools/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]

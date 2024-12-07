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

# RUN ln -sf /dev/stdout /var/log/vsftpd/vsftpd.log

COPY --chown=root:root ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY ./conf/vsftpd.virtual /etc/pam.d/vsftpd.virtual
COPY ./tools/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]

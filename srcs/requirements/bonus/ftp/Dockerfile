FROM debian:bookworm

ARG CURRENT_UID=1000
ARG CURRENT_GID=1000

RUN groupadd -r -g $CURRENT_GID ftp && useradd -r -g ftp -u $CURRENT_UID ftp

RUN apt-get update; \
	apt-get install -y \
		vsftpd;

CMD ["vsftpd"]

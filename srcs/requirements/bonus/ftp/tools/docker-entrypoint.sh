#!/bin/bash
set -eo pipefail

# logging functions
ftp_log() {
	local type="$1"; shift
	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}

ftp_note() {
	ftp_log Note "$@"
}

ftp_note "Running ftp docker-entrypoint"

# Check if container is set up
if [ ! -e /etc/vsftpd/init ]; then
	ftp_note "Container ftp is not set up, setting up now"
	ftp_note "Update vsftpd user db with ${FTP_USER}"
	FTP_USER_PASSWORD="$(< $FTP_USER_PASSWORD_FILE)"
	echo -e "${FTP_USER}\n${FTP_USER_PASSWORD}" > /etc/vsftpd/virtual_users.txt
	db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db
	chmod 600 /etc/vsftpd/virtual_users.db
	rm /etc/vsftpd/virtual_users.txt
	touch /etc/vsftpd/init

	ftp_note "Send logfile to stdout"
	touch /var/log/vsftpd/vsftpd.log
	tail -f /var/log/vsftpd/vsftpd.log &
fi

ftp_note "Executing command '$@'"
exec "$@"

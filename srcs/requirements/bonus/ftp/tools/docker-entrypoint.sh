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

# Create home dir and update vsftpd user db:
ftp_note "Setup FTP user"
FTP_USER_PASSWORD="$(< $FTP_USER_PASSWORD_FILE)"
echo -e "${FTP_USER}\n${FTP_USER_PASSWORD}" > /etc/vsftpd/virtual_users.txt
/usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db
chmod 600 /etc/vsftpd/virtual_users.db
rm /etc/vsftpd/virtual_users.txt

# Send logfile to stdout
# touch /var/log/vsftpd/vsftpd.log
# chown vsftpd:vsftpd /var/log/vsftpd/vsftpd.log
# /usr/bin/ln -sf /dev/stdout /var/log/vsftpd/vsftpd.log

ftp_note "Executing command '$@'"
exec "$@"

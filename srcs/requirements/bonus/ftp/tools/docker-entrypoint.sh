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
if [ ! -e index.php ] && [ ! -e wp-includes/version.php ]; then

	ftp_note "Setup FTP user"
	FTP_USER_PASSWORD="$(< $FTP_USER_PASSWORD_FILE)"

else
	ftp_note "FTP user is setup."
fi

ftp_note "Executing command '$@'"
exec "$@"

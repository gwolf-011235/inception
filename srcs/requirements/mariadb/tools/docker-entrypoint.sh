#!/bin/bash
set -eo pipefail

# logging functions
mariadb_log() {
	local type="$1"; shift
	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}

mariadb_note() {
	mariadb_log Note "$@"
}

mariadb_warn() {
	mariadb_log Warn "$@" >&2
}

mariadb_error() {
	mariadb_log ERROR "$@" >&2
	exit 1
}

mariadb_note "Entrypoint of mariadb started"


# check if database has been setup
if [ ! -d /var/lib/mysql/wordpress ]; then
	mariadb_note "Container mariadb is not set up, setting up now"
	mariadbd --skip-networking &
	MARIADB_PID=$!
	mariadb_note "Wait for server startup"
	for i in {30..0}; do
		if mariadb -u root <<<'SELECT 1' &> /dev/null; then
			break
		fi
		sleep 1
	done
	if [ "$i" = 0 ]; then
		mariadb_error "Unable to start server."
	fi

	mariadb_note "Securing installation"
	MARIADB_ROOT_PASSWORD="$(< $MARIADB_ROOT_PASSWORD_FILE)"
	mariadb-secure-installation <<-EOF

		y
		"$MARIADB_ROOT_PASSWORD"
		"$MARIADB_ROOT_PASSWORD"
		y
		y
		y
		y
	EOF

	mariadb_note "Creating database '$WORDPRESS_DB_NAME' and user '$WORDPRESS_DB_USER'"
	MARIADB_WPUSER_PASSWORD="$(< $MARIADB_WPUSER_PASSWORD_FILE)"
	mariadb -u root -p$MARIADB_ROOT_PASSWORD <<-EOF
		CREATE DATABASE $WORDPRESS_DB_NAME;
		CREATE USER '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$MARIADB_WPUSER_PASSWORD';
		GRANT ALL PRIVILEGES ON *.* TO '$WORDPRESS_DB_USER'@'%' WITH GRANT OPTION;
		FLUSH PRIVILEGES;
	EOF

	mariadb_note "Shutdown server"
	kill "$MARIADB_PID"
	wait "$MARIADB_PID"
	mariadb_note "Setup complete"
fi

mariadb_note "Executing command '$@'"
exec $@


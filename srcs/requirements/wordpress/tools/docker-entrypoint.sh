#!/bin/bash
set -eo pipefail

# logging functions
wp-php_log() {
	local type="$1"; shift
	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}

wp-php_note() {
	wp-php_log Note "$@"
}

wp-php_note "Running wp-php docker-entrypoint"

# Check if container is set up
if ! wp core is-installed 2>/dev/null; then
	wp-php_note "Wordpress is not installed."
	wp-php_note "Downloading wordpress"
	wp core download --force

	wp-php_note "Create config"
	MARIADB_WPUSER_PASSWORD="$(< $MARIADB_WPUSER_PASSWORD_FILE)"
	wp config create --force \
		--dbname=${WORDPRESS_DB_NAME} \
		--dbuser=${WORDPRESS_DB_USER} \
		--dbpass=${MARIADB_WPUSER_PASSWORD} \
		--dbhost=${MARIADB_HOST}
	unset MARIADB_WPUSER_PASSWORD

	wp-php_note "Install wordpress"
	WORDPRESS_ADMIN_PASSWORD="$(< $WORDPRESS_ADMIN_PASSWORD_FILE)"
	wp core install \
		--url=${DOMAIN_NAME} \
		--title=${WORDPRESS_TITLE} \
		--admin_user=${WORDPRESS_ADMIN} \
		--admin_email="${WORDPRESS_ADMIN_MAIL}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--skip-email
	unset WORDPRESS_ADMIN_PASSWORD

	if ! wp user get ${WORDPRESS_USER} 2>/dev/null; then
		wp-php_note "Create second wordpress user"
		WORDPRESS_USER_PASSWORD="$(< $WORDPRESS_USER_PASSWORD_FILE)"
		wp user create \
			${WORDPRESS_USER} \
			"${WORDPRESS_USER_MAIL}" \
			--role=author \
			--user_pass=${WORDPRESS_USER_PASSWORD}
		unset WORDPRESS_USER_PASSWORD
	fi

	wp theme install neve --activate
else
	wp-php_note "Wordpress is installed."
	wp core verify-checksums
fi

wp-php_note "Executing command '$@'"
exec "$@"


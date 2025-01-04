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
if [ ! -e index.php ] && [ ! -e wp-includes/version.php ]; then
	wp-php_note "Wordpress does not seem to be set up"
	wp-php_note "Downloading wordpress"
	wp core download

	wp-php_note "Create config"
	MARIADB_WPUSER_PASSWORD="$(< $MARIADB_WPUSER_PASSWORD_FILE)"
	wp config create \
		--dbname=${WORDPRESS_DB_NAME} \
		--dbuser=${WORDPRESS_DB_USER} \
		--dbpass=${MARIADB_WPUSER_PASSWORD} \
		--dbhost=${MARIADB_HOST}
	unset MARIADB_WPUSER_PASSWORD
	wp-php_note "Add config for redis"
	wp config set WP_REDIS_HOST redis
	wp config set WP_REDIS_PORT 6379
	wp config set WP_REDIS_PREFIX 'redis'
	wp config set WP_REDIS_DATABASE 0
	wp config set WP_REDIS_TIMEOUT 1
	wp config set WP_REDIS_READ_TIMEOUT 1

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

	wp-php_note "Create second wordpress user"
	WORDPRESS_USER_PASSWORD="$(< $WORDPRESS_USER_PASSWORD_FILE)"
	wp user create \
		${WORDPRESS_USER} \
		"${WORDPRESS_USER_MAIL}" \
		--role=author \
		--user_pass=${WORDPRESS_USER_PASSWORD}
	unset WORDPRESS_USER_PASSWORD

	wp plugin install redis-cache --activate
	wp plugin update --all
	wp redis enable

else
	wp-php_note "Wordpress is installed."
	wp core verify-checksums
fi

wp-php_note "Executing command '$@'"
exec "$@"


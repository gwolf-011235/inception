#!/bin/bash

if [ -x /usr/local/bin/wp ]
then
	echo "Found Wordpress CLI in /usr/local/bin"
else
	echo "Wordpress CLI not found - try downloading"
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
fi

cd /var/www/html

if ! wp core is-installed --allow-root; then
	echo "Wordpress is not installed. Let's try installing it."
	wp core download --allow-root
	MARIADB_WPUSER_PASSWORD="$(< $MARIADB_WPUSER_PASSWORD_FILE)"
	wp config create --allow-root \
		--dbname=${WORDPRESS_DB_NAME} \
		--dbuser=${WORDPRESS_DB_USER} \
		--dbpass=${MARIADB_WPUSER_PASSWORD} \
		--dbhost=${MARIADB_HOST}
	wp core install --allow-root \
		--url=localhost \
		--title=inception \
		--admin_user=admin \
		--admin_password=admin \
		--admin_email=admin@admin.com
else
	"WP is installed."
	wp core verify-checksums
fi

exec "$@"


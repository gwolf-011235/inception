#!/bin/bash

echo "Generating passwords."

echo "1/5 Create password for MariaDB root."
openssl rand -base64 20 > mariadb_root_password.txt

echo "2/5 Create password for MariaDb user 'wpuser'."
openssl rand -base64 20 > mariadb_wpuser_password.txt

echo "3/5 Create password for Wordpress admin."
openssl rand -base64 20 > wordpress_admin_password.txt

echo "4/5 Create password for Wordpress user 'wpuser'."
openssl rand -base64 20 > wordpress_user_password.txt

echo "5/5 Success: password files generated!"


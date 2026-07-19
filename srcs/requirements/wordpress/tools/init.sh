#!/bin/sh

set -eu

# Wait for MariaDB (maximum 30 seconds)
timeout=30

until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    timeout=$((timeout - 1))

    if [ "$timeout" -le 0 ]; then
        echo "Error: MariaDB is not available."
        exit 1
    fi

    sleep 1
done

if echo "${WORDPRESS_ADMIN_USER}" | grep -iq admin; then
    echo "ERROR: Admin username '${WORDPRESS_ADMIN_USER}' contains forbidden string!"
    echo "Username must NOT contain: admin, Admin, administrator, Administrator"
    exit 1
fi

# Install WordPress only if it hasn't been installed yet
if [ ! -f wp-config.php ]; then
    wp core download --allow-root

    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --allow-root
fi

# Configure PHP-FPM
mkdir -p /run/php
sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

# Start PHP-FPM as PID 1
exec php-fpm8.2 -F
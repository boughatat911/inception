#!/bin/bash

# ila w9a3 error → script y7بس مباشرة
set -eu

# tsna mariadb 7tta twli ready
# bach ma n7awloch nconnectiw 9bl ma database tkhddem
until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    sleep 1
done

# ila wordpress mazal ma tsabatch (ma kaynch wp-config.php)
if [ ! -f wp-config.php ]; then

    # download wordpress files
    # wp-cli tool katjib wordpress mn internet
    wp core download --allow-root

    # create wp-config.php (config file)
    # hna kan3tiw database info (host, user, password...)
    wp config create \
        --dbname=$WORDPRESS_DB_NAME \
        --dbuser=$WORDPRESS_DB_USER \
        --dbpass=$WORDPRESS_DB_PASSWORD \
        --dbhost=$WORDPRESS_DB_HOST \
        --allow-root

    # install wordpress (site setup)
    # kaycreate:
    # - site title
    # - admin user
    # - password
    # - email
    wp core install \
        --url=$DOMAIN_NAME \
        --title="$WORDPRESS_TITLE" \
        --admin_user=$WORDPRESS_ADMIN_USER \
        --admin_password=$WORDPRESS_ADMIN_PASSWORD \
        --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --allow-root
fi

# create socket folder (important)
mkdir -p /run/php
sed -i 's|listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf
# start php-fpm
php-fpm7.4 -F
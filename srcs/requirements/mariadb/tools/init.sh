#!/bin/bash

set -eu

# create required directory for socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# start mariadb temporarily (no network)
mysqld --skip-networking --user=mysql &

# wait until mariadb is ready
until mysqladmin ping --silent; do
    sleep 1
done

# set root password (safe even if already set)
mysqladmin -u root password "$MYSQL_ROOT_PASSWORD" || true

# create database
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e \
"CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

# create user
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e \
"CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

# grant privileges
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e \
"GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"

# apply privileges
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# stop temporary server
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

# start mariadb as main process (foreground)
exec mysqld --user=mysql
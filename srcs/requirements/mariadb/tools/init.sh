#!/bin/bash

set -eu

# start mariadb
mysqld_safe &

# wait until mariadb is ready
until mysqladmin ping --silent; do
    sleep 1
done

# create database
mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

# create user
mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

# give permissions
mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"

# refresh permissions
mysql -e "FLUSH PRIVILEGES;"

# set root password
mysqladmin -u root password $MYSQL_ROOT_PASSWORD

# keep container running
wait
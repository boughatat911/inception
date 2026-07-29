#!/bin/bash
MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)
set -e # exit on error

mkdir -p /run/mysqld # socket directory for MariaDB
chown -R mysql:mysql /run/mysqld

if [ -z "$(ls -A /var/lib/mysql 2>/dev/null)" ]; then # check if the data directory is empty
    mysqld --initialize-insecure --user=mysql

fi

cat >/tmp/init.sql <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

exec mysqld --user=mysql --init-file=/tmp/init.sql
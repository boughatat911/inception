#!/bin/bash
set -euo pipefail

DATADIR=/var/lib/mysql

# Ensure socket directory exists (kept for compatibility)
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ -z "$(ls -A "$DATADIR" 2>/dev/null)" ]; then
  echo "Initializing MariaDB datadir..."
  # Try modern initialization, fallback to mysql_install_db if not available
  if mysqld --initialize-insecure --user=mysql --datadir="$DATADIR" 2>/dev/null; then
    echo "Datadir initialized with mysqld --initialize-insecure"
  else
    echo "mysqld --initialize-insecure not available, attempting mysql_install_db"
    mysql_install_db --user=mysql --datadir="$DATADIR" || true
  fi

  cat > /tmp/init.sql <<SQL
SET @@SESSION.SQL_LOG_BIN=0;
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` ;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
SQL

  # Start MariaDB in foreground and execute init SQL via --init-file (no backgrounding)
  exec mysqld --user=mysql --init-file=/tmp/init.sql
else
  # Existing datadir: run server in foreground
  exec mysqld --user=mysql
fi

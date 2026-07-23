INCEPTION FIXES

Summary of issues found and step-by-step fixes to make the project comply with the subject rules.

1) Problem: mariadb/tools/init.sh starts a temporary mysqld in background (uses "&").
Why it fails: entrypoint scripts must not spawn background processes; evaluation forbids backgrounded commands in entrypoints.

Fix (recommended): use mysqld initialization + --init-file to run SQL on first start, then exec mysqld in foreground. Replace tools/init.sh with the script below.

--- replace srcs/requirements/mariadb/tools/init.sh ---
#!/bin/bash
set -euo pipefail

# If datadir is empty, initialize and apply one-time SQL via --init-file
if [ -z "$(ls -A /var/lib/mysql 2>/dev/null)" ]; then
  echo "Initializing MariaDB datadir..."
  mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql

  cat > /tmp/init.sql <<SQL
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
SQL

  # start mysqld and run init SQL at startup (no backgrounding)
  exec mysqld --user=mysql --init-file=/tmp/init.sql
else
  # datadir exists: just run server in foreground
  exec mysqld --user=mysql
fi
--- end replacement ---

Notes:
- This avoids backgrounding and uses mysqld's init-file mechanism to run SQL once at startup.
- Ensure environment variables MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD are set via .env.

2) Problem: volumes are named volumes (db_data, wp_data) while the subject requires host path /home/<login>/data/ to be used/visible by docker volume inspect.

Fix options (pick one):
A) Use bind mounts (simpler): edit srcs/docker-compose.yml services volumes to map host paths:

mariadb:
  volumes:
    - /home/<login>/data/db:/var/lib/mysql

wordpress:
  volumes:
    - /home/<login>/data/wp:/var/www/html

Replace <login> with evaluated student's login. This guarantees docker volume inspect (host path present) and persistence across reboots.

B) Alternatively, keep named volumes but configure them to bind to host path using driver_opts (advanced). Example:

volumes:
  db_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/<login>/data/db
  wp_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/<login>/data/wp

3) Problem: USER_DOC.md and DEV_DOC.md missing at repository root.

Fix: create the two files (skeletons below). Place at repo root.

USER_DOC.md (minimal required sections):
# User documentation

## Description
Short description of the stack and purpose.

## Start / Stop
Commands:

make up
make down

## Access
- Open https://<login>.42.fr (443 only)
- Admin panel: https://<login>.42.fr/wp-admin

## Credentials (where to find them)
Explain .env usage and how credentials are injected.

## Troubleshooting / Basic checks
- docker compose ps
- docker logs <service>

DEV_DOC.md (minimal required sections):
# Developer documentation

## Prerequisites
- docker, docker compose, make

## Project structure
- srcs/: docker-compose.yml, requirements/, etc.
- srcs/requirements/*: Dockerfiles, conf, tools/

## Build & Run
make up  # builds and starts the stack
make down

## Persistent data
Explain /home/<login>/data mapping and why it's used

## How Dockerfiles were built
Describe base image choice (debian:bookworm), rationale, and that images are built locally from provided Dockerfiles.

4) Other checks & recommendations
- Ensure every Dockerfile is non-empty and builds the service (you already have Dockerfiles for nginx, wordpress, mariadb).
- Confirm ENTRYPOINTs run a script (OK) but that the script does not run background processes (we fixed mariadb). Nginx init.sh uses nginx -g "daemon off;" — correct.
- In wordpress/tools/init.sh: php-fpm binary names may differ across Debian releases (php8.2 vs installed package). Confirm the PHP-FPM command exists (php-fpm8.2 or php-fpm). If container fails, change to exec php-fpm -F or exec php-fpm8.2 -F based on installed binary.
- Ensure docker-compose.yml does NOT contain "network: host" or "links:" (current file is OK) and declares a named network (it does: inception).
- Makefile: it already runs docker compose -f srcs/docker-compose.yml; keep as-is.

5) Validation steps (commands to run locally after changes):
- make fclean && make up
- docker compose -f srcs/docker-compose.yml ps
- docker volume ls  # expect bound host paths or named volumes
- docker volume inspect <volume or check host path exists>
- curl -vk https://<login>.42.fr/  # check TLS served on 443
- Access WordPress admin and edit a page; reboot VM and verify persistence

6) If you want, apply the fixes automatically
- I can either create the three missing/modified files (mariadb/tools/init.sh replacement, USER_DOC.md, DEV_DOC.md) for you now, or just create this INCEPTION_FIXES.md and you apply changes manually. Tell me which you prefer.

End of fixes.

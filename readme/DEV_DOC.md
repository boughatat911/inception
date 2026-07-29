# DEV_DOC

## Prerequisites

- Docker
- Docker Compose
- GNU Make

## Project Setup

1. Clone the repository.
2. Create the `.env` file and fill in the required variables.
3. Create the `secrets/` directory and add:
   - db_root_password
   - mysql_password
   - wp_admin_password
   - wp_user_password
4. Ensure the LOGIN variable matches the evaluated login, or run:

```bash
LOGIN=nbougrin make
```

## Build and Launch

```bash
make
```

Builds all Docker images and starts the infrastructure.

## Stop

```bash
make down
```

Stops the containers.

## Clean

```bash
make clean
```

Stops the containers and removes them.

## Remove Everything

```bash
make fclean
```

Removes containers, images, networks and volumes.

## Useful Docker Commands

```bash
docker compose ps
docker compose logs
docker compose exec mariadb sh
docker compose exec wordpress sh
docker compose exec nginx sh
docker volume ls
docker volume inspect <volume>
docker network ls
```

## Data Persistence

The project uses two Docker named volumes:

- MariaDB data
- WordPress files

Both store their data under:

```text
/home/<login>/data
```

You can verify this with:

```bash
docker volume inspect <volume>
```

and confirm that the mount points to:

```text
/home/<login>/data
```
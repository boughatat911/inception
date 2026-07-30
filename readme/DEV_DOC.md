# DEV_DOC

## Prerequisites

The following software must be installed before running the project:

- Docker
- Docker Compose
- GNU Make

---

## Project Setup

1. Clone the repository.

2. Create the `srcs/.env` file and fill the required environment variables.

3. Create the `secrets/` directory at the root of the repository and add the following files:

```
secrets/
├── db_root_password
├── mysql_password
├── wp_admin_password
└── wp_user_password
```

4. Ensure the data directories exist:

```
/home/<login>/data/mariadb
/home/<login>/data/wordpress
```

5. Build and start the infrastructure:

```bash
make
```

---

## Build and Launch

Build all Docker images and start the containers:

```bash
make
```

Stop the containers:

```bash
make down
```

Stop and remove containers:

```bash
make clean
```

Remove containers, images, networks and volumes:

```bash
make fclean
```

---

## Managing Containers

List running containers:

```bash
docker-compose -f srcs/docker-compose.yml ps
```

View logs:

```bash
docker-compose -f srcs/docker-compose.yml logs
```

Open a shell inside a container:

```bash
docker-compose -f srcs/docker-compose.yml exec mariadb sh
docker-compose -f srcs/docker-compose.yml exec wordpress sh
docker-compose -f srcs/docker-compose.yml exec nginx sh
```

Restart the stack:

```bash
docker-compose -f srcs/docker-compose.yml restart
```

---

## Managing Volumes

List Docker volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect <volume_name>
```

---

## Data Persistence

The project uses two Docker named volumes:

- MariaDB data
- WordPress website files

Their data is stored on the host machine under:

```
/home/<login>/data/mariadb
/home/<login>/data/wordpress
```

The data remains available even if the containers are removed because it is stored in Docker named volumes.

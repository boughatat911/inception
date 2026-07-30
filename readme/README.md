*This project has been created as part of the 42 curriculum by nbougrin.*

# Description

This project implements infrastructure using Docker Compose. It consists of three services:

- Nginx with TLS 1.2/1.3
- WordPress with PHP-FPM
- MariaDB

The services communicate through a dedicated Docker network and use persistent Docker named volumes.

# Instructions

## Prerequisites

- Docker
- Docker Compose
- GNU Make

## Installation

1. Create `srcs/.env` and fill the required environment variables.
2. Create the required files inside the `secrets/` directory.
3. Run:

```bash
make
```

## Access

Open:

```
https://<login>.42.fr
```

# Resources

## References

- Docker Documentation
- Docker Compose Documentation
- Nginx Documentation
- MariaDB Documentation
- WordPress Documentation
- PHP-FPM Documentation

## AI Usage

AI was used to explain Docker concepts, review shell scripts, and improve the project documentation. All Dockerfiles, configuration files, and initialization scripts were written, tested, reviewed, and fully understood before being included in the project.

# Project Description

## Why Docker?

Docker provides lightweight isolated containers that package an application together with its dependencies, making deployment reproducible and consistent across environments.

## Services

- Nginx: HTTPS entry point and reverse proxy.
- WordPress: PHP application executed through PHP-FPM.
- MariaDB: Relational database used by WordPress.

## Main Design Choices

- One service per container.
- Custom Dockerfiles for every service.
- Dedicated Docker network.
- Two persistent Docker named volumes.
- Environment variables for configuration.
- Docker secrets for passwords.
- TLS enabled only on Nginx.

## Comparisons

### Virtual Machines vs Docker

- Virtual Machines virtualize an entire operating system.
- Docker containers share the host kernel, making them lighter and faster to start.

### Secrets vs Environment Variables

- Environment variables are suitable for configuration values.
- Docker secrets are better suited for sensitive information such as passwords.

### Docker Network vs Host Network

- Docker bridge networks isolate containers while allowing communication between services.
- Host networking removes isolation by sharing the host's network stack.

### Docker Volumes vs Bind Mounts

- Docker named volumes are managed by Docker and are recommended for persistent application data.
- Bind mounts map an existing host directory directly into a container and are mainly useful during development.
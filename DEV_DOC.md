DEV_DOC

Prerequisites
- Docker and Docker Compose
- Make

Setup
- Copy srcs/.env.example -> srcs/.env and fill credentials.
- Ensure LOGIN variable matches evaluated login or run: LOGIN=nbougrin make all

Makefile
- make all: creates data dirs and runs compose up -d --build
- make down: stops compose
- make clean: down -v

Persistence
- Volumes are bind-mounted to /home/${LOGIN}/data on host. Inspect via: docker volume inspect <volume> and confirm HostPath contains /home/<login>/data

NAME = inception

LOGIN ?= $(USER)

DATA_PATH = /home/$(LOGIN)/data

COMPOSE = $(shell if command -v docker-compose >/dev/null 2>&1; then echo docker-compose -f srcs/docker-compose.yml; else echo docker compose -f srcs/docker-compose.yml; fi)

all:
	mkdir -p $(DATA_PATH)/db
	mkdir -p $(DATA_PATH)/wp
	$(MAKE) up

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean: clean
	docker system prune -af
	docker volume prune -f

re: fclean all

.PHONY: all up down clean fclean re

COMPOSE = docker-compose -f srcs/docker-compose.yml
DATA_PATH = $(HOME)/data

all: up

up:
	mkdir -p $(DATA_PATH)/db
	mkdir -p $(DATA_PATH)/wp
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean: clean
	docker system prune -af

re: fclean all

.PHONY: all up down clean fclean re
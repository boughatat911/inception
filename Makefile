NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

all: up 

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean:
	docker system prune -af
	docker volume prune -f

re: fclean up
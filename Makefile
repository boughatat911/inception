COMPOSE = docker compose -f srcs/docker-compose.yml
DATA_PATH = $(HOME)/data

all: up

up:
	mkdir -p $(DATA_PATH)/mariadb
	mkdir -p $(DATA_PATH)/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean: clean
	docker system prune -af
	sudo rm -rf $(DATA_PATH)

re: fclean all
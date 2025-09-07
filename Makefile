all:
	mkdir -p /home/${USER}/data/wordpress /home/${USER}/data/db
	docker compose -f srcs/docker-compose.yml up --build -d

up:
	docker compose -f srcs/docker-compose.yml up -d

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker system prune -af --volumes
	docker volume rm $$(docker volume ls -q)

fclean: clean
	sudo rm -rf /home/${USER}/data

re: fclean
	all

.PHONY: all up down clean fclean

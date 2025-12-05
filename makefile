.PHONY: help up down restart build logs exec shell clean force-down ps

help:
	@echo "Docker Makefile Commands:"
	@echo "  make up          - Start containers"
	@echo "  make down        - Stop containers"
	@echo "  make restart     - Restart containers"
	@echo "  make build       - Build images"
	@echo "  make rebuild     - Force rebuild images"
	@echo "  make logs        - View container logs"
	@echo "  make exec        - Execute command in container (CMD=...)"
	@echo "  make shell       - Open shell in container"
	@echo "  make ps          - List running containers"
	@echo "  make clean       - Remove stopped containers"
	@echo "  make force-down  - Stop and remove all containers"

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

build:
	docker compose build

rebuild:
	docker compose build --no-cache

logs:
	docker compose logs -f

exec:
	docker compose exec -it devops $(CMD)

shell:
	docker compose exec -it devops sh

ps:
	docker compose ps

clean:
	docker compose down -v

force-down:
	docker compose down -v --remove-orphans
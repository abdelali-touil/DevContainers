DOCKER := docker compose --file compose.yml --project-name devcontainer

.PHONY: help up down restart build rebuild logs exec shell clean force-down ps

help:
	@echo "Docker Makefile Commands:"
	@echo "  make install     - Create necessary directories before run initial setup"
	@echo "  make up          - Start containers"
	@echo "  make down        - Stop containers"
	@echo "  make restart     - Restart containers"
	@echo "  make build       - Build images"
	@echo "  make rebuild     - Force rebuild images"
	@echo "  make logs        - View container logs (SERVICE=...)"
	@echo "  make exec        - Execute command in container (SERVICE=... CMD=...)"
	@echo "  make shell       - Open shell in container (SERVICE=...)"
	@echo "  make ps          - List running containers"
	@echo "  make clean       - Remove stopped containers and volumes"
	@echo "  make force-down  - Stop and remove all containers"

install:
	mkdir -p data/maildev
	mkdir -p data/portainer
	mkdir -p data/jmeter
	mkdir -p logs
	mkdir -p secrets
	@echo "Installation complete. You can now run 'make up' to start the containers."

up:
	$(DOCKER) up -d

down:
	$(DOCKER) down

restart:
	$(DOCKER) down && $(DOCKER) up -d

build:
	$(DOCKER) build

rebuild:
	$(DOCKER) build --no-cache

logs:
	$(DOCKER) logs -f $(SERVICE)

exec:
	$(DOCKER) exec -it $(SERVICE) $(CMD)

shell:
	$(DOCKER) exec -it $(SERVICE) sh

ps:
	$(DOCKER) ps

clean:
	$(DOCKER) down -v --rmi all --volumes --remove-orphans

force-down:
	$(DOCKER) down -v --remove-orphans

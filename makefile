DOCKER := docker compose --file compose.yml --project-name devcontainer

.PHONY: help setup install up down restart build logs exec ps clean

help:
	@echo "Docker Makefile Commands:"
	@echo "  make setup       - Create necessary directories before run installation"
	@echo "  make install     - Build images and start containers"
	@echo "  make up          - Start containers"
	@echo "  make down        - Stop containers"
	@echo "  make restart     - Restart containers"
	@echo "  make build       - Force rebuild images"
	@echo "  make logs        - View container logs (SERVICE=...)"
	@echo "  make exec        - Execute command in container (SERVICE=... CMD=...)"
	@echo "  make ps          - List running containers"
	@echo "  make clean       - Remove stopped containers and volumes"

setup:
	mkdir -p data/maildev
	mkdir -p data/portainer
	mkdir -p data/jmeter
	mkdir -p logs
	mkdir -p secrets
	mkdir -p secrets/certs
	mkdir -p secrets/.kube
	mkdir -p secrets/.ssh
	@echo "Installation complete. You can now run 'make up' to start the containers."

install:
	$(DOCKER) build --no-cache
	$(DOCKER) up -d

up:
	$(DOCKER) up -d

down:
	$(DOCKER) down

restart:
	$(DOCKER) down -v --remove-orphans
	$(DOCKER) up -d

build:
	$(DOCKER) build --no-cache

logs:
	$(DOCKER) logs -f $(SERVICE)

exec:
	$(DOCKER) exec -it $(SERVICE) $(CMD)

ps:
	$(DOCKER) ps

clean:
	$(DOCKER) down -v --volumes --remove-orphans
	rm -rf data logs certs secrets
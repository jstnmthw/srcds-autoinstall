# Define the shell type
SHELL := /bin/bash -e

# Define the docker-compose file
DOCKER_COMPOSE_FILE := docker-compose.yml

# Define the container name
DOCKER_EXEC = @docker-compose -f $(DOCKER_COMPOSE_FILE) exec -u linuxgsm -it $(CONTAINER) /bin/bash -c

# Default target to run when running `make` without arguments
all: restart

# Stop the containers
stop:
	@echo "Stopping the containers..."
	@docker-compose -f $(DOCKER_COMPOSE_FILE) down --remove-orphans

# Start the containers
start:
	@echo "Starting the containers..."
	@docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

# Bash into the container
bash: check-container
	@docker-compose -f $(DOCKER_COMPOSE_FILE) exec -it $(CONTAINER) /bin/bash

# Install metamod
install-metamod: check-container check-game
	$(DOCKER_EXEC) "/scripts/install/metamod.sh $(GAME)"

# Install AMX Mod X
install-amxmodx: check-container check-game
	$(DOCKER_EXEC) "/scripts/install/amxmodx.sh $(GAME)"

# Install AMX Mod X plugins
install-amxmodx-plugins: check-container check-game check-config
	$(DOCKER_EXEC) "/scripts/install/plugins.sh $(CONTAINER) $(GAME) $(CONFIG) amxmodx"

# Install FoxBot (TFC Only)
install-foxbot: check-container
	$(DOCKER_EXEC) "/scripts/install/foxbot.sh $(CONTAINER)"

# Set up the config
setup: check-container check-game check-config download
	$(DOCKER_EXEC) "/scripts/setup.sh $(GAME) $(CONFIG)"

# Download the server files
download:
	@./scripts/utils/s3-download.sh

# Install
install: check-container check-game check-config check-script
	@./scripts/${SCRIPT} $(CONTAINER) $(GAME) $(CONFIG)

# Check if the script is set
check-script:
	@if [ -z "$(SCRIPT)" ]; then \
		echo "SCRIPT is not set. Save your launch script inside /scripts directory."; \
		exit 1; \
	fi

# Check if the container is set
check-container:
	@if [ -z "$(CONTAINER)" ]; then \
		echo "CONTAINER is not set"; \
		exit 1; \
	fi

# Check if the game is set
check-game:
	@if [ -z "$(GAME)" ]; then \
		echo "GAME is not set"; \
		exit 1; \
	fi

# Check if the config is set
check-config:
	@if [ -z "$(CONFIG)" ]; then \
		echo "CONFIG is not set"; \
		exit 1; \
	fi

# Restarting the containers
restart: stop start

# Phony targets
.PHONY: stop start restart install-metamod install-amxmodx install-foxbot install-plugins install-all download
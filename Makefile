# Define the shell type
SHELL := /bin/bash -e

# Define the docker-compose file
DOCKER_COMPOSE_FILE := docker-compose.yml

# Define the container name
DOCKER_EXEC = @docker-compose -f $(DOCKER_COMPOSE_FILE) exec -u linuxgsm -it $(CONTAINER) /bin/bash -c

# Default target to run when running `make` without arguments
default: restart

# Stop the containers
stop:
	@echo "Stopping the containers..."
	@docker-compose -f $(DOCKER_COMPOSE_FILE) down --remove-orphans

# Start the containers
start:
	@echo "Starting the containers..."
	@docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

# Restarting the containers
restart: stop start

# Bash into the container
bash: check-container
	@docker-compose -f $(DOCKER_COMPOSE_FILE) exec -it $(CONTAINER) /bin/bash

# Copy config
copy-config: check-script check-container
	$(DOCKER_EXEC) "/scripts/$(SCRIPT)/config.sh"

# Install
install: check-container check-script check-game check-config
	$(DOCKER_EXEC) "/scripts/$(SCRIPT)/install.sh"

# Pack up custom configs
pack:
	@tar -zvcf config.tar.gz config/ plugins/ docker-compose.yml

# Download the server files
download:
	@./scripts/utils/s3-download.sh

# Upload the server files
upload:
	@./scripts/utils/s3-upload.sh

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

# Phony targets
.PHONY: stop start restart bash copy-config pack download upload check-script check-container check-game check-config
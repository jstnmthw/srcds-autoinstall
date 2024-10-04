# Define the shell type
SHELL := /bin/bash -e

# Define the docker-compose file
DOCKER_COMPOSE_FILE := $(COMPOSE)

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

# Install
install: check-script
	"scripts/$(SCRIPT)/install.sh"

# Check if the script is set
check-script:
	@if [ -z "$(SCRIPT)" ]; then \
		echo "SCRIPT is not set."; \
		exit 1; \
	fi

# Check if the container is set
check-container:
	@if [ -z "$(CONTAINER)" ]; then \
		echo "CONTAINER is not set"; \
		exit 1; \
	fi

# Phony targets
.PHONY: stop start restart install check-script check-container
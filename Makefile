# Define the shell type
SHELL := /bin/bash -e

# Define the docker-compose file
DOCKER_COMPOSE_FILE := docker-compose.yml

# Define the container name
DOCKER_EXEC = @docker-compose -f $(DOCKER_COMPOSE_FILE) exec -it $(CONTAINER) /bin/bash -c

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

# Install metamod
install-metamod: check-container
	$(DOCKER_EXEC) "/src/scripts/install_metamod.sh $(CONTAINER)"

# Install AMX Mod X
install-amxmodx: check-container check-game
	$(DOCKER_EXEC) "/src/scripts/install_amxmodx.sh $(CONTAINER) $(GAME)"

# Install FoxBot (TFC Only)
install-foxbot: check-container
	$(DOCKER_EXEC) "/src/scripts/install_foxbot.sh $(CONTAINER)"

# Install AMX Mod X plugins
install-plugins: check-container check-game check-config
	$(DOCKER_EXEC) "/src/scripts/install_plugins.sh $(CONTAINER) $(GAME) $(CONFIG)"

# Set up the config
setup-config: check-container
	$(DOCKER_EXEC) "/src/scripts/setup_config.sh $(GAME) $(CONFIG) $(MOTD)"

# Install all addons and config
install-all: check-container check-game install-metamod install-amxmodx install-foxbot install-plugins setup-config
	@echo "Info: All addons and configs have been installed successfully!"

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
.PHONY: stop start restart install-metamod install-amxmodx install-foxbot install-all
#!/bin/bash -e

# Set the game and container
SCRIPT=cs2-example
CONTAINER=cs2
COMPOSE=./docker-compose-cs2.yml

# Set maximum retries and delay for network operations
MAX_RETRIES=3
RETRY_DELAY=5

# Set the game server
echo "Info: Setting up $SCRIPT..."
cd ./

# Check if the container is running
if ! docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER}\$"; then
    echo "Info: $CONTAINER container not running."
    echo "Info: Bringing up $CONTAINER..."

    ATTEMPT=1   # Initial attempt count

    # Retry loop for docker-compose up
    until docker-compose -f "$COMPOSE" up -d "$CONTAINER"; do
        if [ $ATTEMPT -ge $MAX_RETRIES ]; then
            echo "Error: Failed to bring up $CONTAINER after $ATTEMPT attempts."
            exit 1
        fi
        echo "Warning: docker-compose up failed. Retrying in $RETRY_DELAY seconds..."
        sleep $RETRY_DELAY
        ((ATTEMPT++))
    done
else
    echo "Info: $CONTAINER already exists."
fi

# Check and wait for the container to start
echo "Info: Checking if $CONTAINER is healthy..."
until [ "$(docker inspect -f "{{.State.Health.Status}}" "$CONTAINER")" == "healthy" ]; do
    echo "Info: Waiting for $CONTAINER to start up..."
    sleep 10
done

# Check and wait for LinuxGSM to finish downloading and installing the game
echo "Info: Waiting for the game server to be ready..."
until docker exec -u linuxgsm "$CONTAINER" ./cs2server details | grep -q "STARTED"; do
    echo "Info: Game server is not ready yet. Retrying in 30 seconds..."
    sleep 30
done
echo "Info: Game server is running."

# Install configuration files and restart the container
echo "Info: Running configuration scripts inside the container..."
docker exec -u linuxgsm "$CONTAINER" /scripts/cs2-example/metamod_update.sh
docker exec -u linuxgsm "$CONTAINER" /scripts/cs2-example/metamod_write.sh
docker exec -u linuxgsm "$CONTAINER" /scripts/cs2-example/simple-admin.sh
docker exec -u linuxgsm "$CONTAINER" /scripts/utils/s3-download.sh
docker exec -u linuxgsm "$CONTAINER" /scripts/cs2-example/config.sh

echo "Info: Restarting server..."
docker-compose -f "$COMPOSE" restart "$CONTAINER"

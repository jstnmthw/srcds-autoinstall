#!/bin/bash -e

# Set the game and container
SCRIPT=cs2-example
CONTAINER=cs2
COMPOSE=./docker-compose-cs2.yml

# Set the game server
echo "Info: Setting up cs2-example..."
cd ./

# Check if the container running
if ! docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER}\$"; then
    echo "Info: $CONTAINER container not running."
    echo "Info: Bringing up $CONTAINER..."
    docker-compose -f $COMPOSE up -d $CONTAINER
else
    echo "Info: $CONTAINER already exists."
fi

# Check and wait for the container to start
while [ "$(docker inspect -f "{{.State.Health.Status}}" $CONTAINER)" != "healthy" ]; do
    echo "Info: Waiting for $CONTAINER to start up..."
    sleep 10
done

# Check and wait for LinuxGSM to finish downloading and installing the game
while true; do
    OUTPUT=$(docker exec -u linuxgsm $CONTAINER ./cs2server details)
    if echo "$OUTPUT" | grep -q "STARTED"; then
        echo "Info: Game server is running."
        break
    else
        echo "Info: Waiting for game server to be ready..."
        sleep 30
    fi
done

# Install configuration files and restart the container
docker exec -u linuxgsm $CONTAINER /scripts/cs2-example/metamod_update.sh
docker exec -u linuxgsm $CONTAINER /scripts/cs2-example/metamod_write.sh
docker exec -u linuxgsm $CONTAINER /scripts/cs2-example/simple-admin.sh
docker exec -u linuxgsm $CONTAINER /scripts/utils/s3-download.sh
docker exec -u linuxgsm $CONTAINER /scripts/cs2-example/config.sh

echo "Info: Restarting server..."
docker-compose -f $COMPOSE restart $CONTAINER

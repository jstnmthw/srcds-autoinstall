#!/bin/bash -e

# Set the game and container
SCRIPT=cs2-example
CONTAINER=cs2
COMPOSE=docker-compose-cs2.yml

echo "Info: Setting up cs2-example..."
cd ./
docker-compose -f $COMPOSE up -d

# Check and wait for the container to start
while [ "$(docker inspect -f "{{.State.Health.Status}}" $CONTAINER)" != "healthy" ]; do
    echo "Info: Waiting for $CONTAINER to start..."
    sleep 10
done

make copy-config CONTAINER=$CONTAINER SCRIPT=$SCRIPT COMPOSE=$COMPOSE
make restart
 
echo "Info: Setting up $SCRIPT inside $CONTAINER... Done!"
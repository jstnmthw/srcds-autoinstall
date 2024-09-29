#!/bin/bash -e

# Container argument
CONTAINER=$1

# Game argument
GAME=$2

# Config Name argument
CONFIG=$3

echo "Info: Setting up $GAME inside $CONTAINER..."
cd ./
docker-compose -f docker-compose-cs2.yml up -d

# Check and wait for the container to be up
while [ "$(docker inspect -f "{{.State.Health.Status}}" $CONTAINER)" != "healthy"
    echo "Info: Waiting for $CONTAINER to be up..."
    sleep 10
done

make copy-config GAME=cs2-example CONTAINER=cs2
make restart
 
echo "Info: Setting up $GAME inside $CONTAINER... Done!"
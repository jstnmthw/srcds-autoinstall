#!/bin/bash -e

# Container argument
CONTAINER=$1

# Game argument
GAME=$2

# Config Name argument
CONFIG=$3

echo "Info: Setting up $GAME inside $CONTAINER..."

cd ./
echo "Info: Running from $(pwd)"

# make download
# sleep 10
docker-compose -f docker-compose-cs2.yml up -d

# Check and wait for the container to be up
while [ "$(docker inspect -f "{{.State.Health.Status}}" $CONTAINER)" != "healthy"
    echo "Info: Waiting for $CONTAINER to be up..."
    sleep 10
done

# make install-metamod CONTAINER=$CONTAINER GAME=$GAME
# sleep 10
# make install-amxmodx CONTAINER=$CONTAINER GAME=$GAME
# sleep 10
# make install-foxbot CONTAINER=$CONTAINER GAME=$GAME
# sleep 10
# make install-amxmodx-plugins CONTAINER=$CONTAINER GAME=$GAME CONFIG=$CONFIG
# sleep 10
# make setup CONTAINER=$CONTAINER GAME=$GAME CONFIG=$CONFIG
# sleep 5
# make restart
 
echo "Info: Setting up $GAME inside $CONTAINER... Done!"
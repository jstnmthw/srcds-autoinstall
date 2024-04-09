#!/bin/bash -e

# Container argument
CONTAINER=$1

# Game argument
GAME=$2

# Config Name argument
CONFIG_NAME=$3

echo "Info: Setting up $GAME inside $CONTAINER..."

make download
sleep 10
docker-compose up -d
sleep 30
make install-metamod CONTAINER=$CONTAINER GAME=$GAME
sleep 10
make install-amxmodx CONTAINER=$CONTAINER GAME=$GAME
sleep 10
make install-foxbot CONTAINER=$CONTAINER GAME=$GAME
sleep 10
make install-amxmodx-plugins CONTAINER=$CONTAINER GAME=$GAME CONFIG=$CONFIG_NAME
sleep 10
make setup CONTAINER=$CONTAINER GAME=$GAME CONFIG=$CONFIG_NAME
sleep 5
make restart
 
echo "Info: Setting up $GAME inside $CONTAINER... Done!"
#!/bin/bash

# Define the server directory path
SERVER_DIR="/data/serverfiles/game/csgo"
GAMEINFO_FILE="$SERVER_DIR/gameinfo.gi"
METAMOD_DIR="$SERVER_DIR/addons/metamod"

# Step 1: Modify the gameinfo.gi file
if [ ! -f "$GAMEINFO_FILE" ]; then
  echo "Error: gameinfo.gi file not found in $SERVER_DIR."
  exit 1
fi

echo "Modifying $GAMEINFO_FILE to include MetaMod..."

# Check if the entry already exists
if grep -q "Game csgo/addons/metamod" "$GAMEINFO_FILE"; then
  echo "MetaMod entry already exists in gameinfo.gi."
else
  # Insert the MetaMod path below the Game_LowViolence line
  sed -i '/Game_LowViolence/a\ \ \ \ Game csgo/addons/metamod' "$GAMEINFO_FILE"
  if [ $? -eq 0 ]; then
    echo "MetaMod entry added successfully."
  else
    echo "Error: Failed to modify gameinfo.gi."
    exit 1
  fi
fi

echo "MetaMod installation completed successfully."

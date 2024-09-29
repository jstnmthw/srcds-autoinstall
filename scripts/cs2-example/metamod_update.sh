#!/bin/bash

# Load environment variables from .env file 
if [ -f .env ]; then
  source .env
else
  echo "Error: .env file not found. Please create a .env file with your settings."
  exit 1
fi

# Check if the METAMOD_URL environment variable is set
if [ -z "$METAMOD_URL" ]; then
  echo "Error: METAMOD_URL environment variable is not set."
  echo "Please set METAMOD_URL to the MetaMod download URL."
  exit 1
fi

# Define the server directory path
SERVER_DIR="/data/serverfiles/game/csgo"
GAMEINFO_FILE="$SERVER_DIR/gameinfo.gi"
METAMOD_DIR="$SERVER_DIR/addons/metamod"

# Step 1: Download MetaMod
echo "Downloading MetaMod from $METAMOD_URL..."
wget -q -O metamod.tar.gz "$METAMOD_URL"

if [ $? -ne 0 ]; then
  echo "Error: Failed to download MetaMod. Please check the METAMOD_URL."
  exit 1
fi

echo "Download complete."

# Step 2: Unarchive the MetaMod file
echo "Extracting MetaMod..."
tar -xzf metamod.tar.gz -C "$SERVER_DIR"

if [ $? -ne 0 ]; then
  echo "Error: Failed to extract MetaMod."
  exit 1
fi

# Clean up the downloaded archive
rm -f metamod.tar.gz
echo "Cleaning up..."
echo "Extraction complete."

# Step 3: Modify the gameinfo.gi file
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

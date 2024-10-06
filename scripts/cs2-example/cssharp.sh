#!/bin/bash

# Set the CSSharp download URL
CSSHARP_URL=https://github.com/roflmuffin/CounterStrikeSharp/archive/refs/tags/v276.tar.gz

# Define the server directory path
SERVER_DIR="/data/serverfiles/game/csgo"

# Step 1: Download CSSharp
echo "Downloading CSSharp from $CSSHARP_URL..."
wget -q -O CSSharp.zip "$CSSHARP_URL"

if [ $? -ne 0 ]; then
  echo "Error: Failed to download CSSharp. Please check the CSSHARP_URL."
  exit 1
fi

echo "Download complete."

# Step 2: Unarchive the CSSharp file
echo "Extracting CSSharp..."
unzip -q CSSharp.zip -d "$SERVER_DIR"

if [ $? -ne 0 ]; then
  echo "Error: Failed to extract CSSharp."
  exit 1
fi

# Clean up the downloaded archive
rm -f CSSharp.zip
echo "Cleaning up..."
echo "Extraction complete."

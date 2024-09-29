#!/bin/bash

# Load environment variables from .env file 
if [ -f .env ]; then
  source .env
else
  echo "Error: .env file not found. Please create a .env file with your settings."
  exit 1
fi

# Check if the CSSharp environment variable is set
if [ -z "$CSSHARP_URL" ]; then
  echo "Error: CSSHARP_URL environment variable is not set."
  echo "Please set CSSHARP_URL to the CSSharp download URL."
  exit 1
fi

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


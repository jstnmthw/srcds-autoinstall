#!/bin/bash

# Load environment variables from .env file 
if [ -f .env ]; then
  source .env
else
  echo "Error: .env file not found. Please create a .env file with your settings."
  exit 1
fi

# Check if the MiniAdmin environment variable is set
if [ -z "$MINI_ADMIN_URL" ]; then
  echo "Error: MINI_ADMIN_URL environment variable is not set."
  echo "Please set MINI_ADMIN_URL to the MiniAdmin download URL."
  exit 1
fi

# Define the server directory path
SERVER_DIR="/data/serverfiles/game/csgo"

# Step 1: Download MiniAdmin
echo "Downloading MiniAdmin from $MINI_ADMIN_URL..."
wget -q -O MiniAdmin.zip "$MINI_ADMIN_URL"

if [ $? -ne 0 ]; then
  echo "Error: Failed to download MiniAdmin. Please check the MINI_ADMIN_URL."
  exit 1
fi

echo "Download complete."

# Step 2: Unarchive the MiniAdmin file
echo "Extracting MiniAdmin..."
unzip -q MiniAdmin.zip -d "$SERVER_DIR"

if [ $? -ne 0 ]; then
  echo "Error: Failed to extract MiniAdmin."
  exit 1
fi

# Clean up the downloaded archive
rm -f MiniAdmin.zip
echo "Cleaning up..."
echo "Extraction complete."

# # Define the paths
# BASE_ADMIN_DIR="$SERVER_DIR/addons/counterstrikesharp/plugins/BaseAdmin"
# DATABASE_JSON="$BASE_ADMIN_DIR/database.json"
# MAPCYCLE_SRC="/config/cs2/mapcycle.txt"
# MAPS_DEST="$BASE_ADMIN_DIR/maps.txt"

# # Check if the database.json file exists
# if [ ! -f "$DATABASE_JSON" ]; then
#   echo "Error: $DATABASE_JSON does not exist."
#   exit 1
# fi

# # Step 1: Replace the connection details in database.json
# echo "Updating connection details in database.json..."

# # Replace the Connection details
# jq '.Connection = {
#     "Host": "sqlite",
#     "Database": "miniadmin",
#     "Port": 3306,
#     "User": "miniadmin",
#     "Password": "password"
# }' "$DATABASE_JSON" > "$DATABASE_JSON.tmp" && mv "$DATABASE_JSON.tmp" "$DATABASE_JSON"

# if [ $? -eq 0 ]; then
#   echo "Connection details updated successfully."
# else
#   echo "Error: Failed to update connection details."
#   exit 1
# fi

# # Step 2: Copy mapcycle.txt to the target directory as maps.txt
# if [ ! -f "$MAPCYCLE_SRC" ]; then
#   echo "Error: Source mapcycle.txt does not exist at $MAPCYCLE_SRC."
#   exit 1
# fi

# echo "Copying mapcycle.txt to $MAPS_DEST..."
# cp "$MAPCYCLE_SRC" "$MAPS_DEST"

# if [ $? -eq 0 ]; then
#   echo "Successfully copied mapcycle.txt to $MAPS_DEST."
# else
#   echo "Error: Failed to copy mapcycle.txt."
#   exit 1
# fi

# echo "Script completed successfully."

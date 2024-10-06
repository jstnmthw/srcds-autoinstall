#!/bin/bash
ANYBASE_LIB_URL=https://github.com/NickFox007/AnyBaseLibCS2/releases/download/0.9.1/AnyBaseLib.zip
PLAYER_SETTINGS_URL=https://github.com/NickFox007/PlayerSettingsCS2/releases/download/0.7/PlayerSettings.zip
MENU_MANAGER_URL=https://github.com/NickFox007/MenuManagerCS2/releases/download/0.9/MenuManager.zip
SIMPLE_ADMIN_URL=https://github.com/daffyyyy/CS2-SimpleAdmin/releases/download/build-256/CS2-SimpleAdmin-256.zip

# Load environment variables from .env file 
# if [ -f .env ]; then
#   source .env
# else
#   echo "Error: .env file not found. Please create a .env file with your settings."
#   exit 1
# fi

# Check if required environment variables are set
if [ -z "$ANYBASE_LIB_URL" ] || [ -z "$PLAYER_SETTINGS_URL" ] || [ -z "$MENU_MANAGER_URL" ] || [ -z "$SIMPLE_ADMIN_URL" ]; then
  echo "Error: One or more environment variables are not set."
  echo "Please set ANYBASE_LIB_URL, PLAYER_SETTINGS_URL, MENU_MANAGER_URL, and SIMPLE_ADMIN_URL."
  exit 1
fi

# Define the server directory path
SERVER_DIR="/data/serverfiles/game/csgo"

# Step 1.1: Download AnyBase Lib
echo "Downloading AnyBase Lib from $ANYBASE_LIB_URL..."
wget -q -O /tmp/AnyBase.zip "$ANYBASE_LIB_URL"

if [ $? -ne 0 ]; then
  echo "Error: Failed to download AnyBase. Please check the ANYBASE_LIB_URL."
  exit 1
fi

echo "Download complete."

# Step 1.2: Unarchive the AnyBase file
echo "Extracting AnyBase..."
unzip -qo /tmp/AnyBase.zip -d "$SERVER_DIR"

if [ $? -ne 0 ]; then
  echo "Error: Failed to extract AnyBase."
  exit 1
fi

# Step 1.3 Clean up the downloaded archive
rm -f /tmp/AnyBase.zip
echo "Cleaning up..."
echo "Extraction complete."

# Step 2.1: Download Player Settings
echo "Downloading Player Settings from $PLAYER_SETTINGS_URL..."
wget -q -O /tmp/PlayerSettings.zip "$PLAYER_SETTINGS_URL"

if [ $? -ne 0 ]; then
  echo "Error: Failed to download PlayerSettings. Please check the PLAYER_SETTINGS_URL."
  exit 1
fi

echo "Download complete."

# Step 2.2: Unarchive the PlayerSettings file
echo "Extracting PlayerSettings..."
unzip -qo /tmp/PlayerSettings.zip -d "$SERVER_DIR"

if [ $? -ne 0 ]; then
  echo "Error: Failed to extract PlayerSettings."
  exit 1
fi

# Step 2.3: Clean up the downloaded archive
rm -f /tmp/PlayerSettings.zip
echo "Cleaning up..."
echo "Extraction complete."

# Step 3.1: Download Menu Manager
echo "Downloading Menu Manager from $MENU_MANAGER_URL..."
wget -q -O /tmp/MenuManager.zip "$MENU_MANAGER_URL"

if [ $? -ne 0 ]; then
  echo "Error: Failed to download MenuManager. Please check the MENU_MANAGER_URL."
  exit 1
fi

echo "Download complete."

# Step 3.2: Unarchive the MenuManager file
echo "Extracting MenuManager..."
unzip -qo /tmp/MenuManager.zip -d "$SERVER_DIR"

if [ $? -ne 0 ]; then
  echo "Error: Failed to extract MenuManager."
  exit 1
fi

# Step 3.3: Clean up the downloaded archive
rm -f /tmp/MenuManager.zip
echo "Cleaning up..."
echo "Extraction complete."

# Step 4.1: Download Simple Admin
echo "Downloading Simple Admin from $SIMPLE_ADMIN_URL..."
wget -q -O /tmp/SimpleAdmin.zip "$SIMPLE_ADMIN_URL"

if [ $? -ne 0 ]; then
  echo "Error: Failed to download SimpleAdmin. Please check the SIMPLE_ADMIN_URL."
  exit 1
fi

echo "Download complete."

# Step 4.2: Unarchive the SimpleAdmin file
echo "Extracting SimpleAdmin..."
unzip -qo /tmp/SimpleAdmin.zip -d "$SERVER_DIR/addons"

if [ $? -ne 0 ]; then
  echo "Error: Failed to extract SimpleAdmin."
  exit 1
fi

# Step 4.3: Clean up the downloaded archive
rm -f /tmp/SimpleAdmin.zip
echo "Cleaning up..."
echo "Extraction complete."

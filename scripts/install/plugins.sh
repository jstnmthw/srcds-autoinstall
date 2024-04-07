#!/bin/bash -e

# Container argument
CONTAINER="/servers/${1}"

# Game argument
GAME="${2}"

# Config Name argument
CONFIG_NAME="${3}"

# Instance folder
INSTANCE_DIR="serverfiles/$GAME"

# Server addons directory
AMXMODX_DIR="$INSTANCE_DIR/addons/amxmodx"

# Check if wget is installed
if ! command -v wget &> /dev/null; then
    echo "Error: wget is not installed. Please install wget and try again."
    exit 1
fi

# Move plugins to the serverfiles directory
echo "Info: Moving plugins to $AMXMODX_DIR..."
cp -r /src/plugins/${GAME}/* $AMXMODX_DIR/plugins

# Move configs to the serverfiles directory
echo "Info: Moving plugins configs to $AMXMODX_DIR/configs..."
cp /src/config/${GAME}/${CONFIG_NAME}/plugins.ini $AMXMODX_DIR/configs/plugins.ini

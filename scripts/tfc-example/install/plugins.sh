#!/bin/bash -e

# Container argument
CONTAINER="/servers/${1}"

# Game argument
GAME="${2}"

# Config Name argument
CONFIG_NAME="${3}"

# Mod Type
MOD_TYPE="${4}"

# Instance folder
INSTANCE_DIR="serverfiles/$GAME"

# Server addons directory
MOD_DIR="$INSTANCE_DIR/addons/$MOD_TYPE"

# Move plugins to the serverfiles directory
echo "Info: Moving plugins to $MOD_DIR..."
cp -r /plugins/${GAME}/${CONFIG_NAME}/. $MOD_DIR/plugins

# Move configs to the serverfiles directory
# TODO: Other mods might not have the same structure or name
echo "Info: Moving plugins configs to $MOD_DIR/configs..."
cp /config/${GAME}/${CONFIG_NAME}/plugins.ini $MOD_DIR/configs/plugins.ini

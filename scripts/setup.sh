#!/bin/bash -e

# Game argument
GAME="${1}"
if [ -z "$GAME" ]; then
    echo "Error: Game argument not passed!"
    exit 1
fi

# Config Name argument
CONFIG_DIR="${2}"
if [ -z "$CONFIG_DIR" ]; then
    echo "Error: Config directory argument not passed!"
    exit 1
fi

# Instance folder
INSTANCE_DIR="serverfiles/$GAME"

# Disable the default server.cfg file
if [ -f "$INSTANCE_DIR/server.cfg" ]; then
    echo "Info: Disabling default server.cfg file..."
    mv $INSTANCE_DIR/server.cfg $INSTANCE_DIR/server.cfg.disabled
fi

# Backup old mapcycle.txt file
if [ -f "$INSTANCE_DIR/mapcycle.txt" ]; then
    echo "Info: Backing up old mapcycle.txt file..."
    mv $INSTANCE_DIR/mapcycle.txt $INSTANCE_DIR/mapcycle.txt.bak
fi

# Use mapcycle for amx_mapmenu
if [ -f "$INSTANCE_DIR/addons/amxmodx/configs/maps.ini" ]; then
    echo "Info: Disabling amxmodx maps.ini..."
    mv $INSTANCE_DIR/addons/amxmodx/configs/maps.ini $INSTANCE_DIR/addons/amxmodx/configs/maps.ini.bak
fi

# Copy the linuxgsm config file to the serverfiles directory
echo "Info: Copying linuxgsm config file..."
cp -f /config/$GAME/$CONFIG_DIR/lgsm.cfg /data/config-lgsm/${GAME}server/${GAME}server.cfg

# Copy the mapcycle.txt file to the serverfiles directory
echo "Info: Copying mapcycle.txt file..."
cp -f /config/$GAME/$CONFIG_DIR/mapcycle.txt $INSTANCE_DIR/mapcycle.txt

# Declare the config files to copy
declare -A files=(
    ["server.cfg"]="/${GAME}server.cfg"
    ["motd.txt"]="/motd.txt"
    ["users.ini"]="/addons/amxmodx/configs/users.ini"
    ["amxx.cfg"]="/addons/amxmodx/configs/amxx.cfg"
    ["foxbot.cfg"]="/addons/foxbot/tfc/foxbot.cfg"
    ["botnames.txt"]="/addons/foxbot/tfc/foxbot_names.txt"
)

# Copy the server config files to the serverfiles directory
for key in "${!files[@]}"; do
    echo "Info: Copying $key file..."
    if [ ! -d "$INSTANCE_DIR$(dirname ${files[$key]})" ]; then
        echo "Warning: folder does not exist for $key file. Is plugin installed?"
    else
        cp -f /config/$GAME/$CONFIG_DIR/$key $INSTANCE_DIR${files[$key]}
    fi
done

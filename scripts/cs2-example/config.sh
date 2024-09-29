#!/bin/bash -e

# Config Name argument
CONFIG_DIR="cs2"

# Instance folder
INSTANCE_DIR="/data/serverfiles/game/csgo"
LINUXGSM_CFG="/data/config-lgsm/cs2server"

# Files to process with their target paths
FILES=(
    "linuxgsm.cfg:$LINUXGSM_CFG/cs2server.cfg"
    "cs2server.cfg:$INSTANCE_DIR/cfg/cs2server.cfg"
    "gamemode_casual_server.cfg:$INSTANCE_DIR/cfg/gamemode_casual_server.cfg"
    "mapcycle.txt:$INSTANCE_DIR/mapcycle.txt"
    "CS2-SimpleAdmin.json:$INSTANCE_DIR/addons/counterstrikesharp/plugins/CS2-SimpleAdmin/CS2-SimpleAdmin.json"
)

for FILE_PAIR in "${FILES[@]}"; do
    IFS=":" read -r FILE TARGET_PATH <<< "$FILE_PAIR"
    SOURCE_FILE="/config/$CONFIG_DIR/$FILE"
    
    if [ -f "$SOURCE_FILE" ]; then
        if [ -f "$TARGET_PATH" ]; then
            echo "Info: Backing up $FILE file..."
            mv $TARGET_PATH $TARGET_PATH.old
        fi
        echo "Info: Copying $FILE file..."
        cp -f $SOURCE_FILE $TARGET_PATH
    else
        echo "Error: $FILE file not found in /config/$CONFIG_DIR."
    fi
done

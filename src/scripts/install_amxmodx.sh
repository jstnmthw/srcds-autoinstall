#!/bin/bash -e

# Container argument
CONTAINER="/servers/${1}"

# Game argument
GAME="${2}"

# AMX Mod X download URL
AMXMODX_URL="http://www.amxmodx.org/release/amxmodx-1.8.2-base-linux.tar.gz"

# Build directory
BUILD_DIR="/build"

# Instance folder
INSTANCE_DIR="serverfiles/$GAME"

# Server addons directory
ADDONS_DIR="$INSTANCE_DIR/addons"

# Check if wget is installed
if ! command -v wget &> /dev/null; then
    echo "Error: wget is not installed. Please install wget and try again."
    exit 1
fi

# Check game argument is passed
if [ -z "$GAME" ]; then
    echo "Error: Game argument not passed!"
    exit 1
fi

# AMX Team Fortress Classic Addon
if [ "$GAME" == "tfc" ]; then
    AMXMODX_ADDON_URL="http://www.amxmodx.org/release/amxmodx-1.8.2-tfc-linux.tar.gz"
else 
    # If the game is not supported, exit
    echo "Error: Game $GAME not supported."
    echo "Error: Supported games: tfc"
    exit 1
fi

# Start message
echo "Info: Installing AMX Mod X for $GAME..."

# Check if the amxmodx directory exists
echo "Info: Recreating amxmodx build directory..."
mkdir -p "$BUILD_DIR/amxmodx"

# Download the amxmodx file and extract it
echo "Info: Downloading amxmodx base files..."
wget -qO- $AMXMODX_URL | tar --strip-components=2 -xz -C $BUILD_DIR/amxmodx || { echo "Error: Error downloading amxmodx base files."; exit 1; }

# Download the amxmodx addon file and extract it
echo "Info: Downloading amxmodx ${GAME} addon files..."
wget -qO- $AMXMODX_ADDON_URL | tar --strip-components=2 -xz -C $BUILD_DIR/amxmodx || { echo "Error: Error downloading amxmodx ${GAME} addon files."; exit 1; }

# Copy the metamod files to the container's serverfiles
if [[ ! -d "$ADDONS_DIR/amxmodx" ]]; then
    echo "Info: Directory $ADDONS_DIR/amxmodx does not exist, creating..."
    mkdir -p $ADDONS_DIR/amxmodx
else
    echo "Info: Directory $ADDONS_DIR/amxmodx exists, removing all contents..."
    rm -rf $ADDONS_DIR/amxmodx/*
fi

# Copy the amxmodx files to the serverfiles directory
echo "Info: Copying amxmodx files to $ADDONS_DIR..."
cp -r $BUILD_DIR/amxmodx/* $ADDONS_DIR/amxmodx

# Check if plugins.ini file exits in the addons/metamod directory, if not create it otherwise, append the amxmodx plugin
if [[ ! -f "$ADDONS_DIR/metamod/plugins.ini" ]]; then
    echo "Info: File $ADDONS_DIR/metamod/plugins.ini not found, creating..."
    touch $ADDONS_DIR/metamod/plugins.ini
fi

# Append the amxmodx plugin to the plugins.ini file
echo "Info: File $ADDONS_DIR/metamod/plugins.ini found, appending..."

# If amxmodx is not already in plugins.ini, add it
if ! grep -q "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" $ADDONS_DIR/metamod/plugins.ini; then
    echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" >> $ADDONS_DIR/metamod/plugins.ini
fi

# Clean up build folder
echo "Info: Cleaning up build directory..."
rm -rf $BUILD_DIR/amxmodx

# Display success message
echo "Info: AMX Mod X installed successfully!"

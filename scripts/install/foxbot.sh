#!/bin/bash -e

# Container argument
CONTAINER="/servers/${1}"

# FoxBot download URL
FOXBOT_URL="https://github.com/APGRoboCop/foxbot/releases/download/v0.87-beta1/foxbot_087-b1.zip"

# Build directory
BUILD_DIR="/build"

# Instance folder
INSTANCE_DIR="serverfiles/tfc"

# Server addons directory
ADDONS_DIR="$INSTANCE_DIR/addons"

# Check if wget is installed
if ! command -v wget &> /dev/null; then
    echo "Error: wget is not installed. Please install wget and try again."
    exit 1
fi

# Check instance dir otherwise throw an error and exit
if [[ ! -d "$INSTANCE_DIR" ]]; then
    echo "Error: Instance directory $INSTANCE_DIR not found."
    echo "Error: FoXBot can only be installed on Team Fortress Classic."
    exit 1
fi

# Start message
echo "Info: Installing FoXBot for Team Fortress Classic..."

# Check if the foxbot directory exists
echo "Info: Recreating FoXBot build directory..."
mkdir -p "$BUILD_DIR/foxbot"

# Download the foxbot zip file and extract it
echo "Info: Downloading FoXBot files..."
wget -qO $BUILD_DIR/foxbot.zip $FOXBOT_URL

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Error: Error downloading FoXBot files."
    exit 1
else
    unzip -o $BUILD_DIR/foxbot.zip -d $BUILD_DIR/foxbot > /dev/null 2>&1
    rm $BUILD_DIR/foxbot.zip
fi

# Copy specific files to the serverfiles directory
echo "Info: Copying FoXBot files to $ADDONS_DIR..."
mkdir -p $ADDONS_DIR/foxbot
cp -r $BUILD_DIR/foxbot/addons/foxbot/* $ADDONS_DIR/foxbot

# Check if plugins.ini file exits in the addons/metamod directory, if not create it otherwise, append the FoxBot plugin
if [[ ! -f "$ADDONS_DIR/metamod/plugins.ini" ]]; then
    echo "Info: File $ADDONS_DIR/metamod/plugins.ini not found, creating..."
    touch $ADDONS_DIR/metamod/plugins.ini
fi

# Append FoxBot plugin to plugins.ini
echo "Info: File $ADDONS_DIR/metamod/plugins.ini found, appending..."

# If FoXBot is not already in the plugins.ini file, add it
if ! grep -q "foxbot" $ADDONS_DIR/metamod/plugins.ini; then
    echo "linux addons/foxbot/foxbot.so" >> $ADDONS_DIR/metamod/plugins.ini
fi

# Clean up the build directory
echo "Info: Cleaning up build directory..."
rm -rf $BUILD_DIR/foxbot

# Display success message
echo "Info: FoxBot installed successfully!"

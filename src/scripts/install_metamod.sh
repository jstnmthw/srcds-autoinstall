#!/bin/bash -e

# Container argument
CONTAINER="/servers/${1}"

# Metamod download URL
METAMOD_URL="http://prdownloads.sourceforge.net/metamod/metamod-1.20-linux.tar.gz"

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

# Recreate the metamod build directory
echo "Info: Recreating metamod build directory..."
mkdir -p "$BUILD_DIR/metamod"

# Download the metamod file and extract it
echo "Info: Downloading metamod files..."
wget -qO- $METAMOD_URL | tar xz -C $BUILD_DIR/metamod || { echo "Error: Error downloading metamod files."; exit 1; }

# Copy the metamod files to the serverfiles directory
echo "Info: Copying metamod files to $ADDONS_DIR..."
mkdir -p $ADDONS_DIR/metamod/dlls
cp -r $BUILD_DIR/metamod/* $ADDONS_DIR/metamod/dlls

# Check if liblist.gam exists
if [[ ! -f "$INSTANCE_DIR/liblist.gam" ]]; then
    echo "Info: File liblist.gam not found!"
    exit 1
else
    echo "Info: File liblist.gam found!"
fi

# Uncomment the line for HldsUpdateTool
# sed -i 's|gamedll_linux "dlls/tfc_i386.so"|gamedll_linux "addons/metamod/dlls/metamod_i386.so"|g' $INSTANCE_DIR/liblist.gam

# Uncomment the line forsteamcmd
echo "Info: Replacing gamedll_linux in liblist.gam..."

# Only add if dlls/tfc.so is not already there
sed -i 's|gamedll_linux "dlls/tfc.so"|gamedll_linux "addons/metamod/dlls/metamod.so"|g' $INSTANCE_DIR/liblist.gam

# Clean up the build directory
echo "Info: Cleaning up build directory..."
rm -rf $BUILD_DIR/metamod

# Print a success message
echo "Info: Metamod installed successfully!"

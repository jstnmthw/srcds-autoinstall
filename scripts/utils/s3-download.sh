#!/bin/bash -e

# Set the required environment variables
S3_BUCKET="archive-6"
S3_FILE_PATH="gameservers"
S3_FILE="cs.configs.tar.gz"
CONFIG_DIR="~/srcds-autoinstall/config"

echo "Downloading config files from S3..."

# Use AWS CLI command to download the file from S3
aws s3 cp s3://$S3_BUCKET/$S3_FILE_PATH/$S3_FILE /tmp/$S3_FILE

echo "File downloaded successfully."

# Get the file extension
file_extension="${S3_FILE##*.}"
file_base_name=$(basename $S3_FILE .${file_extension})
second_extension="${file_base_name##*.}"

# Check if the file is a zip or tar file
if [ "$file_extension" = "zip" ]; then
    echo "Unzipping the file..."
    unzip -o /tmp/$S3_FILE -d ./
elif [ "$second_extension" = "tar" ]; then
    echo "Untarring the file..."
    tar -xvf /tmp/$S3_FILE -C ./
else
    echo "Error: The file is not a zip or tar file."
    exit 1
fi

rm /tmp/$S3_FILE

echo "File extraction completed successfully."

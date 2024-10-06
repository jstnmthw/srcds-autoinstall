#!/bin/bash -e

S3_FILE=cs.configs.tar.gz
S3_BUCKET=archive-6
S3_FILE_PATH=gameservers

echo "Uploading file to S3..."

# Create a tarball of the game server files
make pack

# Use AWS CLI command to upload the file to S3
if ! aws s3 cp /tmp/${S3_FILE} s3://${S3_BUCKET}/${S3_FILE_PATH}/${S3_FILE}; then
    echo "Error: Failed to upload file to S3. Please check your S3 bucket and file path."
    exit 1
else
    rm -rf /tmp/${S3_FILE}
    echo "File uploaded successfully."
fi
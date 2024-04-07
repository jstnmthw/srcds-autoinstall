#!/bin/bash -e

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install AWS CLI and try again."
    exit 1
fi

# Set AWS region and credentials
export AWS_REGION="your-region"
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"

# Define S3 bucket and file path
S3_BUCKET="your-bucket"
S3_FILE_PATH="your-file-path"

# Local file path
LOCAL_FILE_PATH="your-local-file-path"

# Use AWS CLI command to download the file from S3
if ! aws s3 cp s3://${S3_BUCKET}/${S3_FILE_PATH} ${LOCAL_FILE_PATH}; then
    echo "Error: Failed to download file from S3. Please check your S3 bucket and file path."
    exit 1
fi

echo "File downloaded successfully."
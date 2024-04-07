#!/bin/bash -e

# Load environment variables from .env file
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not found. Please create a .env file with your settings."
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install AWS CLI and try again."
    exit 1
fi

# Define an array with the names of the required environment variables
required_env_vars=(
    "S3_BUCKET" 
    "S3_FILE_PATH" 
    "LOCAL_FILE_PATH" 
    "AWS_REGION" 
    "AWS_ACCESS_KEY_ID" 
    "AWS_SECRET_ACCESS_KEY"
)

# Check if the required environment variables are set
for var_name in "${required_env_vars[@]}"; do
    if [[ -z "${!var_name}" ]]; then
        echo "Error: $var_name environment variable is not set. Please check your .env file."
        exit 1
    fi
done

# Use AWS CLI command to download the file from S3
if ! aws s3 cp s3://${S3_BUCKET}/${S3_FILE_PATH} ${LOCAL_FILE_PATH}; then
    echo "Error: Failed to download file from S3. Please check your S3 bucket and file path."
    exit 1
fi

echo "File downloaded successfully."
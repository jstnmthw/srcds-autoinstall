#!/bin/bash -e

# Define an array with the names of the required environment variables
required_env_vars=(
    "S3_BUCKET"
    "S3_FILE_PATH"
    "S3_FILE"
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

# Check if aws cli is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install AWS CLI and attempting to install it now."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
else
    echo "AWS CLI is already installed. Continuing..."
fi

echo "Uploading file to S3..."

# Set AWS credentials
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_REGION

if [[ -d $BACKUP_PATH ]] && [[ -n $BACKUP_PATH ]]; then
    # Create a tarball of the backup directory
    tar -czf /tmp/${S3_FILE} $BACKUP_PATH

    # Use AWS CLI command to upload the file to S3
    if ! aws s3 cp /tmp/${S3_FILE} s3://${S3_BUCKET}/${S3_FILE_PATH}/${S3_FILE}; then
        echo "Error: Failed to upload file to S3. Please check your S3 bucket and file path."
        exit 1
    else
        rm -rf /tmp/${S3_FILE}
        echo "File uploaded successfully."
    fi
else
    echo "Error: Backup path is not set or does not exist. Please check your .env file."
    exit 1
fi

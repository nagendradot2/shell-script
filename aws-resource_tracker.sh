#!/bin/bash

# Improved AWS Resource Tracker Script

# Start logging
LOG_FILE="aws_resource_tracker.log"
exec > >(tee -i $LOG_FILE) 2>&1

# Function to log messages
log_message() {
    local MESSAGE="$(date +'%Y-%m-%d %H:%M:%S') - $1"
    echo $MESSAGE
}

# Error handler
handle_error() {
    log_message "Error on line $1"
    exit 1
}

# Trap errors
trap 'handle_error $LINENO' ERR

# Set AWS profile and region
AWS_PROFILE="default"
AWS_REGION="us-west-2"

log_message "Starting AWS Resource Tracker"

# Get a list of all AWS resources
resources=$(aws ec2 describe-instances --profile $AWS_PROFILE --region $AWS_REGION --query 'Reservations[].Instances[].{ID: InstanceId, State: State.Name}' --output json)

if [ $? -ne 0 ]; then
    log_message "Error retrieving AWS resources"
    exit 1
fi

# Save resources to output file
OUTPUT_FILE="aws_resources.json"

echo $resources > $OUTPUT_FILE
log_message "AWS resources saved to $OUTPUT_FILE"

# Example: Print to console
log_message "List of AWS Resources:" 
cat $OUTPUT_FILE

log_message "AWS Resource Tracking completed successfully!"
#!/bin/bash

# Stack names matching your deployment script
STACK_NAMES=("NBAApiLambdaStack" "SecretsManagerStack" "SNSStack" "EventBridgeStack")
REGION="us-east-1"

echo "Deleting CloudFormation stacks..."

# Loop through each stack and delete
for stack in "${STACK_NAMES[@]}"; do
    echo "Deleting stack: $stack"
    aws cloudformation delete-stack --stack-name $stack --region $REGION
    
    # Wait for the stack to be deleted
    echo "Waiting for stack $stack to be deleted..."
    aws cloudformation wait stack-delete-complete --stack-name $stack --region $REGION
done

echo "All stacks have been deleted successfully."
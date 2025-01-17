#!/bin/bash

STACK_NAME="NBAApiLambdaStack"
TEMPLATE_FILE="s3_bucket_lambda.yaml"
REGION="us-east-1"

echo "Deploying CloudFormation stack..."

aws cloudformation deploy \
    --template-file $TEMPLATE_FILE \
    --stack-name $STACK_NAME \
    --region $REGION \
    --capabilities CAPABILITY_NAMED_IAM

echo "Deployment completed successfully."
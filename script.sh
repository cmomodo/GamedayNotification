#!/bin/bash

STACK_NAMES=("NBAApiLambdaStack" "SecretsManagerStack" "SNSStack" "EventBridgeStack")
TEMPLATE_FILES=("s3_bucket_lambda.yaml" "systems_manager.yaml" "sns.yaml" "eventbrige.yaml")
REGION="us-east-1"

echo "Deploying CloudFormation stacks..."

for i in "${!STACK_NAMES[@]}"; do
    echo "Deploying stack: ${STACK_NAMES[$i]} with template: ${TEMPLATE_FILES[$i]}"
    aws cloudformation deploy \
        --template-file ${TEMPLATE_FILES[$i]} \
        --stack-name ${STACK_NAMES[$i]} \
        --region $REGION \
        --capabilities CAPABILITY_NAMED_IAM
done

echo "Deployment completed successfully."
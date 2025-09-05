#!/bin/bash
# AWS Audit Manager Complete Deployment Script
# This script guides you through the entire setup process

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}==========================================="
echo -e "AWS AUDIT MANAGER DEPLOYMENT SCRIPT"
echo -e "===========================================${NC}"

# Step 1: Collect configuration values
echo -e "${YELLOW}Step 1: Configuration Setup${NC}"
echo "Please provide the following information:"

read -p "Company Name (no spaces, alphanumeric only): " COMPANY_NAME
read -p "Your Email Address: " NOTIFICATION_EMAIL  
read -p "Environment (prod/dev/staging): " ENVIRONMENT_NAME
read -p "AWS Region: " AWS_REGION
read -p "AWS Account ID: " AWS_ACCOUNT_ID

# Validate inputs
if [[ -z "$COMPANY_NAME" || -z "$NOTIFICATION_EMAIL" || -z "$ENVIRONMENT_NAME" || -z "$AWS_REGION" || -z "$AWS_ACCOUNT_ID" ]]; then
    echo -e "${RED}Error: All fields are required${NC}"
    exit 1
fi

echo -e "${GREEN}Configuration saved:${NC}"
echo "Company: $COMPANY_NAME"
echo "Email: $NOTIFICATION_EMAIL"
echo "Environment: $ENVIRONMENT_NAME"
echo "Region: $AWS_REGION"
echo "Account: $AWS_ACCOUNT_ID"

# Step 2: Set AWS CLI region
echo -e "${YELLOW}Step 2: Setting up AWS CLI${NC}"
aws configure set region $AWS_REGION

# Verify AWS credentials
echo "Verifying AWS credentials..."
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo -e "${RED}Error: AWS credentials not configured. Run 'aws configure' first.${NC}"
    exit 1
fi
echo -e "${
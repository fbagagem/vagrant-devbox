#!/usr/bin/env bash

echo "######################################################################"
echo "Configuring AWS tools... #############################################"
echo "######################################################################"

# AWS CLI
# https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

# AWS SAM
# https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-additional.html#serverless-sam-cli-install-using-pip

ACCESS_KEY_ID="$1"
SECRET_ACCESS_KEY="$2"
REGION="$3"

# Update credentials and configurations from yaml
sed -i "s/REPLACE_ME_ACCESS_KEY/$ACCESS_KEY_ID/g" ~/.aws/credentials
sed -i "s/REPLACE_ME_SECRET_ACCESS_KEY/$SECRET_ACCESS_KEY/g" ~/.aws/credentials
sed -i "s/REPLACE_ME_REGION/$REGION/g" ~/.aws/config

echo "Done."
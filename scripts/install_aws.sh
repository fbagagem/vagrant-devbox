#!/usr/bin/env bash

echo "######################################################################"
echo "Installing AWS tools... ##############################################"
echo "######################################################################"

# AWS CLI
# https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

# AWS SAM
# https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-additional.html#serverless-sam-cli-install-using-pip

if aws --version 2>&1 | grep -q "aws-cli" ; then
	echo "AWS CLI already installed:"
	aws --version
	sam --version
else
	sudo apt-get update
	sudo apt-get install -y -q build-essential
	# AWS CLI and SAM CLI are both installed under the path ~/.local/bin 
	export PATH=~/.local/bin:$PATH
	
	# AWS CLI installation
	pip3 install awscli --upgrade
	
	# AWS SAM CLI installation
	pip3 install aws-sam-cli --upgrade
fi

echo "Done."
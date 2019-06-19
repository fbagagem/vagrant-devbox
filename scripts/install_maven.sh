#!/usr/bin/env bash

echo "######################################################################"
echo "Installing Maven... ##################################################"
echo "######################################################################"

if mvn --version 2>&1 | grep -q "Apache Maven" ; then
	echo "Maven already installed:"
	mvn --version
else
	sudo apt-get update
	sudo apt-get install -y -qq maven
fi

echo "Done."
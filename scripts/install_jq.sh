#!/usr/bin/env bash

echo "######################################################################"
echo "Installing JQ... #####################################################"
echo "######################################################################"

if jq 2>&1 | grep -q "jq - commandline JSON processor" ; then
	echo "JQ already installed"
else
	sudo apt-get update
	sudo apt-get install -y -qq jq
fi

echo "Done."
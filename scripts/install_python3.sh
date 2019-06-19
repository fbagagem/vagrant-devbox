#!/usr/bin/env bash

echo "######################################################################"
echo "Installing Python3/pip3... ###########################################"
echo "######################################################################"

if which pip3 2>&1 | grep -q "/usr/bin/pip3" ; then
	echo "Python3 and pip3 already installed:"
	pip3 --version
else
	sudo apt-get update
	sudo apt-get install -y -qq python3-distutils
	sudo apt-get install -y -qq python3-pip
	
	sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
fi

echo "Done."
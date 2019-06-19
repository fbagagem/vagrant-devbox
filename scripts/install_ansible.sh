#!/usr/bin/env bash

echo "######################################################################"
echo "Installing Ansible... ################################################"
echo "######################################################################"

if ansible 2>&1 | grep -q "Usage: ansible" ; then
	echo "Ansible already installed:"
	ansible --version
else
	sudo apt-get update
	sudo apt-get install -y -qq software-properties-common 
	sudo add-apt-repository -y ppa:ansible/ansible
	sudo apt-get update
	sudo apt-get install -y -qq ansible
fi

echo "Done."
#!/usr/bin/env bash

echo "######################################################################"
echo "Installing Docker... ##################################################"
echo "######################################################################"

if docker --version 2>&1 | grep -q "Docker version" ; then
	echo "Docker already installed:"
	docker --version
else
	# Setup docker using the official docker installation script
	wget -qO- https://get.docker.com/ | sh
	
	# Add user "vagrant" to the group "docker"
	# https://techoverflow.net/2017/03/01/solving-docker-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket/
	sudo usermod -a -G docker vagrant
fi

if docker-compose --version 2>&1 | grep -q "docker-compose version" ; then
	echo "Docker Compose already installed:"
	docker-compose --version
else
	COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | tail -n 1`
	sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
	sudo chmod +x /usr/local/bin/docker-compose
	sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
fi

echo "Done."
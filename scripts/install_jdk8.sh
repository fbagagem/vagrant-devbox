#!/usr/bin/env bash

echo "######################################################################"
echo "Installing Java (JDK8)... ############################################"
echo "######################################################################"

# Oracle JDK License was updated on April 16th 2019, and we are no longer allowed to install it automatically. 
# Details: https://www.oracle.com/technetwork/java/javase/overview/oracle-jdk-faqs.html
# 
# This way, we moved forward to use OpenJDK8

if java -version 2>&1 | grep -q "openjdk version" ; then
	echo "Java already installed:"
	java -version
else
	sudo apt-get update
	sudo apt-get install -y -qq openjdk-8-jdk
	sudo update-java-alternatives --set java-1.8.0-openjdk-amd64
fi

echo "Done."
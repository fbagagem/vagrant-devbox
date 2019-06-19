# -*- mode: ruby -*-
# vi: set ft=ruby :

confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))
provisioningYamlPath = confDir + "/provisioning.yaml"
beforeScriptPath = confDir + "/scripts/before.sh"
afterScriptPath = confDir + "/scripts/after.sh"
aliasesPath = confDir + "/aliases"

require File.expand_path(File.dirname(__FILE__) + '/scripts/bricklayer.rb')

Vagrant.require_version '>= 2.2.4'

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
	
	# Copy the file "aliases" to the VM.
	# This file includes all aliases to be appended to the vagrant user context	
	if File.exist? aliasesPath then
    config.vm.provision "file", source: aliasesPath, destination: "/tmp/bash_aliases"
	else
		abort "Aliases file not found in #{confDir}"
  end
	
	# Execute a pre-provisioning bash script.
	# Example: setup aliases to vagrant user
	if File.exist? beforeScriptPath then
		config.vm.provision "shell", path: beforeScriptPath, privileged: false, keep_color: true
	end
	
	if File.exist? provisioningYamlPath then
		settings = YAML::load(File.read(provisioningYamlPath))
	else
		abort "YAML custom settings file not found in #{confDir}"
	end

	Bricklayer.configure(config, settings)
	
	# Execute a post-provisioning bash script. 
	# This script will be executed after the machine is up and running, ready to work.
	# Example: startup scripts, pull data from GIT, etc
	if File.exist? afterScriptPath then
		config.vm.provision "shell", path: afterScriptPath, privileged: false, keep_color: true
	end
end

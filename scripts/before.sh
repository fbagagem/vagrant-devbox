#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run BEFORE the machine is provisioned.

# Set a list of aliases dynamicaly, based on a configuration file
# The file /tmp/bash_aliases will be moved to the vagrant user home directory.
echo "Updating aliases..."
awk '{ sub("\r$", ""); print }' /tmp/bash_aliases > /home/vagrant/.bash_aliases
echo "Done."
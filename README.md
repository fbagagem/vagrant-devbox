# Development Environment

In order to avoid spending too much time configuring the environment for development purposes, we felt the need to 
automate the creation of a virtual machine with all required tools.

Currently, the virtual machine is bundled with the following tools:
* Java (JDK8)
* Maven
* Ansible
* Docker
* GIT
* JQ

## Getting started

These instructions will get you a copy of the linux machine (distro ubuntu/bionic64) and perform required 
configurations for development and testing purposes.

### Prerequisites

What you need to have installed **before** running the script:
* Virtualbox [download and install from https://www.virtualbox.org/wiki/Downloads]
* Vagrant [download and install from https://www.vagrantup.com/downloads.html]
* Git bash [comes bundled with Git; as an alternative, Powershell may be used]

Also, make sure Hyper-V is **disabled**. In order to do so, follow these steps:
1. Start typing "Turn Windows features on or off" in the Windows Start menu and open the best match result
2. In the "Windows Features" window, search within the list for "Hyper-V" and de-select it (as well as all its child options)

### Configuration setup

Open the file provisioning.yaml and update the following properties:

#### Shared folders
Update the _folders/map_ directory with your machine's path (please don't change the path in the _to_):
``` yaml
folders:
    - map: D:\Projects\CIOT\git
      to: /home/vagrant/code
```

#### GIT
Under _git_ section, update the fields: _user_name_ and _user_email_:
``` yaml
git:
    user_name: "john.doe"
    user_email: "john.doe@mail.com"
```

#### AWS tools
Under _aws_ section, update the fields _access_key_id_, _secret_access_key_ and _region_:
```
aws:
    access_key_id: "REPLACE_MY_KEY"
    secret_access_key: "REPLACE_THIS_SECRET"
    region: "CHANGE_ME"
```

If you want to use AWS tools (CLI and SAM), you need to have an AWS account. If you haven't created one yet, please do it at https://aws.amazon.com.
Once you have created it, navigate to your account details and go to "My Security Credentials"; in there, you are able to manage "Access keys for CLI, SDK, & API access".

The region, if set to "EU (Ireland)", should be set to "eu-west-1" (check the full region codes list here: https://docs.aws.amazon.com/general/latest/gr/rande.html)

Example:
```
aws:
    access_key_id: "AKIA5S5BAP_REPLACEME"
    secret_access_key: "UEFl5LnkdkajhdDV6XT97PfUzZSGLVYK_REPLACEME"
    region: "eu-west-1"
```

### Running the script

Open Gitbash and go to the directory where you cloned this repo:

```
$ cd /d/Projects/git/dev-box
```

Start the Vagrant box by typing:
```
$ vagrant.exe up --provision
```
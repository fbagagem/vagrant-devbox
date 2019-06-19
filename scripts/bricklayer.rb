# Main Bricklayer Class
class Bricklayer
  def self.configure(config, settings)
		# Set The VM Provider
    ENV['VAGRANT_DEFAULT_PROVIDER'] = settings['provider'] ||= 'virtualbox'

    # Configure Local Variable To Access Scripts From Remote Location
    script_dir = File.dirname(__FILE__)

    # Allow SSH Agent Forward from The Box
    config.ssh.forward_agent = true
		
		# Configure The Box
    config.vm.define settings['name'] ||= 'sandbox'
    config.vm.box = settings['box'] ||= 'ubuntu/bionic64'
    config.vm.box_version = settings['version'] ||= '>= 0'
    config.vm.hostname = settings['hostname'] ||= 'sandbox'

    # Configure A Private Network IP
    if settings['ip'] != 'autonetwork'
      config.vm.network :private_network, ip: settings['ip'] ||= '192.168.10.10'
    else
      config.vm.network :private_network, ip: '0.0.0.0', auto_network: true
    end
		
		# Configure Additional Networks
    if settings.has_key?('networks')
      settings['networks'].each do |network|
        config.vm.network network['type'], ip: network['ip'], bridge: network['bridge'] ||= nil, netmask: network['netmask'] ||= '255.255.255.0'
      end
    end
		
		# Configure A Few VirtualBox Settings
    config.vm.provider 'virtualbox' do |vb|
      vb.name = settings['name'] ||= 'sandbox'
      vb.customize ['modifyvm', :id, '--memory', settings['memory'] ||= '2048']
      vb.customize ['modifyvm', :id, '--cpus', settings['cpus'] ||= '1']
      vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
      vb.customize ['modifyvm', :id, '--natdnshostresolver1', settings['natdnshostresolver'] ||= 'on']
      vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
      if settings.has_key?('gui') && settings['gui']
        vb.gui = true
      end
    end
		
		# Override Default SSH port on the host
		if settings.has_key?('ssh_port_override')
			config.vm.network :forwarded_port, guest: 22, host: settings['ssh_port_override'], auto_correct: false, id: "ssh"
		end
		
		# Standardize Ports Naming Schema
    if settings.has_key?('ports')
      settings['ports'].each do |port|
        port['guest'] ||= port['to']
        port['host'] ||= port['send']
        port['protocol'] ||= 'tcp'
      end
    else
      settings['ports'] = []
    end

    # Add Custom Ports From Configuration
    if settings.has_key?('ports')
      settings['ports'].each do |port|
        config.vm.network 'forwarded_port', guest: port['guest'], host: port['host'], protocol: port['protocol'], auto_correct: true
      end
    end
		
		# Configure The Public Key For SSH Access
    if settings.include? 'authorize'
      if File.exist? File.expand_path(settings['authorize'])
        config.vm.provision 'shell' do |s|
          s.inline = "echo $1 | grep -xq \"$1\" /home/vagrant/.ssh/authorized_keys || echo \"\n$1\" | tee -a /home/vagrant/.ssh/authorized_keys"
          s.args = [File.read(File.expand_path(settings['authorize']))]
        end
      end
    end
		
		# Copy The SSH Private Keys To The Box
    if settings.include? 'keys'
      if settings['keys'].to_s.length.zero?
        puts 'Check your provisioning.yaml file, you have no private key(s) specified.'
        exit
      end
      settings['keys'].each do |key|
        if File.exist? File.expand_path(key)
          config.vm.provision 'shell' do |s|
            s.privileged = false
            s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
            s.args = [File.read(File.expand_path(key)), key.split('/').last]
          end
        else
          puts 'Check your provisioning.yaml file, the path to your private key does not exist.'
          exit
        end
      end
    end
		
		# Register All Of The Configured Shared Folders
    if settings.include? 'folders'
      settings['folders'].each do |folder|
        if File.exist? File.expand_path(folder['map'])
          mount_opts = []

          if folder['type'] == 'nfs'
            mount_opts = folder['mount_options'] ? folder['mount_options'] : ['actimeo=1', 'nolock']
          elsif folder['type'] == 'smb'
            mount_opts = folder['mount_options'] ? folder['mount_options'] : ['vers=3.02', 'mfsymlinks']
          end

          # For b/w compatibility keep separate 'mount_opts', but merge with options
          options = (folder['options'] || {}).merge({ mount_options: mount_opts })

          # Double-splat (**) operator only works with symbol keys, so convert
          options.keys.each{|k| options[k.to_sym] = options.delete(k) }

          config.vm.synced_folder folder['map'], folder['to'], type: folder['type'] ||= nil, **options
        else
          config.vm.provision 'shell' do |s|
            s.inline = ">&2 echo \"Unable to mount one of your folders. Please check your folders in Homestead.yaml\""
          end
        end
      end
    end
		
		# Install Java (JDK8)
		config.vm.provision 'shell' do |s|
			s.path = script_dir + '/install_jdk8.sh'
		end
		
		# Install Maven
		config.vm.provision 'shell' do |s|
			s.path = script_dir + '/install_maven.sh'
		end
		
		# Install Ansible
		config.vm.provision 'shell' do |s|
			s.path = script_dir + '/install_ansible.sh'
		end
		
		# Install Docker
		config.vm.provision 'shell' do |s|
			s.path = script_dir + '/install_docker.sh'
		end
		
		# Install JQ (https://stedolan.github.io/jq/)
		config.vm.provision 'shell' do |s|
			s.path = script_dir + '/install_jq.sh'
		end
		
		# Setup GIT and clone repos
		if settings.has_key?('git')
			# Setup GIT global configurations
			config.vm.provision 'shell' do |s|
				params = Array.new
				params.push settings['git']['user_name']
				params.push settings['git']['user_email']
				s.path = script_dir + '/config_git.sh'
				s.privileged = false
				s.args = params
			end
		end	
	
		# Install Python3 (and pip3)
		config.vm.provision 'shell' do |s|
			s.path = script_dir + '/install_python3.sh'
		end
		
		# Install AWS tools (CLI and SAM)
		config.vm.provision 'shell' do |s|
			s.path = script_dir + '/install_aws.sh'
		end
		
		# Configure AWS tools
		config.vm.provision 'file', source: script_dir + '/config_aws_credentials.properties', destination: '~/.aws/credentials'
		config.vm.provision 'file', source: script_dir + '/config_aws_configurations.properties', destination: '~/.aws/config'
		config.vm.provision 'shell' do |s|
			params = Array.new
			params.push settings['aws']['access_key_id']
			params.push settings['aws']['secret_access_key']
			params.push settings['aws']['region']
			s.path = script_dir + '/config_aws.sh'
			s.privileged = false
			s.args = params
		end
		
	end
end
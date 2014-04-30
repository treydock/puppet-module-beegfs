require 'beaker-rspec'

hosts.each do |host|
  on host, 'rpm -e puppetlabs-release', { :acceptable_exit_codes => [0,1] }
  # Install Puppet
  on host, install_puppet, { :acceptable_exit_codes => [0,1] }
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    install_package(master, 'puppet-server')
    on master, puppet_resource('service', 'puppetmaster', 'ensure=running')

    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'fhgfs')

    hosts.each do |host|
      on host, puppet_resource('host', 'puppet', 'ip=127.0.0.1'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'treydock-gpg_key'), { :acceptable_exit_codes => [0,1] }
      on host, puppet_agent('--test --modulepath /etc/puppet/modules'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
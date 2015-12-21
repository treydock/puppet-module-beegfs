require 'beaker-rspec'

def mgmt_ip
  find_only_one(:mgmt).ip
end

hosts.each do |host|
  if host['platform'] =~ /el-(5|6|7)/
    relver = $1
    on host, "rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-#{relver}.noarch.rpm", { :acceptable_exit_codes => [0,1] }
    on host, 'yum install -y puppet puppet-server', { :acceptable_exit_codes => [0,1] }
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Local settings based on environment variables
  c.add_setting :beegfs_release
  c.beegfs_release = ENV['BEAKER_beegfs_release'] || '2015.03'

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'beegfs')

    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-inifile'), { :acceptable_exit_codes => [0,1] }
      on host, 'yum -y install git'
      on host, 'git clone https://github.com/treydock/puppet-module-fhgfs /etc/puppet/modules/fhgfs'
      on host, puppet('resource service iptables ensure=stopped'), { :acceptable_exit_codes => [0,1] }
    end
  end
end

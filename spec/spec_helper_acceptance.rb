require 'beaker-rspec'

def mgmt_ip
  find_only_one(:mgmt).ip
end

def master_ip
  master.ip
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    on hosts, 'rpm -e puppetlabs-release', { :acceptable_exit_codes => [0,1] }
    install_puppet
    install_package(master, 'puppet-server')
    on master, puppet('resource service puppetmaster ensure=running')

    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'fhgfs')

    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'treydock-gpg_key'), { :acceptable_exit_codes => [0,1] }
      on host, puppet("resource host puppet ip=#{master_ip}"), { :acceptable_exit_codes => [0,1] }
      on host, puppet('agent -t'), :acceptable_exit_codes => [0,1,2]
      on host, puppet('resource service iptables ensure=stopped'), { :acceptable_exit_codes => [0,1] }
      sign_certificate_for(host)
    end

    on hosts, puppet('agent -t'), :acceptable_exit_codes => [0,1,2]
  end
end
require 'beaker-rspec'

def mgmt_ip
  find_only_one(:mgmt).ip
end

hosts.each do |host|
  #install_puppet
  if host['platform'] =~ /el-(5|6)/
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

  # Configure all nodes in nodeset
  c.before :suite do
    puppet_pp = <<-EOF
    ini_setting { 'puppet.conf/main/server':
      ensure  => 'present',
      section => 'main',
      path    => '/etc/puppet/puppet.conf',
      setting => 'server',
      value   => 'puppet.local',
    }
    EOF

    puppet_master_pp = <<-EOF
    ini_setting { 'puppet.conf/master/certname':
      ensure  => 'present',
      section => 'master',
      path    => '/etc/puppet/puppet.conf',
      setting => 'certname',
      value   => 'puppet.local',
    }
    ini_setting { 'puppet.conf/master/autosign':
      ensure  => 'present',
      section => 'master',
      path    => '/etc/puppet/puppet.conf',
      setting => 'autosign',
      value   => true,
    }
    EOF

    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'fhgfs')

    hosts.each do |host|
      # Only modify /etc/hosts if not running under docker
      unless host['hypervisor'] =~ /docker/
        host.exec(Beaker::Command.new("echo '#{master['ip']}\tpuppet.local' >> /etc/hosts"))
      end

      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'treydock-gpg_key'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-inifile'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('resource service iptables ensure=stopped'), { :acceptable_exit_codes => [0,1] }

      apply_manifest_on(host, puppet_pp, :catch_failures => true)
    end

    apply_manifest_on(master, puppet_master_pp, :catch_failures => true)
    apply_manifest_on(master, "service { 'puppetmaster': ensure => running }", :catch_failures => true)

    hosts.each do |host|
      on host, puppet('agent -t'), :acceptable_exit_codes => [0,1,2]
    end
  end
end
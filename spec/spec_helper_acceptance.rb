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
      puppet_pp = <<-EOF
      ini_setting { 'puppet.conf/main/server':
        ensure  => 'present',
        section => 'main',
        path    => '/etc/puppet/puppet.conf',
        setting => 'server',
        value   => 'puppet.local',
      }
      ini_setting { 'puppet.conf/main/certname':
        ensure  => 'present',
        section => 'main',
        path    => '/etc/puppet/puppet.conf',
        setting => 'certname',
        value   => '#{host.name}',
      }
      EOF

      # Only modify /etc/hosts if not running under docker
      #unless host['hypervisor'] =~ /docker/
      if host.name == 'mgmt'
        host.exec(Beaker::Command.new("echo '127.0.0.1\tpuppet.local' >> /etc/hosts"))
      else
        host.exec(Beaker::Command.new("echo '#{mgmt_ip}\tpuppet.local' >> /etc/hosts"))
      end
        #end
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-gcc'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-inifile'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('resource service iptables ensure=stopped'), { :acceptable_exit_codes => [0,1] }

      apply_manifest_on(host, puppet_pp, :catch_failures => true)
    end

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
    apply_manifest_on(master, puppet_master_pp, :catch_failures => true)
    apply_manifest_on(master, "service { 'puppetmaster': ensure => running }", :catch_failures => true)
    sleep(10)

    hosts.each do |host|
      on host, puppet('agent -t'), :acceptable_exit_codes => [0,1,2]
    end
  end
end

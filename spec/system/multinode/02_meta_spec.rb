require 'spec_helper_system_multinode'

describe 'fhgfs::meta class:' do
  context 'should run successfully' do
    pp = <<-EOS
service { 'iptables': ensure => stopped, before => File['/fhgfs'], }
class { 'sudo': purge => false, config_file_replace => false }

file { '/fhgfs':
  ensure  => directory,
}

class { 'fhgfs::meta':
  store_meta_directory  => '/fhgfs/meta',
  mgmtd_host            => 'mgmtd.vm',
  require               => File['/fhgfs'],
}

class { 'zabbix20::agent': manage_firewall => false, }

class { 'fhgfs::client':
  mgmtd_host  => 'mgmtd.vm',
  utils_only  => true,
}

class { 'fhgfs::monitor': monitor_tool => 'zabbix' }
    EOS

    context puppet_apply(:code => pp, :node => 'meta.vm') do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end
end

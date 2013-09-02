require 'spec_helper_system_multinode'

describe 'fhgfs::mgmtd class:' do
  context 'should run successfully' do
    pp = <<-EOS
service { 'iptables': ensure => stopped, before => File['/fhgfs'], }
class { 'sudo': purge => false, config_file_replace => false }

file { '/fhgfs':
  ensure  => directory,
}

class { 'fhgfs::mgmtd':
  store_mgmtd_directory => '/fhgfs/mgmtd',
  require               => File['/fhgfs'],
}->
class { 'fhgfs::admon':
  mgmtd_host  => 'mgmtd.vm',
}

class { 'zabbix20::agent': manage_firewall => false, }

class { 'fhgfs::client':
  mgmtd_host  => 'mgmtd.vm',
  utils_only  => true,
}

class { 'fhgfs::monitor': monitor_tool => 'zabbix' }
    EOS

    context puppet_apply(:code => pp, :node => 'mgmtd.vm') do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end

    describe service('fhgfs-mgmtd'), :node => 'mgmtd.vm' do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('fhgfs-admon'), :node => 'mgmtd.vm' do
      it { should be_enabled }
      it { should be_running }
    end
    
    describe port(8000), :node => 'mgmtd.vm' do
      it { should be_listening }
    end
  end
end

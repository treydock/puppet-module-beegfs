require 'spec_helper_system_multinode'

describe 'fhgfs::client class:' do
  context 'should run successfully' do
    pp = <<-EOS
class { 'sudo': purge => false, config_file_replace => false }

file { '/fhgfs':
  ensure  => directory,
}

class { 'fhgfs::client':
  mgmtd_host => 'mgmtd.vm',
  mount_path  => '/mnt/fhgfs',
}

class { 'zabbix20::agent': manage_firewall => false, }

class { 'fhgfs::monitor': monitor_tool => 'zabbix' }
    EOS

    context puppet_apply(:code => pp, :node => 'client.vm') do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end
end

require 'spec_helper_system_multinode'

describe 'fhgfs::mgmtd class:' do
  context 'should run successfully' do
    pp = <<-EOS
service { 'iptables': ensure => stopped, before => File['/fhgfs'], }

file { '/fhgfs':
  ensure  => directory,
}

class { 'fhgfs::mgmtd':
  service_ensure        => 'running',
  service_enable        => true,
  store_mgmtd_directory => '/fhgfs/mgmtd',
  require               => File['/fhgfs'],
}->
class { 'fhgfs::admon':
  service_ensure  => 'running',
  service_enable  => true,
  mgmtd_host      => 'mgmtd.vm',
}

class { 'fhgfs::client':
  mgmtd_host  => 'mgmtd.vm',
  utils_only  => true,
}
EOS

    context puppet_apply(:code => pp, :node => 'mgmtd.vm') do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end

  context "fhgfs-mgmtd service should be enabled and running" do
    describe service('fhgfs-mgmtd'), :node => 'mgmtd.vm' do
      it { should be_enabled }
      it { should be_running }
    end
  end

  context "fhgfs-admon service should be enabled and running" do
    describe service('fhgfs-admon'), :node => 'mgmtd.vm' do
      it { should be_enabled }
      it { should be_running }
    end
  end

  context "should be listening on port 8008" do
    describe port(8008), :node => 'mgmtd.vm' do
      it { should be_listening }
    end
  end

  context "should be listening on port 8000" do
    describe port(8000), :node => 'mgmtd.vm' do
      it { should be_listening }
    end
  end
end

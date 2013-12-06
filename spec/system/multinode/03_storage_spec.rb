require 'spec_helper_system_multinode'

describe 'fhgfs::storage class:' do
  context 'should run successfully' do
    pp = <<-EOS
service { 'iptables': ensure => stopped, before => File['/fhgfs'], }

file { '/fhgfs':
  ensure  => directory,
}

class { 'fhgfs::storage':
  service_ensure          => 'running',
  service_enable          => true,
  store_storage_directory => '/fhgfs/storage',
  mgmtd_host              => 'mgmtd.vm',
  require                 => File['/fhgfs'],
}

class { 'fhgfs::client':
  mgmtd_host  => 'mgmtd.vm',
  utils_only  => true,
}

    EOS

    context puppet_apply(:code => pp, :node => 'storage.vm') do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end

  context "fhgfs-storage service should be enabled and running" do
    describe service('fhgfs-storage'), :node => 'storage.vm' do
      it { should be_enabled }
      it { should be_running }
    end
  end

  context "should be listening on port 8003" do
    describe port(8003), :node => 'storage.vm' do
      it { should be_listening }
    end
  end
end

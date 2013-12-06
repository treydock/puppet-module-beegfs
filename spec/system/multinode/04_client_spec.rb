require 'spec_helper_system_multinode'

describe 'fhgfs::client class:' do
  context 'should run successfully' do
    pp = <<-EOS
file { '/fhgfs':
  ensure  => directory,
}

class { 'fhgfs::client':
  mgmtd_host => 'mgmtd.vm',
  mount_path  => '/mnt/fhgfs',
}
    EOS

    context puppet_apply(:code => pp, :node => 'client.vm') do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end

  context "fhgfs-helperd service should be enabled and running" do
    describe service('fhgfs-helperd'), :node => 'client.vm' do
      it { should be_enabled }
      it { should be_running }
    end
  end

  context "fhgfs-client service should be enabled and running" do
    describe service('fhgfs-client'), :node => 'client.vm' do
      it { should be_enabled }
      it { should be_running }
    end
  end

  context "/mnt/fhgfs should be mounted with type fhgfs" do
    describe file('/mnt/fhgfs'), :node => 'client.vm' do
      it { should be_mounted.with( :type => 'fhgfs' ) }
    end
  end
end

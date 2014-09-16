require 'spec_helper_acceptance'

describe 'fhgfs::client class:' do
  context 'with fhgfs-client' do
    node = find_only_one(:client)

    it 'should run successfully' do
      pp = <<-EOS
        file { '/fhgfs':
          ensure  => directory,
        }->
        class { 'fhgfs::client':
          release    => '#{RSpec.configuration.fhgfs_release}',
          mgmtd_host => '#{mgmt_ip}',
          mount_path => '/mnt/fhgfs',
        }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    describe service('fhgfs-helperd'), :node => node do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('fhgfs-client'), :node => node do
      it { should be_enabled }
      it { should be_running }
    end

    describe file('/mnt/fhgfs'), :node => node do
      it { should be_mounted.with(:type => 'fhgfs') }
    end
  end
end

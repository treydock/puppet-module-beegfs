require 'spec_helper_acceptance'

describe 'fhgfs class:' do
  context 'with storage' do
    node = find_only_one(:storage)

    it 'should run successfully' do
      pp = <<-EOS
      file { '/fhgfs':
        ensure  => directory,
      }->
      class { 'fhgfs':
        storage                 => true,
        utils_only              => true,
        mgmtd_host              => '#{mgmt_ip}',
        release                 => '#{RSpec.configuration.fhgfs_release}',
        storage_service_ensure  => 'running',
        storage_service_enable  => true,
        storage_store_directory => '/fhgfs/storage',
      }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    describe service('fhgfs-storage'), :node => node do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('fhgfs-helperd'), :node => node do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe service('fhgfs-client'), :node => node do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe port(8003), :node => node do
      it { should be_listening }
    end
  end
end

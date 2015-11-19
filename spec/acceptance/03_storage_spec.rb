require 'spec_helper_acceptance'

describe 'beegfs class:' do
  context 'with storage' do
    node = find_only_one(:storage)

    it 'should run successfully' do
      pp = <<-EOS
      file { '/beegfs':
        ensure  => directory,
      }->
      class { 'beegfs':
        storage                 => true,
        utils_only              => true,
        mgmtd_host              => '#{mgmt_ip}',
        release                 => '#{RSpec.configuration.beegfs_release}',
        storage_service_ensure  => 'running',
        storage_service_enable  => true,
        storage_store_directory => '/beegfs/storage',
      }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    describe service('beegfs-storage'), :node => node do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('beegfs-helperd'), :node => node do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe service('beegfs-client'), :node => node do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe file('/etc/beegfs/beegfs-storage.conf'), :node => node do
      it { should be_file }
      its(:content) { should match /^sysMgmtdHost\s+= #{mgmt_ip}$/ }
      its(:content) { should match /^storeMgmtdDirectory\s+= \/beegfs\/mgmtd$/ }
    end

    describe port(8003), :node => node do
      it { should be_listening }
    end
  end
end

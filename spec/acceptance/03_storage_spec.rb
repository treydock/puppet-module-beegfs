require 'spec_helper_acceptance'

describe 'fhgfs::storage class:' do
  context 'with fhgfs-storage' do
    it 'should run successfully' do
      pp = <<-EOS
        file { '/fhgfs':
          ensure  => directory,
        }->
        class { 'fhgfs::storage':
          service_ensure          => 'running',
          service_enable          => true,
          store_storage_directory => '/fhgfs/storage',
          mgmtd_host              => '#{mgmt_ip}',
        }->
        class { 'fhgfs::client':
          mgmtd_host => '#{mgmt_ip}',
          utils_only => true,
        }
      EOS

      apply_manifest_on(find_only_one(:storage), pp, :catch_failures => true)
      expect(apply_manifest_on(find_only_one(:storage), pp, :catch_failures => true).exit_code).to be_zero
    end

    describe service('fhgfs-storage'), :node => find_only_one(:storage) do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(8003), :node => find_only_one(:storage) do
      it { should be_listening }
    end
  end
end

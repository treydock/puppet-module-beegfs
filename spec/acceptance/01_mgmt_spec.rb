require 'spec_helper_acceptance'

describe 'fhgfs::meta class:' do
  context 'with fhgfs-mgmtd and fhgfs-admon' do
    it 'should run successfully' do
      pp = <<-EOS
        file { '/fhgfs':
          ensure  => directory,
        }->
        class { 'fhgfs::mgmtd':
          service_ensure        => 'running',
          service_enable        => true,
          store_mgmtd_directory => '/fhgfs/mgmtd',
        }->
        class { 'fhgfs::admon':
          service_ensure  => 'running',
          service_enable  => true,
          mgmtd_host      => '#{mgmt_ip}',
        }->
        class { 'fhgfs::client':
          mgmtd_host => '#{mgmt_ip}',
          utils_only => true,
        }
      EOS

      apply_manifest_on(find_only_one(:mgmt), pp, :catch_failures => true)
      expect(apply_manifest_on(find_only_one(:mgmt), pp, :catch_failures => true).exit_code).to be_zero
    end

    describe service('fhgfs-mgmtd'), :node => find_only_one(:mgmt) do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('fhgfs-admon'), :node => find_only_one(:mgmt) do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(8008), :node => find_only_one(:mgmt) do
      it { should be_listening }
    end

    describe port(8000), :node => find_only_one(:mgmt) do
      it { should be_listening }
    end
  end
end

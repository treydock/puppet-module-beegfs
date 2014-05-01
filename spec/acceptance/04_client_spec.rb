require 'spec_helper_acceptance'

describe 'fhgfs::client class:' do
  context 'with fhgfs-client' do
    it 'should run successfully' do
      pp = <<-EOS
        file { '/fhgfs':
          ensure  => directory,
        }->
        class { 'fhgfs::client':
          mgmtd_host => '#{mgmt_ip}',
          mount_path => '/mnt/fhgfs',
        }
      EOS

      apply_manifest_on(find_only_one(:client), pp, :catch_failures => true)
      expect(apply_manifest_on(find_only_one(:client), pp, :catch_failures => true).exit_code).to be_zero
    end

    describe service('fhgfs-helperd'), :node => find_only_one(:client) do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('fhgfs-client'), :node => find_only_one(:client) do
      it { should be_enabled }
      it { should be_running }
    end

    describe file('/mnt/fhgfs'), :node => find_only_one(:client) do
      it { should be_mounted.with(:type => 'fhgfs') }
    end
  end
end

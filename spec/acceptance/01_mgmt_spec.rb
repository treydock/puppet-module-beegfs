require 'spec_helper_acceptance'

describe 'fhgfs::meta class:' do
  context 'with fhgfs-mgmtd and fhgfs-admon' do
    node = find_only_one(:mgmt)

    it 'should run successfully' do
      pp = <<-EOS
        class { 'fhgfs':
          mgmtd_host  => '#{mgmt_ip}',
          release     => '#{RSpec.configuration.fhgfs_release}',
        }
        file { '/fhgfs':
          ensure  => directory,
        }->
        class { 'fhgfs::mgmtd':
          service_ensure  => 'running',
          service_enable  => true,
          store_directory => '/fhgfs/mgmtd',
        }->
        class { 'fhgfs::admon':
          service_ensure  => 'running',
          service_enable  => true,
        }->
        class { 'fhgfs::client':
          utils_only => true,
        }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    describe service('fhgfs-mgmtd'), :node => node do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('fhgfs-admon'), :node => node do
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

    describe port(8008), :node => node do
      it { should be_listening }
    end

    describe port(8000), :node => node do
      it { should be_listening }
    end
  end
end

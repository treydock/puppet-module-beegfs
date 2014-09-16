require 'spec_helper_acceptance'

describe 'fhgfs::meta class:' do
  context 'with fhgfs-meta' do
    node = find_only_one(:meta)

    it 'should run successfully' do
      pp = <<-EOS
        file { '/fhgfs':
          ensure  => directory,
        }->
        class { 'fhgfs::meta':
          release         => '#{RSpec.configuration.fhgfs_release}',
          service_ensure  => 'running',
          service_enable  => true,
          store_directory => '/fhgfs/meta',
          mgmtd_host      => '#{mgmt_ip}',
        }->
        class { 'fhgfs::client':
          release    => '#{RSpec.configuration.fhgfs_release}',
          mgmtd_host => '#{mgmt_ip}',
          utils_only => true,
        }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    describe service('fhgfs-meta'), :node => node do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(8005), :node => node do
      it { should be_listening }
    end
  end
end

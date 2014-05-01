require 'spec_helper_acceptance'

describe 'fhgfs::meta class:' do
  context 'with fhgfs-meta' do
    it 'should run successfully' do
      pp = <<-EOS
        file { '/fhgfs':
          ensure  => directory,
        }->
        class { 'fhgfs::meta':
          service_ensure        => 'running',
          service_enable        => true,
          store_meta_directory  => '/fhgfs/meta',
          mgmtd_host            => '#{mgmt_ip}',
        }->
        class { 'fhgfs::client':
          mgmtd_host => '#{mgmt_ip}',
          utils_only => true,
        }
      EOS

      apply_manifest_on(find_only_one(:meta), pp, :catch_failures => true)
      expect(apply_manifest_on(find_only_one(:meta), pp, :catch_failures => true).exit_code).to be_zero
    end

    describe service('fhgfs-meta'), :node => find_only_one(:meta) do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(8005), :node => find_only_one(:meta) do
      it { should be_listening }
    end
  end
end

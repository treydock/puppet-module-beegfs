require 'spec_helper_acceptance'

describe 'beegfs class:' do
  context 'with client' do
    node = find_only_one(:client)

    it 'should run successfully' do
      pp = <<-EOS
      class { 'beegfs':
        mgmtd_host        => '#{mgmt_ip}',
        release           => '#{RSpec.configuration.beegfs_release}',
      }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    describe service('beegfs-helperd'), :node => node do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('beegfs-client'), :node => node do
      it { should be_enabled }
      it { should be_running }
    end

    describe file('/mnt/beegfs'), :node => node do
      it { should be_mounted.with(:type => 'beegfs') }
    end
  end
end

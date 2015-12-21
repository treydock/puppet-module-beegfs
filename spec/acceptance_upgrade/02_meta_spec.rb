require 'spec_helper_acceptance'

describe 'beegfs class:' do
  context 'with meta' do
    node = find_only_one(:meta)

    it 'should run successfully' do
      pp = <<-EOS
      file { '/fhgfs':
        ensure  => directory,
      }->
      class { 'beegfs':
        meta                  => true,
        utils_only            => true,
        mgmtd_host            => '#{mgmt_ip}',
        release               => '#{RSpec.configuration.beegfs_release}',
        meta_service_ensure   => 'running',
        meta_service_enable   => true,
        meta_store_directory  => '/fhgfs/meta',
        perform_fhgfs_upgrade => true,
      }
      EOS

      proj_root = File.expand_path(File.join(File.dirname(__FILE__), '../..'))
      puppet_module_install(:source => proj_root, :module_name => 'beegfs', :target_module_path => '/etc/puppet/modules')
      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    describe service('beegfs-meta'), :node => node do
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

    describe file('/etc/beegfs/beegfs-meta.conf'), :node => node do
      it { should be_file }
      its(:content) { should match /^sysMgmtdHost\s+= #{mgmt_ip}$/ }
      its(:content) { should match /^storeMetaDirectory\s+= \/fhgfs\/meta$/ }
    end

    describe port(8005), :node => node do
      it { should be_listening }
    end
  end
end

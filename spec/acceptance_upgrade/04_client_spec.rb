require 'spec_helper_acceptance'

describe 'beegfs class:' do
  context 'with client' do
    node = find_only_one(:client)

    it 'should run successfully' do
      if node['hypervisor'] =~ /docker/
        manage_client_dependencies = 'false'
        client_package_dependencies = '[]'
      else
        manage_client_dependencies = 'true'
        client_package_dependencies = 'undef'
      end
      pp = <<-EOS
      class { 'beegfs':
        mgmtd_host                  => '#{mgmt_ip}',
        release                     => '#{RSpec.configuration.beegfs_release}',
        client_mount_path           => '/data',
        manage_client_dependencies  => #{manage_client_dependencies},
        client_package_dependencies => #{client_package_dependencies},
        perform_fhgfs_upgrade       => true,
      }
      EOS

      proj_root = File.expand_path(File.join(File.dirname(__FILE__), '../..'))
      puppet_module_install(:source => proj_root, :module_name => 'beegfs', :target_module_path => '/etc/puppet/modules')

      # Docker based tests fail to start client service as kernel module must be compiled
      if node['hypervisor'] =~ /docker/
        apply_manifest_on(node, pp, :catch_failures => false)
      else
        apply_manifest_on(node, pp, :catch_failures => true)
        apply_manifest_on(node, pp, :catch_changes => true)
      end
    end

    describe service('beegfs-helperd'), :node => node do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('beegfs-client'), :node => node do
      it { should be_enabled }
      if ! node['hypervisor'] =~ /docker/
        it { should be_running }
      end
    end

    describe file('/etc/beegfs/beegfs-client.conf'), :node => node do
      it { should be_file }
      its(:content) { should match /^sysMgmtdHost\s+= #{mgmt_ip}$/ }
    end

    describe file('/etc/beegfs/beegfs-mounts.conf'), :node => node do
      it { should be_file }
      its(:content) { should match /^\/data \/etc\/beegfs\/beegfs-client.conf$/ }
    end

    if ! node['hypervisor'] =~ /docker/
      describe file('/data'), :node => node do
        it { should be_mounted.with(:type => 'beegfs') }
      end
    end
  end
end

require 'spec_helper_acceptance'

describe 'beegfs class:' do
  context 'with client' do
    node = find_only_one(:client)

    it 'runs successfully' do
      if node['hypervisor'] =~ %r{docker}
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
        manage_client_dependencies  => #{manage_client_dependencies},
        client_package_dependencies => #{client_package_dependencies},
      }
      EOS

      # Docker based tests fail to start client service as kernel module must be compiled
      if node['hypervisor'] =~ %r{docker}
        apply_manifest_on(node, pp, catch_failures: false)
      else
        apply_manifest_on(node, pp, catch_failures: true)
        apply_manifest_on(node, pp, catch_changes: true)
      end
    end

    describe service('beegfs-helperd'), node: node do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe service('beegfs-client'), node: node do
      it { is_expected.to be_enabled }
      if !node['hypervisor'] =~ %r{docker}
        it { is_expected.to be_running }
      end
    end

    describe file('/etc/beegfs/beegfs-client.conf'), node: node do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match %r{^sysMgmtdHost\s+= #{mgmt_ip}$} }
    end

    describe file('/etc/beegfs/beegfs-mounts.conf'), node: node do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match %r{^/mnt/beegfs /etc/beegfs/beegfs-client.conf$} }
    end

    if !node['hypervisor'] =~ %r{docker}
      describe file('/mnt/beegfs'), node: node do
        it { is_expected.to be_mounted.with(type: 'beegfs') }
      end
    end
  end
end

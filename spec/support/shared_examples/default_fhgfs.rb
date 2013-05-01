require 'support/fhgfs_test_utils'
require 'support/shared_contexts/fhgfs_vm_context'

shared_examples :default_fhgfs do
  include FhgfsTestUtils
  include_context :fhgfs_vm_context do
    include VMHelper
    
    include_context :fhgfs_vm_context
  end

  # this method is required by the fhgfs_vm shared context

  describe 'fhgfs' do
    manifest = <<-EOS
      # Configure version and add repo.
      class { "fhgfs":
        version => '2011.04',
      }
    EOS
    
    packages = [
      'fhgfs-client',
      'fhgfs-storage',
      'fhgfs-mgmtd',
      'fhgfs-meta',
      'fhgfs-helperd',
    ]
    
    it "with fhgfs added by Puppet" do
      # Run once to check for crashes
      sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{manifest}'; [ $? = 2 ]")

      # Run again to check for idempotence
      sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{manifest}'")
    end

    it 'with repo version defined' do
      sudo_and_log(vm, "test -d #{fhgfs_conf_path}")
    end
    
    packages.each do |package|
      it "with #{package} available" do
        sudo_and_log(vm, "/usr/bin/yum -e 0 --disablerepo=* --enablerepo=fhgfs list available | grep -q #{package}")
      end
    end
  end
  
  describe 'fhgfs-client' do
    manifest = <<-EOS
      # Configure version and manage_package_repo globally, install fhgfs
      # and then try to install a new database.
      class { "fhgfs::client":
        version => '2011.04',
        mgmtd_host  => "mgmtd01",
      }
    EOS
    
    it 'with fhgfs-client added by Puppet' do
      # Run once to check for crashes
      sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{manifest}'; [ $? = 2 ]")

      # Run again to check for idempotence
      sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{manifest}'")
    end
    
    it 'with client installed' do
      sudo_and_log(vm, "/bin/rpm -q --quiet fhgfs-client")
      sudo_and_log(vm, "test -f /etc/init.d/fhgfs-client")
    end

    it 'with sysMgmtdHost configured' do
      # Check that the database name is present
      sudo_and_log(vm, "grep -q mgmtd01 #{fhgfs_conf_path}/fhgfs-client.conf")
      sudo_and_log(vm, 'service fhgfs-client status')
    end
  end
end

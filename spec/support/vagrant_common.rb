require File.expand_path(File.join(__FILE__, '../fhgfs_test_config'))

def apply_common_vagrant_config(config)
  # Resolve DNS via NAT
  config.vm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

  # Share the various required modules
  # TODO: it would be better to install this via the puppet module tool
  FhgfsTestConfig::PuppetModuleDependencies.each do |puppet_module_dep|
    config.vm.share_folder "puppetlabs-stdlib-module", "/usr/share/puppet/modules/#{puppet_module_dep.split('-')[1]}", "../../../../../#{puppet_module_dep.split('-')[1]}"#"../../../fixtures/modules/#{puppet_module_dep.split('-').first}"
  end

  # Share the postgressql module
  config.vm.share_folder "puppet-fhgfs-module", "/usr/share/puppet/modules/fhgfs", "../../../..", :create => true

  # Share the module of test classes
  config.vm.share_folder "puppet-fhgfs-tests", "/usr/share/puppet/modules/fhgfs_tests", "../../fhgfs_tests", :create => true

  # Provision with a base puppet config just so we don't have to repeat the puppet user/group
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "../../"
    puppet.manifest_file  = "base.pp"
    puppet.module_path    = "../../test_module"
    puppet.options = ["--modulepath", "/usr/share/puppet/modules"]
  end
end

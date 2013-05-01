require 'logger'
require 'vagrant'
require 'support/fhgfs_test_config'


if FhgfsTestConfig::HardCoreTesting
  # this will just make sure that we throw an error if the user tries to
  # run w/o having Sahara installed
  require 'sahara'
end

shared_context :fhgfs_vm_context do
  before(:all) do
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG # TODO: get from environment or rspec?
    @env = Vagrant::Environment::new(:cwd => vagrant_dir)

    if FhgfsTestConfig::HardCoreTesting
      @env.cli("destroy", vm.to_s, "--force") # Takes too long
    end

    @env.cli("up", vm.to_s)

    if FhgfsTestConfig::HardCoreTesting
      sudo_and_log(vm, 'if [ "$(facter osfamily)" == "Debian" ] ; then apt-get update ; fi')
    end
    
    # Disable SELinux as FHGFS does not support it
    sudo_and_log(vm, '/usr/sbin/setenforce 0')
    
    if FhgfsTestConfig::GetPuppetModules
      FhgfsTestConfig::PuppetModuleDependencies.each do |module_dep|
        sudo_and_log(vm, "puppet module install --force #{module_dep}")
      end
    end

    if FhgfsTestConfig::HardCoreTesting
      # Sahara ignores :cwd so we have to chdir for now, see https://github.com/jedi4ever/sahara/issues/9
      Dir.chdir(vagrant_dir)
      @env.cli("sandbox", "on", vm.to_s)
    end
  end

  after(:all) do
    if FhgfsTestConfig::SuspendVMsAfterSuite
      @logger.debug("Suspending VM")
      @env.cli("suspend", vm.to_s)
    end
  end


  after(:each) do
    if FhgfsTestConfig::HardCoreTesting
      @env.cli("sandbox", "rollback", vm.to_s)
    end
  end

end

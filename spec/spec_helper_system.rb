require 'rspec-system/spec_helper'
require 'rspec-system-puppet/helpers'
require 'rspec-system-serverspec/helpers'
require 'support/system_helper'

include RSpecSystemPuppet::Helpers
include Serverspec::Helper::RSpecSystem
include Serverspec::Helper::DetectOS
include SystemHelper

RSpec.configure do |c|
  # Project root for the this module's code
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Enable colour in Jenkins
  c.tty = true

  c.include RSpecSystemPuppet::Helpers
  c.include SystemHelper

  # This is where we 'setup' the nodes before running our tests
  c.before :suite do
    # Install puppet
    puppet_install
    puppet_master_install

    setup

    shell('[ -d /etc/puppet/modules/stdlib ] || puppet module install puppetlabs-stdlib --version ">=3.2.0 <5.0.0" --modulepath /etc/puppet/modules')
    shell('[ -d /etc/puppet/modules/gpg_key ] || puppet module install treydock/gpg_key --version ">=0.0.2" --modulepath /etc/puppet/modules')

    puppet_module_install(:source => proj_root, :module_name => 'fhgfs')
  end
end

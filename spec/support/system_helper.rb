require 'rspec-system/spec_helper'
#require 'rspec-system-puppet/spec_helper'
require 'rspec-system-puppet/helpers'
require 'rspec-system-serverspec/helpers'

module SystemHelper
  include RSpecSystem::Helpers
  include RSpecSystemPuppet::Helpers
  include Serverspec::Helper::RSpecSystem
  include Serverspec::Helper::DetectOS

  def setup
    pp RSpec.configuration.rs_config
    pp RSpec.configuration
  end

  def nodes
    rspec_system_node_set = RSpecSystem::NodeSet.create.config
    node_names = rspec_system_node_set['nodes'].keys
    node_names
  end

  def hosts
    pp = <<-EOS
host { 'mgmtd.vm':
  ip  => '192.168.1.2',
}
host { 'meta.vm':
  ip  => '192.168.1.3',
}
host { 'storage.vm':
  ip  => '192.168.1.4',
}
host { 'client.vm':
  ip  => '192.168.1.5',
}
    EOS
    pp
  end
end

=begin

include RSpecSystemPuppet::Helpers
include Serverspec::Helper::RSpecSystem
include Serverspec::Helper::DetectOS
include LocalHelpers

RSpec.configure do |c|
  # Project root for the this module's code
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Enable colour in Jenkins
  c.tty = true

  c.include RSpecSystemPuppet::Helpers
  c.include LocalHelpers

  # This is where we 'setup' the nodes before running our tests
  c.before :suite do
    # Install puppet
    nodes.each { |n| puppet_install(:node => n) }
    nodes.each { |n| puppet_master_install(:node => n) }

    nodes.each { |n| shell(:command => '[ -d /etc/puppet/modules/stdlib ] || puppet module install puppetlabs-stdlib --modulepath /etc/puppet/modules --force', :node => n) }
    nodes.each { |n| shell(:command => '[ -d /etc/puppet/modules/gpg_key ] || puppet module install treydock/gpg_key --modulepath /etc/puppet/modules --force', :node => n) }

    shell('[ -d /etc/puppet/modules/stdlib ] || puppet module install puppetlabs-stdlib --version ">=3.2.0 <5.0.0" --modulepath /etc/puppet/modules')
    shell('[ -d /etc/puppet/modules/gpg_key ] || puppet module install treydock/gpg_key --version ">=0.0.2" --modulepath /etc/puppet/modules')

    nodes.each { |n| puppet_apply(:code => hosts, :node => n) }

    nodes.each { |n| puppet_module_install(:source => proj_root, :module_name => 'fhgfs', :node => n) }
  end
end
=end
require 'rspec-system/spec_helper'
#require 'rspec-system-puppet/spec_helper'
require 'rspec-system-puppet/helpers'
require 'rspec-system-serverspec/helpers'

module LocalHelpers
  include RSpecSystem::InternalHelpers

  def ns
    rspec_system_node_set
  end

  def nodes
    ns.nodes.collect {|k,v| k }
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

    nodes.each { |n| shell(:command => 'puppet module install puppetlabs-stdlib --modulepath /etc/puppet/modules --force', :node => n) }
    nodes.each { |n| shell(:command => 'puppet module install treydock/gpg_key --modulepath /etc/puppet/modules --force', :node => n) }

    # Temporary until the zabbix20 module is added to the Forge
    nodes.each { |n| shell(:command => "yum -y install git", :node => n) }
    nodes.each { |n| shell(:command => "git clone git://github.com/treydock/puppet-zabbix20.git /etc/puppet/modules/zabbix20", :node => n) }
    nodes.each { |n| shell(:command => "puppet module install puppetlabs/firewall --modulepath /etc/puppet/modules", :node => n) }
    nodes.each { |n| shell(:command => "puppet module install stahnma/epel --modulepath /etc/puppet/modules", :node => n) }
    nodes.each { |n| shell(:command => "puppet module install saz/sudo --modulepath /etc/puppet/modules", :node => n) }

    nodes.each { |n| puppet_apply(:code => hosts, :node => n) }

    nodes.each { |n| puppet_module_install(:source => proj_root, :module_name => 'fhgfs', :node => n) }
  end
end

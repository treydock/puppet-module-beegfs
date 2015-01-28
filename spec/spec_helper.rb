require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

dir = File.expand_path(File.dirname(__FILE__))

Dir["#{dir}/support/*.rb"].sort.each {|f| require f}

include RspecPuppetFacts

at_exit { RSpec::Puppet::Coverage.report! }

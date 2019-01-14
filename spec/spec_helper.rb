require 'rspec-puppet-facts'
require 'lib/spec_helpers'
RSpec.configure do |config|
  config.mock_with :rspec
end
require 'puppetlabs_spec_helper/module_spec_helper'

dir = File.expand_path(File.dirname(__FILE__))

Dir["#{dir}/shared_examples/*.rb"].sort.each {|f| require f}

include RspecPuppetFacts

add_custom_fact :kernelrelease, '4.0.0'

RSpec.configure do |config|
  config.mock_with :rspec
end

at_exit { RSpec::Puppet::Coverage.report! }

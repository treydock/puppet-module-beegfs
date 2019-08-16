require 'rspec-puppet-facts'
require 'pp'

dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/shared_examples/*.rb"].sort.each { |f| require f }

include RspecPuppetFacts

add_custom_fact :kernelrelease, '4.0.0'

def verify_augeas_changes(subject, title, expected_changes)
  changes = subject.resource('augeas', title).send(:parameters)[:changes]
  if changes.is_a?(String)
    changes = changes.split(%r{\n})
  end
  expect(changes & expected_changes).to eq(expected_changes)
end

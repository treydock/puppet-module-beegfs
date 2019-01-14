require 'spec_helper_acceptance'

describe 'beegfs facts:' do
  context 'when beegfs is installed' do
    hosts.each do |host|
      describe command('facter --puppet beegfs_version'), :node => host do
        its(:stdout) { should match /^#{RSpec.configuration.beegfs_release}[\.0-9]+$/ }
      end
    end
  end
end

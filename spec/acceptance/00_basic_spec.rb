require 'spec_helper_acceptance'

describe 'beegfs facts:' do
  context 'before installing beegfs' do
    hosts.each do |host|
      describe command('facter --puppet beegfs_version'), :node => host do
        its(:stdout) { should match /^$/ }
      end
    end
  end
end

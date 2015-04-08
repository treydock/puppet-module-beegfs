require 'spec_helper_acceptance'

describe 'fhgfs facts:' do
  context 'before installing fhgfs' do
    hosts.each do |host|
      describe command('facter --puppet fhgfs_version'), :node => host do
        its(:stdout) { should match /^$/ }
      end
    end
  end
end

require 'spec_helper_acceptance'

describe 'fhgfs facts:' do
  context 'when fhgfs is installed' do
    hosts.each do |host|
      describe command('facter --puppet fhgfs_version'), :node => host do
        it { should return_stdout /^#{RSpec.configuration.fhgfs_release}.r[0-9]+$/ }
      end
    end
  end
end

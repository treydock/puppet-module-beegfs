require 'spec_helper_acceptance'

describe 'fhgfs facts:' do
  context 'when fhgfs is installed' do
    describe command('facter --puppet fhgfs_version') do
      it { should return_stdout /^2012.10.r[0-9]+$/ }
    end
  end
end

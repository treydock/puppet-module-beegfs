require 'spec_helper_acceptance'

describe 'fhgfs facts:' do
  context 'before installing fhgfs' do
    describe command('facter --puppet fhgfs_version') do
      it { should return_stdout '' }
    end
  end
end

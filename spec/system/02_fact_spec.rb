require 'spec_helper_system'

describe 'fhgfs facts:' do
  context shell('facter --puppet fhgfs_version') do
    its(:stdout) { should =~ /^2012.10.r[0-9]+$/ }
    its(:stderr) { should be_empty }
    its(:exit_code) { should be_zero }
  end
end

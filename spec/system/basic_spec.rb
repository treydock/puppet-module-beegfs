require 'spec_helper_system'

describe 'basic tests:' do
  context puppet_agent do
    its(:stderr) { should be_empty }
    its(:exit_code) { should_not == 1 }
  end

  context shell('facter --puppet fhgfs_version') do
    its(:stdout) { should be_empty }
    its(:stderr) { should be_empty }
    its(:exit_code) { should be_zero }
  end
end

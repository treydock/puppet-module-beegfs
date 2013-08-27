require 'spec_helper_system_multinode'

describe 'basic tests:' do
  nodes.each do |n|
    context puppet_agent(:node => n) do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
    end
  end
end

require 'spec_helper_system'

describe 'fhgfs::utils class:' do
  context 'should run successfully' do
    pp = <<-EOS
      class { 'fhgfs::utils': }
    EOS

    context puppet_apply(pp) do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end
end

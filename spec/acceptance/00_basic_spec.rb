require 'spec_helper_acceptance'

describe 'beegfs facts:' do
  context 'before installing beegfs' do
    hosts.each do |host|
      describe command('facter --puppet beegfs_version'), node: host do
        its(:stdout) { is_expected.to match %r{^$} }
      end
    end
  end
end

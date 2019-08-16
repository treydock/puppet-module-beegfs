require 'spec_helper'

describe 'beegfs_version fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
    allow(Facter.fact(:osfamily)).to receive(:value).and_return('RedHat')
  end

  it 'returns beegfs-common version' do
    expect(Facter::Core::Execution).to receive(:exec).with("rpm -q --queryformat '%{NAME}-%{VERSION}' beegfs-common").and_return('beegfs-common-7.1.2')
    expect(Facter.fact(:beegfs_version).value).to eq('7.1.2')
  end

  it 'handles package not installed' do
    expect(Facter::Core::Execution).to receive(:exec).with("rpm -q --queryformat '%{NAME}-%{VERSION}' beegfs-common").and_return("package beegfs-common is not installed\n")
    expect(Facter.fact(:beegfs_version).value).to be_nil
  end
end

require 'spec_helper'

describe 'beegfs_version fact' do
  
  before :each do
    Facter.clear
    Facter.fact(:osfamily).stubs(:value).returns("RedHat")
  end

  it "should return 2015.03.r1" do
    Facter::Util::Resolution.stubs(:exec).with("rpm -q --queryformat '%{NAME}-%{VERSION}' beegfs-common").returns("beegfs-common-2015.03.r1")
    Facter.fact(:beegfs_version).value.should == "2015.03.r1"
  end

  it "should handle package not installed" do
    Facter::Util::Resolution.stubs(:exec).with("rpm -q --queryformat '%{NAME}-%{VERSION}' beegfs-common").returns("package beegfs-common is not installed\n")
    Facter.fact(:beegfs_version).value.should == nil
  end
end

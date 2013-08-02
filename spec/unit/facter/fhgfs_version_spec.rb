require 'spec_helper'

describe 'fhgfs_version fact' do
  
  before :each do
    Facter.clear
    Facter.fact(:osfamily).stubs(:value).returns("RedHat")
  end

  it "should return 2012.10.r7" do
    Facter::Util::Resolution.stubs(:exec).with("rpm -q --queryformat '%{NAME}-%{VERSION}' fhgfs-common").returns("fhgfs-common-2012.10.r7")
    Facter.fact(:fhgfs_version).value.should == "2012.10.r7"
  end

  it "should handle package not installed" do
    Facter::Util::Resolution.stubs(:exec).with("rpm -q --queryformat '%{NAME}-%{VERSION}' fhgfs-common").returns("package fhgfs-common is not installed\n")
    Facter.fact(:fhgfs_version).value.should == nil
  end
end

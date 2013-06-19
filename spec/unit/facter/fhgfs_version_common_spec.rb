require 'spec_helper'
require 'facter/fhgfs_common_version'

describe 'fhgfs_common_version fact' do
  
  before :each do
    Facter.fact(:osfamily).stubs(:value).returns(facts[:osfamily])
    Facter::Util::Resolution.stubs(:which).with("rpm").returns("/bin/rpm")
  end

  context "RedHat" do
    let :facts do
      { :osfamily => "RedHat" }
    end
    let(:version_found) { "2011.04.r22" }
    let(:expected_version) { "2011.04.r22" }

    it "should return 2011.04.r22-el5" do
      Facter::Util::Resolution.stubs(:exec).with("rpm -q --queryformat '%{VERSION}' fhgfs-common").returns(version_found)
      Facter.fact(:fhgfs_common_version).value.should == expected_version
    end
  end
end

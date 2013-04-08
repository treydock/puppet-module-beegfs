require 'spec_helper'
require 'facter/fhgfs_client_version'

describe Facter::Util::Fhgfs do
  context "RedHat" do
    let(:version_found) { "2011.04.r22" }
    let(:expected_version) { "2011.04.r22" }

    it "should return 2011.04.r22-el5" do
      Facter::Util::Resolution.expects(:exec).with("/bin/rpm -q --queryformat '%{VERSION}' fhgfs-client").returns(version_found)
      Facter::Util::Fhgfs.get_version('fhgfs-client').should == expected_version
    end
  end
end

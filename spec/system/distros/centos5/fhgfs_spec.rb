require 'support/shared_examples/default_fhgfs'

module VMHelper
  def vm
    :centos5
  end
  
  def vagrant_dir
    File.dirname(__FILE__)
  end
  
  def fhgfs_confg_path
    "/etc/fhgfs"
  end
end

describe "CentOS 5, 64-bit: default system fhgfs" do
  it_behaves_like :default_fhgfs do
    include VMHelper    
    include_context :default_fhgfs
  end
end

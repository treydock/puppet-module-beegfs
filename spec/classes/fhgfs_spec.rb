require 'spec_helper'

describe 'fhgfs' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('fhgfs') }
  it { should contain_class('fhgfs::params') }

  it { should contain_package('kernel-devel').with_ensure('present') }

  it { should include_class('fhgfs::repo') }
end

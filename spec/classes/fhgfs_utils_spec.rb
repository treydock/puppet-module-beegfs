require 'spec_helper'

describe 'fhgfs::utils' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('fhgfs::utils') }
  it { should contain_class('fhgfs::params') }
  it { should include_class('fhgfs') }

  it do
    should contain_package('fhgfs-utils').with({
      'ensure'    => 'present',
      'name'      => 'fhgfs-utils',
      'require'   => 'Yumrepo[fhgfs]',
    })
  end
end

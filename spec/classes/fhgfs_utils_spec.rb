require 'spec_helper'

describe 'fhgfs::utils' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:pre_condition) { "include fhgfs::client" }

  it { should create_class('fhgfs::utils') }
  it { should contain_class('fhgfs') }
  it { should contain_class('fhgfs::params') }

  it do
    should contain_package('fhgfs-utils').with({
      'ensure'    => 'present',
      'name'      => 'fhgfs-utils',
      'require'   => 'Yumrepo[fhgfs]',
    })
  end
end

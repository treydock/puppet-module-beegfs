require 'spec_helper'

describe 'fhgfs::monitor' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('fhgfs::monitor') }
  it { should contain_class('fhgfs::params') }

  it do
    should contain_file('/usr/bin/fhgfs-iostat.rb').with({
      'ensure'  => 'present',
      'source'  => 'puppet:///modules/fhgfs/fhgfs-iostat.rb',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0755',
    })
  end
end

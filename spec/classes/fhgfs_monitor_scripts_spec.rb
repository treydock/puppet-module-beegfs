require 'spec_helper'

describe 'fhgfs::monitor::scripts' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('fhgfs::monitor::scripts') }

  it do
    should contain_file('/usr/bin/fhgfs-iostat.rb').with({
      'ensure'  => 'present',
      'source'  => 'puppet:///modules/fhgfs/fhgfs-iostat.rb',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0755',
    })
  end

  it do
    should contain_file('/usr/bin/fhgfs-poolstat.rb').with({
      'ensure'  => 'present',
      'source'  => 'puppet:///modules/fhgfs/fhgfs-poolstat.rb',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0755',
    })
  end
end

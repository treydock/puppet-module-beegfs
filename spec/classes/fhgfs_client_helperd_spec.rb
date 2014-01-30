require 'spec_helper'

describe 'fhgfs::client::helperd' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('fhgfs::client::helperd') }
  it { should contain_class('fhgfs::params') }
  it { should contain_class('fhgfs') }

  it do
    should contain_file("/etc/fhgfs/fhgfs-helperd.conf").with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
    })
  end

  it do
    should contain_package('fhgfs-helperd').with({
      'ensure'    => 'present',
      'name'      => 'fhgfs-helperd',
      'before'    => 'File[/etc/fhgfs/fhgfs-helperd.conf]',
      'require'   => 'Yumrepo[fhgfs]',
    })
  end

  it do
    should contain_service('fhgfs-helperd').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'fhgfs-helperd',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
      'subscribe'   => 'File[/etc/fhgfs/fhgfs-helperd.conf]',
      'before'      => 'Service[fhgfs-client]',
    })
  end
end

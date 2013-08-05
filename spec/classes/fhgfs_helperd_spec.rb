require 'spec_helper'

describe 'fhgfs::helperd' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('fhgfs::helperd') }
  it { should contain_class('fhgfs::params') }
  it { should include_class('fhgfs') }

  it_behaves_like 'server files' do
    let(:name) { "fhgfs-helperd" }
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
    })
  end
end

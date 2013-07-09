require 'spec_helper'

describe 'fhgfs::helperd' do
  include_context :defaults

  let(:facts) { default_facts.merge({}) }
  let(:params) {{}}

  it { should contain_class('fhgfs::params') }
  it { should include_class('fhgfs') }

  include_context 'fhgfs'

  it do
    should contain_package('fhgfs-helperd').with({
      'ensure'    => 'present',
      'name'      => 'fhgfs-helperd',
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
      'require'     => 'File[/etc/fhgfs/fhgfs-helperd.conf]',
    })
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-helperd.conf').with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => 'Package[fhgfs-helperd]',
      'notify'  => 'Service[fhgfs-helperd]',
    })
  end
end

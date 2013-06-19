require 'spec_helper'

describe 'fhgfs::helperd' do
  include_context :defaults

  let(:facts) { default_facts.merge({}) }
  let(:params) {{}}

  it { should contain_class('fhgfs') }
  it { should include_class('fhgfs::params') }
  it { should include_class('fhgfs::repo') }

  include_context 'fhgfs::repo'

  it do
    should contain_yumrepo('fhgfs').with({
      'descr'     => "FhGFS #{facts[:fhgfs_version]} (RHEL6)",
      'baseurl'   => "http://www.fhgfs.com/release/fhgfs_#{facts[:fhgfs_version]}/dists/rhel6",
      'gpgkey'    => "http://www.fhgfs.com/release/fhgfs_#{facts[:fhgfs_version]}/gpg/RPM-GPG-KEY-fhgfs",
      'gpgcheck'  => '0',
      'enabled'   => '1',
    })
  end

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
    should contain_file('/etc/fhgfs').with({
      'ensure'  => 'directory',
    })
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-helperd.conf').with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'before'  => 'Package[fhgfs-helperd]',
      'require' => 'File[/etc/fhgfs]',
      'notify'  => 'Service[fhgfs-helperd]',
    })
  end
end

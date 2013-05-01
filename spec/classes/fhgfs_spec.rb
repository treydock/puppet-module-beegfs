require 'spec_helper'

describe 'fhgfs' do

  let :facts do
    {
      :osfamily                 => 'RedHat',
      :operatingsystemrelease   => '6.4',
    }
  end

  it { should contain_class('fhgfs::params') }
  it { should contain_class('fhgfs::repo') }

  it do
    should contain_file('/etc/fhgfs').with({
      'ensure'  => 'directory',
    })
  end

  it do
    should contain_package('kernel-devel').with({
      'ensure'  => 'installed',
      'before'  => 'File[/etc/fhgfs]',
    })
  end

  context 'fhgfs::repo' do
    it { should contain_class('fhgfs::params') }

    it do
      should contain_yumrepo('fhgfs').with({
        'descr'     => "FhGFS 2012.10 (RHEL6)",
        'baseurl'   => 'http://www.fhgfs.com/release/fhgfs_2012.10/dists/rhel6',
        'gpgkey'    => 'http://www.fhgfs.com/release/fhgfs_2012.10/gpg/RPM-GPG-KEY-fhgfs',
        'gpgcheck'  => '0',
        'enabled'   => '1',
      })
    end
  end

  context 'with specific version from parameters' do
    let :params do
      {
        :version => '2011.04',
      }
    end

    it do
      should contain_yumrepo('fhgfs').with({
        'descr'     => "FhGFS 2011.04 (RHEL6)",
        'baseurl'   => 'http://www.fhgfs.com/release/fhgfs_2011.04/dists/rhel6',
        'gpgkey'    => 'http://www.fhgfs.com/release/fhgfs_2011.04/gpg/RPM-GPG-KEY-fhgfs',
        'gpgcheck'  => '0',
        'enabled'   => '1',
      })
    end
  end

  context 'with specific version from ENC' do
    let :facts do
      {
        :fhgfs_version            => '2011.04',
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '6.4',
      }
    end

    it do
      should contain_yumrepo('fhgfs').with({
        'descr'     => "FhGFS 2011.04 (RHEL6)",
        'baseurl'   => 'http://www.fhgfs.com/release/fhgfs_2011.04/dists/rhel6',
        'gpgkey'    => 'http://www.fhgfs.com/release/fhgfs_2011.04/gpg/RPM-GPG-KEY-fhgfs',
        'gpgcheck'  => '0',
        'enabled'   => '1',
      })
    end
  end

  context "with custom baseurl" do
    let :params do
      {
        :version      => '2011.04',
        :repo_baseurl => 'http://yum.example.com/fhgfs/fhgfs_2012.10/dists/rhel6',
        :repo_gpgkey  => 'http://yum.example.com/fhgfs/fhgfs_2012.10/gpgkey/RPM-GPG-KEY-fhgfs',
      }
    end

    it do
      should contain_yumrepo('fhgfs').with({
        'descr'     => "FhGFS 2011.04 (RHEL6)",
        'baseurl'   => params[:repo_baseurl],
        'gpgkey'    => params[:repo_gpgkey],
        'gpgcheck'  => '0',
        'enabled'   => '1',
      })
    end
  end
end

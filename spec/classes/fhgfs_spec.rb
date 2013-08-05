require 'spec_helper'

describe 'fhgfs' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('fhgfs') }
  it { should contain_class('fhgfs::params') }

  it { should contain_package('kernel-devel').with_ensure('present') }

  it do
    should contain_yumrepo('fhgfs').with({
      'descr'     => "FhGFS 2012.10 (RHEL6)",
      'baseurl'   => "http://www.fhgfs.com/release/fhgfs_2012.10/dists/rhel6",
      'gpgkey'    => "http://www.fhgfs.com/release/fhgfs_2012.10/gpg/RPM-GPG-KEY-fhgfs",
      'gpgcheck'  => '0',
      'enabled'   => '1',
    })
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
        'baseurl'   => "http://www.fhgfs.com/release/fhgfs_2011.04/dists/rhel6",
        'gpgkey'    => "http://www.fhgfs.com/release/fhgfs_2011.04/gpg/RPM-GPG-KEY-fhgfs",
        'gpgcheck'  => '0',
        'enabled'   => '1',
      })
    end
  end

  context 'with specific version from ENC' do
    let :facts do
      default_facts.merge({
        :fhgfs_repo_version            => '2011.04',
      })
    end

    it do
      should contain_yumrepo('fhgfs').with({
        'descr'     => "FhGFS 2011.04 (RHEL6)",
        'baseurl'   => "http://www.fhgfs.com/release/fhgfs_2011.04/dists/rhel6",
        'gpgkey'    => "http://www.fhgfs.com/release/fhgfs_2011.04/gpg/RPM-GPG-KEY-fhgfs",
        'gpgcheck'  => '0',
        'enabled'   => '1',
      })
    end
  end

  context "with custom baseurl" do
    let :params do
      {
        :version      => '2012.10',
        :repo_baseurl => 'http://yum.example.com/fhgfs/fhgfs_2012.10/dists/rhel6',
        :repo_gpgkey  => 'http://yum.example.com/fhgfs/fhgfs_2012.10/gpgkey/RPM-GPG-KEY-fhgfs',
      }
    end

    it do
      should contain_yumrepo('fhgfs').with({
        'descr'     => "FhGFS 2012.10 (RHEL6)",
        'baseurl'   => "http://yum.example.com/fhgfs/fhgfs_2012.10/dists/rhel6",
        'gpgkey'    => "http://yum.example.com/fhgfs/fhgfs_2012.10/gpgkey/RPM-GPG-KEY-fhgfs",
        'gpgcheck'  => '0',
        'enabled'   => '1',
      })
    end
  end
end

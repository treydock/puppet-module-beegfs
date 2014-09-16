require 'spec_helper'

describe 'fhgfs::repo' do
  let(:facts) do
    {
      :osfamily                   => 'RedHat',
      :operatingsystemrelease     => '6.5',
      :operatingsystemmajrelease  => '6',
    }
  end

  it { should create_class('fhgfs::repo') }
  it { should contain_class('fhgfs') }

  it { should contain_package('kernel-devel').with_ensure('present') }

  context 'osfamily => RedHat' do
    let(:facts) do
      {
        :osfamily                   => 'RedHat',
        :operatingsystemrelease     => '6.4',
        :operatingsystemmajrelease  => '6',
      }
    end

    it do
      should contain_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-fhgfs').with({
        'ensure'  => 'present',
        'source'  => 'puppet:///modules/fhgfs/RPM-GPG-KEY-fhgfs',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      })
    end

    it do
      should contain_gpg_key('fhgfs').with({
        'path'    => '/etc/pki/rpm-gpg/RPM-GPG-KEY-fhgfs',
        'before'  => 'Yumrepo[fhgfs]',
      })
    end

    it do
      should contain_yumrepo('fhgfs').with({
        'descr'     => "FhGFS 2012.10 (RHEL6)",
        'baseurl'   => "http://www.fhgfs.com/release/fhgfs_2012.10/dists/rhel6",
        'gpgkey'    => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fhgfs',
        'gpgcheck'  => '0',
        'enabled'   => '1',
      })
    end

    context "when release => '2014.01'" do
      let(:pre_condition) { "class { 'fhgfs': release => '2014.01' }" }
      it do
        should contain_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-fhgfs').with({
          'ensure'  => 'present',
          'source'  => 'puppet:///modules/fhgfs/RPM-GPG-KEY-fhgfs',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        })
      end

      it do
        should contain_gpg_key('fhgfs').with({
          'path'    => '/etc/pki/rpm-gpg/RPM-GPG-KEY-fhgfs',
          'before'  => 'Yumrepo[fhgfs]',
        })
      end

      it do
        should contain_yumrepo('fhgfs').with({
          'descr'     => "FhGFS 2014.01 (RHEL6)",
          'baseurl'   => "http://www.fhgfs.com/release/fhgfs_2014.01/dists/rhel6",
          'gpgkey'    => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fhgfs',
          'gpgcheck'  => '0',
          'enabled'   => '1',
        })
      end
    end

    context "with custom baseurl" do
      let(:pre_condition) { "class { 'fhgfs': repo_baseurl => 'http://yum.example.com/fhgfs/fhgfs_2012.10/dists/rhel6' }" }

      it { should contain_yumrepo('fhgfs').with_baseurl("http://yum.example.com/fhgfs/fhgfs_2012.10/dists/rhel6") }
    end

    context "with custom gpgkey" do
      let(:pre_condition) { "class { 'fhgfs': repo_gpgkey => 'http://foo.com/RPM-GPG-KEY-fhgfs' }" }

      it { should contain_yumrepo('fhgfs').with_gpgkey("http://foo.com/RPM-GPG-KEY-fhgfs") }
    end

    context "with gpgcheck => '1'" do
      let(:pre_condition) { "class { 'fhgfs': repo_gpgcheck => '1' }" }

      it { should contain_yumrepo('fhgfs').with_gpgcheck('1') }
    end

    context "with enabled => '0'" do
      let(:pre_condition) { "class { 'fhgfs': repo_enabled => '0' }" }

      it { should contain_yumrepo('fhgfs').with_enabled('0') }
    end
  end
end

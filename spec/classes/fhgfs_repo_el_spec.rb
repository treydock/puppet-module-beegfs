require 'spec_helper'

describe 'fhgfs::repo::el' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('fhgfs::repo::el') }
  it { should include_class('fhgfs') }

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

  context 'with specific version from parameters' do
    let :pre_condition do
      "class { 'fhgfs':
        version => 2011.04,
      }"
    end

    it do
      should contain_yumrepo('fhgfs').with({
        'descr'     => "FhGFS 2011.04 (RHEL6)",
        'baseurl'   => "http://www.fhgfs.com/release/fhgfs_2011.04/dists/rhel6",
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

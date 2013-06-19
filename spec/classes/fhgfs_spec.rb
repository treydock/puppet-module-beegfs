require 'spec_helper'

describe 'fhgfs' do
  include_context :defaults

  let(:facts) { default_facts.merge({}) }

  it { should contain_class('fhgfs::params') }
  it { should include_class('fhgfs::repo') }

  context 'with no paramters' do
    let :params do
      {}
    end

    include_context 'fhgfs::repo'

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
  end

  context 'with specific version from parameters' do
    include_context 'fhgfs::repo'

    let :params do
      {
        :version => '2011.04',
      }
    end
  end

  context 'with specific version from ENC' do
    include_context 'fhgfs::repo'

    let :facts do
      default_facts.merge({
        :fhgfs_version            => '2011.04',
      })
    end

    let :params do
      {}
    end
  end

  context "with custom baseurl" do
    include_context 'fhgfs::repo'

    let :params do
      {
        :version      => '2011.04',
        :repo_baseurl => 'http://yum.example.com/fhgfs/fhgfs_2012.10/dists/rhel6',
        :repo_gpgkey  => 'http://yum.example.com/fhgfs/fhgfs_2012.10/gpgkey/RPM-GPG-KEY-fhgfs',
      }
    end
  end
end

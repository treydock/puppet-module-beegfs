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


  context 'fhgfs::repo' do
    it { should contain_class('fhgfs::repo::el') }
  end

  context 'fhgfs::repo::el' do
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
end

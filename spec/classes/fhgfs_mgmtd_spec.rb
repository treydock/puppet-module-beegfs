require 'spec_helper'

describe 'fhgfs::mgmtd' do

  let :facts do
    {
      :fhgfs_version            => '2011.04',
      :osfamily                 => 'RedHat',
      :operatingsystemrelease   => '6.4',
    }
  end

  it { should contain_class('fhgfs') }
  it { should contain_class('fhgfs::repo') }
  it { should contain_class('fhgfs::params') }

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
    should contain_package('fhgfs-mgmtd').with({
      'ensure'    => 'present',
      'name'      => 'fhgfs-mgmtd',
      'require'   => 'Yumrepo[fhgfs]',
    })
  end

  it do
    should contain_service('fhgfs-mgmtd').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'fhgfs-mgmtd',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
      'require'     => 'File[/etc/fhgfs/fhgfs-mgmtd.conf]',
    })
  end

  it do
    should contain_file('/etc/fhgfs').with({
      'ensure'  => 'directory',
    })
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-mgmtd.conf').with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'before'  => 'Package[fhgfs-mgmtd]',
      'require' => 'File[/etc/fhgfs]',
      'notify'  => 'Service[fhgfs-mgmtd]',
    })
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-mgmtd.conf') \
      .with_content(/^storeMgmtdDirectory\s+=\s+$/) \
      .with_content(/^tuneNumWorkers\s+=\s+4$/)
  end

  it { should_not contain_file('') }

  context "with conf values defined" do
    let(:params) {
      {
        :store_mgmtd_directory  => "/tank/fhgfs/mgmtd",
      }
    }

    it do
      should contain_file('/etc/fhgfs/fhgfs-mgmtd.conf') \
        .with_content(/^storeMgmtdDirectory\s+=\s#{params[:store_mgmtd_directory]}$/) \
        .with_content(/^tuneNumWorkers\s+=\s+4$/)
    end

    it do
      should contain_file(params[:store_mgmtd_directory]).with({
        'ensure'  => 'directory',
        'before'  => 'Service[fhgfs-mgmtd]',
      })
    end
  end
end

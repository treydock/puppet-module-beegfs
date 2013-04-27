require 'spec_helper'

describe 'fhgfs::meta' do

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
    should contain_package('fhgfs-meta').with({
      'ensure'    => 'present',
      'name'      => 'fhgfs-meta',
      'require'   => 'Yumrepo[fhgfs]',
    })
  end
  
  it do
    should contain_service('fhgfs-meta').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'fhgfs-meta',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
      'require'     => 'File[/etc/fhgfs/fhgfs-meta.conf]',
    })
  end

  it do
    should contain_file('/etc/fhgfs').with({
      'ensure'  => 'directory',
    })
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-meta.conf').with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'before'  => 'Package[fhgfs-meta]',
      'require' => 'File[/etc/fhgfs]',
      'notify'  => 'Service[fhgfs-meta]',
    })
  end
  
  it do
    should contain_file('/etc/fhgfs/fhgfs-meta.conf') \
      .with_content(/^storeMetaDirectory\s+=\s+$/) \
      .with_content(/^sysMgmtdHost\s+=\s+$/)
  end
  
  it { should_not contain_file('') }
  
  context "with conf values defined" do
    let(:params) {
      {
        :store_meta_directory  => "/tank/fhgfs/meta",
        :mgmtd_host               => 'mgmt01',
      }
    }
    
    it do
      should contain_file('/etc/fhgfs/fhgfs-meta.conf') \
        .with_content(/^storeMetaDirectory\s+=\s#{params[:store_meta_directory]}$/) \
        .with_content(/^sysMgmtdHost\s+=\s+#{params[:mgmtd_host]}$/)
    end
    
    it do
      should contain_file(params[:store_meta_directory]).with({
        'ensure'  => 'directory',
        'before'  => 'Service[fhgfs-meta]',
      })
    end
  end
end

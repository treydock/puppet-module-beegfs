require 'spec_helper'

describe 'fhgfs::client' do

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
  it { should contain_class('fhgfs::helperd') }

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
    should contain_package('fhgfs-client').with({
      'ensure'    => 'present',
      'name'      => 'fhgfs-client',
      'require'   => 'Yumrepo[fhgfs]',
    })
  end

  it do
    should contain_service('fhgfs-client').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'fhgfs-client',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
      'require'     => [ 'File[/etc/fhgfs/fhgfs-client.conf]', 'Service[fhgfs-helperd]' ],
    })
  end

  it do
    should contain_file('/etc/fhgfs').with({
      'ensure'  => 'directory',
    })
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-client.conf').with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'before'  => 'Package[fhgfs-client]',
      'require' => 'File[/etc/fhgfs]',
      'notify'  => 'Service[fhgfs-client]',
    })
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-client.conf') \
      .with_content(/^logHelperdIP\s+=\s+$/) \
      .with_content(/^connMaxInternodeNum\s+=\s12$/) \
      .with_content(/^sysMgmtdHost\s+=\s+$/)
  end

  it do
     should contain_file('/etc/fhgfs/fhgfs-mounts.conf').with({
       'ensure'  => 'present',
       'owner'   => 'root',
       'group'   => 'root',
       'mode'    => '0644',
       'before'  => 'Package[fhgfs-client]',
       'require' => 'File[/etc/fhgfs]',
       'notify'  => 'Service[fhgfs-client]',
     })
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-mounts.conf') \
      .with_content(/^\/mnt\/fhgfs\s\/etc\/fhgfs\/fhgfs-client.conf$/)
  end

  it do
     should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf').with({
       'ensure'  => 'present',
       'owner'   => 'root',
       'group'   => 'root',
       'mode'    => '0644',
       'before'  => 'Package[fhgfs-client]',
       'require' => 'File[/etc/fhgfs]',
       'notify'  => 'Service[fhgfs-client]',
     })
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf') \
      .with_content(/^buildArgs=-j8$/)
  end

  context "with infiniband support via has_infiniband fact" do
    let :facts do
      {
        :fhgfs_version            => '2011.04',
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '6.4',
        :has_infiniband           => 'true',
      }
    end

    it do
      should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf') \
      .with_content(/^buildArgs=-j8\sFHGFS_OPENTK_IBVERBS=1$/)
    end
  end

  context "with infiniband support via has_infiniband fact, boolean value" do
    let :facts do
      {
        :fhgfs_version            => '2011.04',
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '6.4',
        :has_infiniband           => true,
      }
    end

    it do
      should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf') \
      .with_content(/^buildArgs=-j8\sFHGFS_OPENTK_IBVERBS=1$/)
    end
  end

  context "with infiniband support via parameter" do
    let :facts do
      {
        :fhgfs_version            => '2011.04',
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '6.4',
      }
    end

    let :params do
      {
        :with_infiniband  => 'true',
      }
    end

    it do
      should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf') \
        .with_content(/^buildArgs=-j8 FHGFS_OPENTK_IBVERBS=1$/)
    end
  end

  context "with conf values defined" do
    let(:params) {
      {
        :log_helperd_ip           => "192.168.1.1",
        :conn_max_internode_num   => '6',
        :mgmtd_host               => 'mgmt01',
        :mount_path               => '/fdata',
      }
    }

    it do
      should contain_file('/etc/fhgfs/fhgfs-client.conf') \
        .with_content(/^logHelperdIP\s+=\s192.168.1.1$/) \
        .with_content(/^connMaxInternodeNum\s+=\s6$/) \
        .with_content(/^sysMgmtdHost\s+=\smgmt01$/)
    end

    it do
      should contain_file('/etc/fhgfs/fhgfs-mounts.conf') \
        .with_content(/^\/fdata\s\/etc\/fhgfs\/fhgfs-client.conf$/)
    end
  end
end

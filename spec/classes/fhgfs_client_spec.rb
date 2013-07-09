require 'spec_helper'

describe 'fhgfs::client' do
  include_context :defaults

  let(:facts) { default_facts.merge({}) }
  let(:params) {{}}

  it { should contain_class('fhgfs::params') }
  it { should include_class('fhgfs') }
  it { should include_class('fhgfs::helperd') }

  include_context 'fhgfs'

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
    should contain_file('/etc/fhgfs/fhgfs-client.conf').with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => 'Package[fhgfs-client]',
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
       'require' => 'Package[fhgfs-client]',
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
       'require' => 'Package[fhgfs-client]',
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

require 'spec_helper'

describe 'fhgfs::client' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('fhgfs::client') }
  it { should contain_class('fhgfs::params') }
  it { should include_class('fhgfs') }
  it { should include_class('fhgfs::helperd') }

  it_behaves_like 'server files' do
    let(:name) { "fhgfs-client" }
  end

  it do
    should contain_package('fhgfs-client').with({
      'ensure'    => 'present',
      'name'      => 'fhgfs-client',
      'before'    => [
                      'File[/etc/fhgfs/fhgfs-client.conf]',
                      'File[/etc/fhgfs/fhgfs-mounts.conf]',
                      'File[/etc/fhgfs/fhgfs-client-autobuild.conf]',
                     ],
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
      'subscribe'   => [
                        'File[/etc/fhgfs/fhgfs-client.conf]',
                        'File[/etc/fhgfs/fhgfs-mounts.conf]',
                        'File[/etc/fhgfs/fhgfs-client-autobuild.conf]',
                       ],
      'require'     => 'Service[fhgfs-helperd]',
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
     })
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf') \
      .with_content(/^buildArgs=-j8 FHGFS_OPENTK_IBVERBS=0 FHGFS_INTENT=1$/)
  end

  context "with infiniband support via has_infiniband fact" do
    let(:facts) { default_facts.merge({:has_infiniband => 'true'}) }

    it do
      should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf') \
      .with_content(/^buildArgs=-j8\sFHGFS_OPENTK_IBVERBS=1 FHGFS_INTENT=1$/)
    end
  end

  context "with infiniband support via has_infiniband fact, boolean value" do
    let(:facts) { default_facts.merge({:has_infiniband => true}) }

    it do
      should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf') \
      .with_content(/^buildArgs=-j8\sFHGFS_OPENTK_IBVERBS=1 FHGFS_INTENT=1$/)
    end
  end

  context "with infiniband support via parameter" do
    let(:facts) { default_facts }
    let(:params) {{ :with_infiniband  => 'true' }}

    it do
      should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf') \
        .with_content(/^buildArgs=-j8 FHGFS_OPENTK_IBVERBS=1 FHGFS_INTENT=1$/)
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
  
  context 'with enable_intents => false' do
    let(:params) {{ :enable_intents => false }}
    
    it do
      should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf') \
        .with_content(/^buildArgs=-j8 FHGFS_OPENTK_IBVERBS=0 FHGFS_INTENT=0$/)
    end
  end
  
  context 'with enable_intents => "false"' do
    let(:params) {{ :enable_intents => 'false' }}
    
    it do
      should contain_file('/etc/fhgfs/fhgfs-client-autobuild.conf') \
        .with_content(/^buildArgs=-j8 FHGFS_OPENTK_IBVERBS=0 FHGFS_INTENT=0$/)
    end
  end
end

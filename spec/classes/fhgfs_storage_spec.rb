require 'spec_helper'

describe 'fhgfs::storage' do
  include_context :defaults

  let(:facts) { default_facts.merge({}) }
  let(:params) {{}}

  it { should contain_class('fhgfs::params') }
  it { should include_class('fhgfs') }

  include_context 'fhgfs'

  it do
    should contain_package('fhgfs-storage').with({
      'ensure'    => 'present',
      'name'      => 'fhgfs-storage',
      'require'   => 'Yumrepo[fhgfs]',
    })
  end

  it do
    should contain_service('fhgfs-storage').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'fhgfs-storage',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
      'require'     => 'File[/etc/fhgfs/fhgfs-storage.conf]',
    })
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-storage.conf').with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'before'  => 'Package[fhgfs-storage]',
      'require' => 'File[/etc/fhgfs]',
      'notify'  => 'Service[fhgfs-storage]',
    })
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-storage.conf') \
      .with_content(/^storeStorageDirectory\s+=\s+$/) \
      .with_content(/^sysMgmtdHost\s+=\s+$/)
  end

  it { should_not contain_file('') }

  context "with conf values defined" do
    let(:params) {
      {
        :store_storage_directory  => "/tank/fhgfs",
        :mgmtd_host               => 'mgmt01',
      }
    }

    it do
      should contain_file('/etc/fhgfs/fhgfs-storage.conf') \
        .with_content(/^storeStorageDirectory\s+=\s#{params[:store_storage_directory]}$/) \
        .with_content(/^sysMgmtdHost\s+=\s+#{params[:mgmtd_host]}$/)
    end

    it do
      should contain_file('/tank/fhgfs').with({
        'ensure'  => 'directory',
        'before'  => 'Service[fhgfs-storage]',
      })
    end
  end
  
  context 'with service_ensure => undef' do
    let :params do
      {
        :service_ensure => 'undef',
      }
    end

    it do
      should contain_service('fhgfs-storage').without_ensure
    end
  end

  shared_context "storage with conn_interfaces" do
    it { should contain_file('/etc/fhgfs/fhgfs-storage.conf').with_content(/^connInterfacesFile\s+=\s\/etc\/fhgfs\/interfaces$/) }
    it { should create_class('fhgfs::interfaces') }
  end

  shared_context "storage without conn_interfaces" do
    it { should contain_file('/etc/fhgfs/fhgfs-storage.conf').with_content(/^connInterfacesFile\s+=\s+$/) }
    it { should_not create_class('fhgfs::interfaces') }
  end

  context "storage with conn_interfaces => ['ib0','eth0']" do
    let(:params){{ :conn_interfaces => ['ib0','eth0'] }}

    include_context "storage with conn_interfaces"
  end
  
  context "storage with conn_interfaces => 'ib0,eth0'" do
    let(:params){{ :conn_interfaces => 'ib0,eth0' }}

    include_context "storage with conn_interfaces"
  end

  context "storage with conn_interfaces => []" do
    let(:params){{ :conn_interfaces => [] }}

    include_context "storage without conn_interfaces"
  end

  context "storage with conn_interfaces => ''" do
    let(:params){{ :conn_interfaces => '' }}

    include_context "storage without conn_interfaces"
  end
end

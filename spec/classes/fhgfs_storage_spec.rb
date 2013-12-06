require 'spec_helper'

describe 'fhgfs::storage' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('fhgfs::storage') }
  it { should contain_class('fhgfs::params') }
  it { should include_class('fhgfs') }

  it { should_not contain_class('fhgfs::interfaces') }

  it_behaves_like 'role service' do
    let(:service_name) { "fhgfs-storage" }
  end

  it_behaves_like 'role package' do
    let(:package_name) { "fhgfs-storage" }
  end

  it_behaves_like 'role files' do
    let(:name) { "fhgfs-storage" }
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-storage.conf') \
      .with_content(/^connInterfacesFile\s+=\s+$/) \
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

#    it do
#      should contain_file('/tank/fhgfs').with({
#        'ensure'  => 'directory',
#        'before'  => 'Service[fhgfs-storage]',
#      })
#    end
  end

  shared_context "storage with conn_interfaces" do
    it { should contain_file('/etc/fhgfs/fhgfs-storage.conf').with_content(/^connInterfacesFile\s+=\s\/etc\/fhgfs\/interfaces.storage$/) }
    it do
      should create_fhgfs__interfaces('storage').with({
        'interfaces'  => params[:conn_interfaces],
        'conf_path'   => '/etc/fhgfs/interfaces.storage',
        'service'     => 'fhgfs-storage',
        'restart'     => 'false',
      })
    end
  end

  shared_context "storage without conn_interfaces" do
    it { should contain_file('/etc/fhgfs/fhgfs-storage.conf').with_content(/^connInterfacesFile\s+=\s+$/) }
    it { should_not create_fhgfs__interfaces('storage') }
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

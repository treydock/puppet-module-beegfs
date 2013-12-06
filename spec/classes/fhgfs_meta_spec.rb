require 'spec_helper'

describe 'fhgfs::meta' do
  include_context :defaults

  let(:facts) { default_facts.merge({}) }
  let(:params) {{}}

  it { should contain_class('fhgfs::params') }
  it { should include_class('fhgfs') }

  it_behaves_like 'role service' do
    let(:service_name) { "fhgfs-meta" }
  end

  it_behaves_like 'role package' do
    let(:package_name) { "fhgfs-meta" }
  end

  it_behaves_like 'role files' do
    let(:name) { "fhgfs-meta" }
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-meta.conf') \
      .with_content(/^connInterfacesFile\s+=\s+$/) \
      .with_content(/^storeMetaDirectory\s+=\s+$/) \
      .with_content(/^sysMgmtdHost\s+=\s+$/)
  end

  it { should_not contain_file('') }

  context "with conf values defined" do
    let(:params) {
      {
        :store_meta_directory  => "/tank/fhgfs/meta",
        :mgmtd_host            => 'mgmt01',
      }
    }

    it do
      should contain_file('/etc/fhgfs/fhgfs-meta.conf') \
        .with_content(/^connInterfacesFile\s+=\s+$/) \
        .with_content(/^storeMetaDirectory\s+=\s#{params[:store_meta_directory]}$/) \
        .with_content(/^sysMgmtdHost\s+=\s+#{params[:mgmtd_host]}$/)
    end

#    it do
#      should contain_file(params[:store_meta_directory]).with({
#        'ensure'  => 'directory',
#        'before'  => 'Service[fhgfs-meta]',
#      })
#    end
  end

  shared_context "with conn_interfaces" do
    it { should contain_file('/etc/fhgfs/fhgfs-meta.conf').with_content(/^connInterfacesFile\s+=\s\/etc\/fhgfs\/interfaces.meta$/) }
    it do
      should create_fhgfs__interfaces('meta').with({
        'interfaces'  => params[:conn_interfaces],
        'conf_path'   => '/etc/fhgfs/interfaces.meta',
        'service'     => 'fhgfs-meta',
        'restart'     => 'false',
      })
    end
  end

  shared_context "without conn_interfaces" do
    it { should contain_file('/etc/fhgfs/fhgfs-meta.conf').with_content(/^connInterfacesFile\s+=\s+$/) }
    it { should_not create_fhgfs__interfaces('meta') }
  end

  context "with conn_interfaces => ['ib0','eth0']" do
    let(:params){{ :conn_interfaces => ['ib0','eth0'] }}

    include_context "with conn_interfaces"
  end
  
  context "with conn_interfaces => 'ib0,eth0'" do
    let(:params){{ :conn_interfaces => 'ib0,eth0' }}

    include_context "with conn_interfaces"
  end

  context "with conn_interfaces => []" do
    let(:params){{ :conn_interfaces => [] }}

    include_context "without conn_interfaces"
  end

  context "with conn_interfaces => ''" do
    let(:params){{ :conn_interfaces => '' }}

    include_context "without conn_interfaces"
  end
end

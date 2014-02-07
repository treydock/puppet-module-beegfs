require 'spec_helper'

describe 'fhgfs::mgmtd' do
  include_context :defaults

  let(:facts) { default_facts.merge({}) }
  let(:params) {{}}

  it { should create_class('fhgfs::mgmtd') }
  it { should contain_class('fhgfs::params') }
  it { should contain_class('fhgfs') }

  it_behaves_like 'role service' do
    let(:service_name) { "fhgfs-mgmtd" }
  end

  it_behaves_like 'role package' do
    let(:package_name) { "fhgfs-mgmtd" }
  end

  it_behaves_like 'role files' do
    let(:name) { "fhgfs-mgmtd" }
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-mgmtd.conf') \
      .with_content(/^storeMgmtdDirectory\s+=\s+$/) \
      .with_content(/^tuneNumWorkers\s+=\s+4$/)
  end

  it { should_not contain_file('') }

  context "with conf values defined" do
    let(:params) {{ :store_mgmtd_directory  => "/tank/fhgfs/mgmtd" }}

    it do
      should contain_file('/etc/fhgfs/fhgfs-mgmtd.conf') \
        .with_content(/^storeMgmtdDirectory\s+=\s#{params[:store_mgmtd_directory]}$/) \
        .with_content(/^tuneNumWorkers\s+=\s+4$/)
    end

#    it do
#      should contain_file(params[:store_mgmtd_directory]).with({
#        'ensure'  => 'directory',
#        'before'  => 'Service[fhgfs-mgmtd]',
#      })
#    end
  end

  shared_context "mgmtd with conn_interfaces" do
    it { should contain_file('/etc/fhgfs/fhgfs-mgmtd.conf').with_content(/^connInterfacesFile\s+=\s\/etc\/fhgfs\/interfaces.mgmtd$/) }
    it do
      should create_fhgfs__interfaces('mgmtd').with({
        'interfaces'  => params[:conn_interfaces],
        'conf_path'   => '/etc/fhgfs/interfaces.mgmtd',
        'service'     => 'fhgfs-mgmtd',
        'restart'     => 'false',
      })
    end
  end

  shared_context "mgmtd without conn_interfaces" do
    it { should contain_file('/etc/fhgfs/fhgfs-mgmtd.conf').with_content(/^connInterfacesFile\s+=\s+$/) }
    it { should_not create_fhgfs__interfaces('mgmtd') }
  end

  context "mgmtd with conn_interfaces => ['ib0','eth0']" do
    let(:params){{ :conn_interfaces => ['ib0','eth0'] }}

    include_context "mgmtd with conn_interfaces"
  end
  
  context "mgmtd with conn_interfaces => 'ib0,eth0'" do
    let(:params){{ :conn_interfaces => 'ib0,eth0' }}

    include_context "mgmtd with conn_interfaces"
  end

  context "mgmtd with conn_interfaces => []" do
    let(:params){{ :conn_interfaces => [] }}

    include_context "mgmtd without conn_interfaces"
  end

  context "mgmtd with conn_interfaces => ''" do
    let(:params){{ :conn_interfaces => '' }}

    include_context "mgmtd without conn_interfaces"
  end
end

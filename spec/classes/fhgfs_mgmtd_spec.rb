require 'spec_helper'

describe 'fhgfs::mgmtd' do
  include_context :defaults

  let(:facts) { default_facts.merge({}) }
  let(:params) {{}}

  it { should contain_class('fhgfs::params') }
  it { should include_class('fhgfs') }

  include_context 'fhgfs'

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
    should contain_file('/etc/fhgfs/fhgfs-mgmtd.conf').with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => 'Package[fhgfs-mgmtd]',
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
    let(:params) {{ :store_mgmtd_directory  => "/tank/fhgfs/mgmtd" }}

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

  shared_context "mgmtd with conn_interfaces" do
    it { should contain_file('/etc/fhgfs/fhgfs-mgmtd.conf').with_content(/^connInterfacesFile\s+=\s\/etc\/fhgfs\/interfaces$/) }
    it { should create_class('fhgfs::interfaces') }
  end

  shared_context "mgmtd without conn_interfaces" do
    it { should contain_file('/etc/fhgfs/fhgfs-mgmtd.conf').with_content(/^connInterfacesFile\s+=\s+$/) }
    it { should_not create_class('fhgfs::interfaces') }
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

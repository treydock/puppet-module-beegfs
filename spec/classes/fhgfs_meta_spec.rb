require 'spec_helper'

describe 'fhgfs::meta' do
  include_context :defaults

  let(:facts) { default_facts.merge({}) }
  let(:params) {{}}

  it { should contain_class('fhgfs::params') }
  it { should include_class('fhgfs') }

  include_context 'fhgfs'

  it do
    should contain_package('fhgfs-meta').with({
      'ensure'    => 'present',
      'name'      => 'fhgfs-meta',
      'before'    => 'File[/etc/fhgfs/fhgfs-meta.conf]',
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
      'subscribe'   => 'File[/etc/fhgfs/fhgfs-meta.conf]',
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
    })
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

    it do
      should contain_file(params[:store_meta_directory]).with({
        'ensure'  => 'directory',
        'before'  => 'Service[fhgfs-meta]',
      })
    end
  end

  shared_context "with conn_interfaces" do
    it { should contain_file('/etc/fhgfs/fhgfs-meta.conf').with_content(/^connInterfacesFile\s+=\s\/etc\/fhgfs\/interfaces$/) }
    it { should create_class('fhgfs::interfaces') }
  end

  shared_context "without conn_interfaces" do
    it { should contain_file('/etc/fhgfs/fhgfs-meta.conf').with_content(/^connInterfacesFile\s+=\s+$/) }
    it { should_not create_class('fhgfs::interfaces') }
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

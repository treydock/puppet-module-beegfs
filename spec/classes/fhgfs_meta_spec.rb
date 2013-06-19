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
    it { should contain_file('/etc/fhgfs/interfaces').with_content(/^ib0\neth0$/) }
  end

  context "with conn_interfaces => ['ib0','eth0']" do
    let(:params){{ :conn_interfaces => ['ib0','eth0'] }}

    include_context "with conn_interfaces"
  end
  
  context "with conn_interfaces => 'ib0,eth0'" do
    let(:params){{ :conn_interfaces => 'ib0,eth0' }}

    include_context "with conn_interfaces"
  end
end
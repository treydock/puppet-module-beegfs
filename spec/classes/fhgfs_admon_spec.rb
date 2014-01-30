require 'spec_helper'

describe 'fhgfs::admon' do
  include_context :defaults

  let(:facts) { default_facts.merge({}) }
  let(:params) {{}}

  it { should create_class('fhgfs::admon') }
  it { should contain_class('fhgfs::params') }
  it { should contain_class('fhgfs') }

  it_behaves_like 'role service' do
    let(:service_name) { "fhgfs-admon" }
  end

  it_behaves_like 'role package' do
    let(:package_name) { "fhgfs-admon" }
  end

  it_behaves_like 'role files' do
    let(:name) { "fhgfs-admon" }
  end

  it do
    should contain_file('/etc/fhgfs/fhgfs-admon.conf') \
      .with_content(/^sysMgmtdHost\s+=\s+$/) \
      .with_content(/^tuneNumWorkers\s+=\s+4$/)
  end

  context "with conf values defined" do
    let(:params) {{ :mgmtd_host  => "foo" }}

    it do
      should contain_file('/etc/fhgfs/fhgfs-admon.conf') \
        .with_content(/^sysMgmtdHost\s+=\s#{params[:mgmtd_host]}$/) \
        .with_content(/^tuneNumWorkers\s+=\s+4$/)
    end
  end
end

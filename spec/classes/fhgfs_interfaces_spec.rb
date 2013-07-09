require 'spec_helper'

describe 'fhgfs::interfaces' do
  include_context :defaults

  let(:facts) { default_facts.merge({}) }

  it { should contain_class('fhgfs::params') }

  shared_context "with interfaces" do
    it { should contain_file('/etc/fhgfs/interfaces').with_content(/^ib0\neth0$/) }
  end

  shared_context "without interfaces" do
    it { should_not contain_file('/etc/fhgfs/interfaces') }
  end

  context "with interfaces => ['ib0','eth0']" do
    let(:params){{ :interfaces => ['ib0','eth0'] }}

    include_context "with interfaces"
  end
  
  context "with interfaces => 'ib0,eth0'" do
    let(:params){{ :interfaces => 'ib0,eth0' }}

    include_context "with interfaces"
  end

  context "with interfaces => []" do
    let(:params){{ :interfaces => [] }}

    include_context "without interfaces"
  end

  context "with interfaces => ''" do
    let(:params){{ :interfaces => '' }}

    include_context "without interfaces"
  end
end

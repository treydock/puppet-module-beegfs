require 'spec_helper'

describe 'fhgfs::monitor' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:params) {{ :monitor_tool => 'zabbix' }}

  let(:pre_condition) { "class { 'fhgfs::client': }" }

  it { should create_class('fhgfs::monitor') }
  it { should contain_class('fhgfs::params') }
  it { should include_class('fhgfs::monitor::scripts') }
  it { should include_class('fhgfs::monitor::zabbix') }

  context "monitor_tool => 'foo'" do
    let(:params) {{ :monitor_tool => 'foo' }}

    it do
      expect {
        should include_class('fhgfs::monitor::foo')
      }.to raise_error(Puppet::Error, /does not match/)
    end
  end

  context "include_scripts => false" do
    let(:params) {{ :monitor_tool => 'zabbix', :include_scripts => false }}
    
    it { should_not include_class('fhgfs::monitor::scripts') }
  end
  
  context "include_scripts => 'false'" do
    let(:params) {{ :monitor_tool => 'zabbix', :include_scripts => 'false' }}

    it do
      expect {
        should include_class('fhgfs::monitor::scripts')
      }.to raise_error(Puppet::Error, /is not a boolean/)
    end
  end
end

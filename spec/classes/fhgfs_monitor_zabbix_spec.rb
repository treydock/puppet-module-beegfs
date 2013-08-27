require 'spec_helper'

describe 'fhgfs::monitor::zabbix' do
  include_context :defaults

  let :pre_condition do
    [
      "class { 'fhgfs::client': }",
      "class { 'fhgfs::monitor':
        monitor_tool      => 'zabbix',
      }",
    ]
  end

  let(:facts) { default_facts }

  it { should create_class('fhgfs::monitor::zabbix') }
  it { should include_class('fhgfs::monitor') }

  it do
    should contain_file('/etc/zabbix_agentd.conf.d/fhgfs.conf').with({
      'ensure'  => 'present',
      'source'  => 'puppet:///modules/fhgfs/monitor/zabbix/fhgfs.conf',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => 'File[/etc/zabbix_agentd.conf.d]',
      'notify'  => 'Service[zabbix-agent]',
    })
  end

  context "monitor_tool_conf_dir => '/etc/foo'" do
    let :pre_condition do
      [
        "class { 'fhgfs::client': }",
        "class { 'fhgfs::monitor':
          monitor_tool            => 'zabbix',
          monitor_tool_conf_dir   => '/etc/foo',
        }",
      ]
    end

    it { should contain_file('/etc/foo/fhgfs.conf') }
  end
end

require 'spec_helper'

describe 'fhgfs::monitor::scripts' do
  include_context :defaults

  let(:facts) { default_facts }

  let :pre_condition do
    [
      "class { 'sudo': }",
      "class { 'zabbix20::agent': }",
      "class { 'fhgfs::client': }",
      "class { 'fhgfs::monitor':
        monitor_tool  => 'zabbix',
      }",
    ]
  end

  it { should create_class('fhgfs::monitor::scripts') }
  it { should include_class('fhgfs::monitor') }

  it do
    should contain_file('fhgfs-pool-status.py').with({
      'ensure'  => 'present',
      'path'    => '/usr/local/bin/fhgfs-pool-status.py',
      'source'  => 'puppet:///modules/fhgfs/fhgfs-pool-status.py',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0755',
    })
  end
  
  context 'with scripts_dir => "/opt/fhgfs-scripts"' do
    let :pre_condition do
      [
        "class { 'sudo': }",
        "class { 'zabbix20::agent': }",
        "class { 'fhgfs::client': }",
        "class { 'fhgfs::monitor':
          monitor_tool  => 'zabbix',
          scripts_dir   => '/opt/fhgfs-scripts',
        }",
      ]
    end
    
    it { should contain_file('fhgfs-pool-status.py').with_path('/opt/fhgfs-scripts/fhgfs-pool-status.py') }
  end
end

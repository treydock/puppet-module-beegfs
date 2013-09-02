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
    should contain_file('fhgfs-iostat.rb').with({
      'ensure'  => 'present',
      'path'    => '/usr/local/bin/fhgfs-iostat.rb',
      'source'  => 'puppet:///modules/fhgfs/fhgfs-iostat.rb',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0755',
    })
  end

  it do
    should contain_file('fhgfs-poolstat.rb').with({
      'ensure'  => 'present',
      'path'    => '/usr/local/bin/fhgfs-poolstat.rb',
      'source'  => 'puppet:///modules/fhgfs/fhgfs-poolstat.rb',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0755',
    })
  end

  it do
    should contain_file('fhgfs-admon-get.rb').with({
      'ensure'  => 'present',
      'path'    => '/usr/local/bin/fhgfs-admon-get.rb',
      'source'  => 'puppet:///modules/fhgfs/fhgfs-admon-get.rb',
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
    
    it { should contain_file('fhgfs-iostat.rb').with_path('/opt/fhgfs-scripts/fhgfs-iostat.rb') }
    it { should contain_file('fhgfs-poolstat.rb').with_path('/opt/fhgfs-scripts/fhgfs-poolstat.rb') }
    it { should contain_file('fhgfs-admon-get.rb').with_path('/opt/fhgfs-scripts/fhgfs-admon-get.rb') }
  end
end

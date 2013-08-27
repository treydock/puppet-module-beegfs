require 'spec_helper'

describe 'fhgfs::monitor::sudo' do
  include_context :defaults
  
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

  let(:facts) { default_facts }

  it { should create_class('fhgfs::monitor::sudo') }
  it { should include_class('fhgfs::monitor') }
  it { should include_class('fhgfs::params') }

  it do
    should contain_file('/etc/sudoers.d/fhgfs').with({
      'ensure'  => 'present',
      'path'    => '/etc/sudoers.d/fhgfs',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0440',
      'require' => 'Package[sudo]',
    }) \
    .with_content(/^Defaults:zabbix !requiretty$/) \
    .with_content(/^Cmnd_Alias FHGFS_CMDS = \/usr\/bin\/fhgfs-ctl --iostat \*,\/usr\/bin\/fhgfs-ctl --listpools \*$/) \
    .with_content(/^zabbix ALL=\(ALL\) NOPASSWD: FHGFS_CMDS$/)
  end

  context "with monitor_sudo_commands as string" do
    let :pre_condition do
      [
        "class { 'sudo': }",
        "class { 'zabbix20::agent': }",
        "class { 'fhgfs::client': }",
        "class { 'fhgfs::monitor':
          monitor_tool  => 'zabbix',
          monitor_sudo_commands => 'cmd1,cmd2,cmd3',
        }",
      ]
    end

    it do
      should contain_file('/etc/sudoers.d/fhgfs') \
      .with_content(/^Cmnd_Alias FHGFS_CMDS = cmd1,cmd2,cmd3$/)
    end
  end
end

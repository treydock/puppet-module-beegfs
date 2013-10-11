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
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => 'File[/etc/zabbix_agentd.conf.d]',
      'notify'  => 'Service[zabbix-agent]',
    })
  end

  it do
    verify_contents(subject, '/etc/zabbix_agentd.conf.d/fhgfs.conf', [
      'UserParameter=fhgfs.list_unreachable,fhgfs-check-servers | grep UNREACHABLE | sed -r -e \'s/^(.*)\s+\[.*\]:\s+UNREACHABLE/\1/g\' | paste -sd ","',
      '# fhgfs.management.reachable',
      'UserParameter=fhgfs.management.reachable[*],fhgfs-ctl --listnodes --reachable --nodetype=management | grep -A1 \'^$1\s\[\' | grep -c "Reachable: <yes>"',
      '# fhgfs.metadata.reachable',
      'UserParameter=fhgfs.metadata.reachable[*],fhgfs-ctl --listnodes --reachable --nodetype=metadata | grep -A1 \'^$1\s\[\' | grep -c "Reachable: <yes>"',
      '# fhgfs.storage.reachable',
      'UserParameter=fhgfs.storage.reachable[*],fhgfs-ctl --listnodes --reachable --nodetype=storage | grep -A1 \'^$1\s\[\' | grep -c "Reachable: <yes>"',
      '# fhgfs.client.reachable',
      'UserParameter=fhgfs.client.reachable[*],fhgfs-ctl --listnodes --reachable --nodetype=client | grep -A1 \'^$1\s\[\' | grep -c "Reachable: <yes>"',
      'UserParameter=fhgfs.pool.status[*],/usr/local/bin/fhgfs-pool-status.py $1 $2',
      'UserParameter=fhgfs.client.num,fhgfs-ctl --listnodes --nodetype=client | wc -l',
    ])
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

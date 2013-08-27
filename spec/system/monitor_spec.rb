require 'spec_helper_system'

describe 'fhgfs::monitor class:' do
  context 'monitor_tool => zabbix' do
    # Temporary until the zabbix20 module is added to the Forge
    module_install_zabbix20 = <<-EOS
      yum -y install git
      git clone git://github.com/treydock/puppet-zabbix20.git /etc/puppet/modules/zabbix20
      puppet module install puppetlabs/firewall --modulepath /etc/puppet/modules
      puppet module install stahnma/epel --modulepath /etc/puppet/modules
    EOS
    
    context shell(module_install_zabbix20) do
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end

    pp = <<-EOS
      class { 'zabbix20::agent': }
      class { 'fhgfs::client':
        mgmtd_host  => 'localhost',
        utils_only  => true,
      }
      class { 'fhgfs::monitor': monitor_tool => 'zabbix' }
    EOS

    context puppet_apply(pp) do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end

  # Add other monitor_tool contexts here
end

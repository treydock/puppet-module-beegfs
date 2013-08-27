# == Class: fhgfs::monitor::zabbix
#
# Adds custom checks for Zabbix to monitor FhGFS
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::monitor::zabbix {

  include fhgfs::monitor

  $monitor_tool_conf_dir  = $fhgfs::monitor::monitor_tool_conf_dir_real

  $file_require = File[$monitor_tool_conf_dir]

  file { "${monitor_tool_conf_dir}/fhgfs.conf":
    ensure  => present,
    source  => 'puppet:///modules/fhgfs/monitor/zabbix/fhgfs.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => $file_require,
    notify  => Service['zabbix-agent'],
  }
}

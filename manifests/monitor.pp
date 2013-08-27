# == Class: fhgfs::monitor
#
# Adds monitoring capabilities for FhGFS
#
# === Parameters
#
# [*monitor_tool*]
#   Name of the application to be used.
#   Valid values are zabbix.
#   Required: true
#
# [*monitor_username*]
#   Username used by the monitoring tool's agent
#   Required: Dependent on value for monitor_tool
#
# [*monitor_tool_conf_dir*]
#   Directory to put monitoring tool's
#   configuration files.
#   Default: Dependent on value for monitor_tool
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::monitor (
  $monitor_tool,
  $monitor_username       = 'UNSET',
  $monitor_tool_conf_dir  = 'UNSET',
  $monitor_sudoers_path   = $fhgfs::params::monitor_sudoers_path,
  $manage_sudo            = true,
  $monitor_sudo_commands  = $fhgfs::params::monitor_sudo_commands,
  $include_scripts        = true
) inherits fhgfs::params {

  Class['fhgfs::utils'] -> Class['fhgfs::monitor']

  validate_re($monitor_tool, '^(zabbix)$')
  validate_bool($manage_sudo)
  validate_bool($include_scripts)

  $monitor_username_real = $monitor_username ? {
    'UNSET' => $fhgfs::params::monitor_tool_defaults[$monitor_tool]['username'],
    default => $monitor_username,
  }
  $monitor_tool_conf_dir_real = $monitor_tool_conf_dir ? {
    'UNSET' => $fhgfs::params::monitor_tool_defaults[$monitor_tool]['conf_dir'],
    default => $monitor_tool_conf_dir,
  }

  include "fhgfs::monitor::${monitor_tool}"
  if $manage_sudo { include fhgfs::monitor::sudo }
  if $include_scripts { include fhgfs::monitor::scripts }

}

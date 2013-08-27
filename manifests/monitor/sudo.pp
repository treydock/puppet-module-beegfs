# == Class: fhgfs::monitor::sudo
#
# Adds sudo policy for monitoring FhGFS
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::monitor::sudo {

  include fhgfs::monitor
  include fhgfs::params

  $username       = $fhgfs::monitor::monitor_username_real
  $sudoers_path   = $fhgfs::monitor::monitor_sudoers_path
  $sudo_commands  = $fhgfs::monitor::monitor_sudo_commands
  $os_maj_version = $fhgfs::params::os_maj_version

  $sudo_commands_real = is_string($sudo_commands) ? {
    true  => $sudo_commands,
    false => join($sudo_commands, ','),
  }

  file { '/etc/sudoers.d/fhgfs':
    ensure  => present,
    path    => $sudoers_path,
    content => template('fhgfs/fhgfs.sudoers.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    require => Package['sudo'],
  }
}

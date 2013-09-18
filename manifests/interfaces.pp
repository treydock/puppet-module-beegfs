# == Class: fhgfs::interfaces
#
# Manages a FHGFS Metadata server
#
# === Parameters
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
define fhgfs::interfaces (
  $interfaces = false,
  $conf_path  = 'UNSET',
  $service    = 'UNSET',
  $restart    = true
) {

  include fhgfs::params

  if $interfaces and !empty($interfaces) {
    $interfaces_real = is_array($interfaces) ? {
      true  => $interfaces,
      false => split($interfaces, ','),
    }
    validate_array($interfaces_real)
  } else {
    $interfaces_real = false
  }

  $conf_path_real = $conf_path ? {
    'UNSET' => "${fhgfs::params::interfaces_file}.${name}",
    default => $conf_path,
  }

  $service_real = $service ? {
    'UNSET' => undef,
    default => Service[$service],
  }

  $notify = $restart ? {
    true  => $service_real,
    false => undef,
  }

  if $interfaces_real {
    file { $conf_path_real:
      ensure  => 'present',
      content => template('fhgfs/interfaces.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['/etc/fhgfs'],
      notify  => $notify,
    }
  }

}

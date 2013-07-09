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
class fhgfs::interfaces (
  $interfaces         = false,
  $interfaces_file    = $fhgfs::params::interfaces_file,
  $service            = 'UNSET'
) inherits fhgfs::params {

  if $interfaces and !empty($interfaces) {
    $interfaces_real = is_array($interfaces) ? {
      true  => $interfaces,
      false => split($interfaces, ','),
    }
    validate_array($interfaces_real)
  } else {
    $interfaces_real = false
  }

  $service_real = $service ? {
    'UNSET' => undef,
    default => Service[$service],
  }

  if $interfaces_real {
    file { '/etc/fhgfs/interfaces':
      ensure  => 'present',
      path    => $interfaces_file,
      content => template('fhgfs/interfaces.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['/etc/fhgfs'],
      notify  => $service_real,
    }
  }

}

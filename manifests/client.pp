# == Class: fhgfs::client
#
# Manages a FHGFS client server
#
# === Parameters
#
# === Examples
#
#  class { 'fhgfs::client': }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::client (
  $mgmtd_host               = 'UNSET',
  $mount_path               = '/mnt/fhgfs',
  $with_infiniband          = $fhgfs::params::client_with_infiniband,
  $enable_intents           = true,
  $log_helperd_ip           = $fhgfs::params::log_helperd_ip,
  $conn_port_shift          = '0',
  $conn_max_internode_num   = '12',
  $quota_enabled            = false,
  $autobuild_enabled        = true,
  $include_utils            = true,
  $utils_only               = false,
  $manage_service           = true,
  $package_ensure           = 'UNSET'
) inherits fhgfs::params {

  include fhgfs

  validate_bool($include_utils)
  validate_bool($utils_only)
  validate_bool($manage_service)

  $mgmtd_host_real = $mgmtd_host ? {
    'UNSET' => $fhgfs::mgmtd_host,
    default => $mgmtd_host,
  }

  $package_ensure_real = $package_ensure ? {
    'UNSET' => $fhgfs::package_ensure,
    default => $package_ensure,
  }

  if $include_utils { include fhgfs::utils }

  if $utils_only {
    Class['fhgfs'] -> Class['fhgfs::client']

    $package_before     = [File['/etc/fhgfs/fhgfs-client.conf'],Service['fhgfs-client']]
    $service_ensure     = false
    $service_enable     = false
    $service_subscribe  = undef
    $service_require    = undef
  } else {
    include fhgfs::client::helperd

    Class['fhgfs'] -> Class['fhgfs::client::helperd'] -> Class['fhgfs::client']

    $package_before     = [ File['/etc/fhgfs/fhgfs-client.conf'],
                            File['/etc/fhgfs/fhgfs-mounts.conf'],
                            File['/etc/fhgfs/fhgfs-client-autobuild.conf'],
                            ]
    $service_ensure     = true
    $service_enable     = true
    $service_subscribe  = $package_before
    $service_require    = Service['fhgfs-helperd']
  }

  $package_name     = $fhgfs::params::client_package_name
  $service_name     = $fhgfs::params::client_service_name

  $with_infiniband_real = is_string($with_infiniband) ? {
    true  => str2bool($with_infiniband),
    false => $with_infiniband,
  }
  validate_bool($with_infiniband_real)

  $enable_intents_real = is_string($enable_intents) ? {
    true  => str2bool($enable_intents),
    false => $enable_intents,
  }
  validate_bool($enable_intents_real)

  $config_file_before = $manage_service ? {
    true  => Service['fhgfs-client'],
    false => undef,
  }

  if $with_infiniband_real {
    $autobuild_opentk_ibverbs = '1'
  } else {
    $autobuild_opentk_ibverbs = '0'
  }

  if $enable_intents_real {
    $autobuild_intent = '1'
  } else {
    $autobuild_intent = '0'
  }

  ensure_resource('file', '/etc/fhgfs', {'ensure' => 'directory'})

  package { 'fhgfs-client':
    ensure  => $package_ensure_real,
    name    => $package_name,
    before  => $package_before,
    require => Yumrepo['fhgfs'],
  }

  if $manage_service {
    service { 'fhgfs-client':
      ensure      => $service_ensure,
      enable      => $service_enable,
      name        => $service_name,
      hasstatus   => true,
      hasrestart  => true,
      subscribe   => $service_subscribe,
      require     => $service_require,
    }
  }

  file { '/etc/fhgfs/fhgfs-client.conf':
    ensure  => 'present',
    content => template('fhgfs/fhgfs-client.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => $config_file_before,
  }

  file { '/etc/fhgfs/fhgfs-mounts.conf':
    ensure  => 'present',
    content => template('fhgfs/fhgfs-mounts.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => $config_file_before,
  }

  file { '/etc/fhgfs/fhgfs-client-autobuild.conf':
    ensure  => 'present',
    content => template('fhgfs/fhgfs-client-autobuild.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    before  => $config_file_before,
  }

}

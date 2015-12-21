# == Class: beegfs
class beegfs (
  # which subcomponents should be managed
  $client     = true,
  $mgmtd      = false,
  $meta       = false,
  $storage    = false,
  $admon      = false,
  $utils_only = false,

  # packages
  $release                      = '2015.03',
  $version                      = 'present',
  $repo_descr                   = undef,
  $repo_baseurl                 = undef,
  $repo_gpgkey                  = undef,
  $repo_gpgcheck                = '0',
  $repo_enabled                 = '1',
  $client_package_dependencies  = $beegfs::params::client_package_dependencies,
  $manage_client_dependencies   = true,

  # common configuration
  $mgmtd_host       = '',
  $conn_port_shift  = '0',

  # interfaces
  $client_conn_interfaces       = [],
  $client_conn_interfaces_file  = $beegfs::params::conn_interfaces_file['client'],
  $mgmtd_conn_interfaces        = [],
  $mgmtd_conn_interfaces_file   = $beegfs::params::conn_interfaces_file['mgmtd'],
  $meta_conn_interfaces         = [],
  $meta_conn_interfaces_file    = $beegfs::params::conn_interfaces_file['meta'],
  $storage_conn_interfaces      = [],
  $storage_conn_interfaces_file = $beegfs::params::conn_interfaces_file['storage'],

  # net filters
  $client_conn_net_filters      = [],
  $client_conn_net_filter_file  = $beegfs::params::conn_net_filter_file['client'],
  $mgmtd_conn_net_filters       = [],
  $mgmtd_conn_net_filter_file   = $beegfs::params::conn_net_filter_file['mgmtd'],
  $meta_conn_net_filters        = [],
  $meta_conn_net_filter_file    = $beegfs::params::conn_net_filter_file['meta'],
  $storage_conn_net_filters     = [],
  $storage_conn_net_filter_file = $beegfs::params::conn_net_filter_file['storage'],
  $conn_tcp_only_filters        = [],
  $conn_tcp_only_filter_file    = $beegfs::params::conn_tcp_only_filter_file,

  # client specific - config
  $client_mount_path          = '/mnt/beegfs',
  $client_build_args          = $beegfs::params::client_build_args,
  $client_build_enabled       = true,
  $client_config_overrides    = {},
  $helperd_config_overrides   = {},
  # client specific - packages
  $client_package             = $beegfs::params::client_package,
  $helperd_package            = $beegfs::params::helperd_package,
  $utils_package              = $beegfs::params::utils_package,
  # client specific - services
  $client_manage_service      = true,
  $client_service_name        = $beegfs::params::client_service_name,
  $helperd_service_name       = $beegfs::params::helperd_service_name,
  $client_service_ensure      = 'running',
  $client_service_enable      = true,
  $client_service_autorestart = true,

  # mgmtd specific - config
  $mgmtd_store_directory      = '',
  $mgmtd_config_overrides     = {},
  # mgmtd specific - packages
  $mgmtd_package              = $beegfs::params::mgmtd_package,
  # mgmtd specific - service
  $mgmtd_manage_service       = true,
  $mgmtd_service_name         = $beegfs::params::mgmtd_service_name,
  $mgmtd_service_ensure       = 'running',
  $mgmtd_service_enable       = true,
  $mgmtd_service_autorestart  = false,

  # meta specific - config
  $meta_store_directory     = '',
  $meta_config_overrides    = {},
  # meta specific - packages
  $meta_package             = $beegfs::params::meta_package,
  # meta specific - service
  $meta_manage_service      = true,
  $meta_service_name        = $beegfs::params::meta_service_name,
  $meta_service_ensure      = 'running',
  $meta_service_enable      = true,
  $meta_service_autorestart = false,

  # storage specific - config
  $storage_store_directory      = '',
  $storage_config_overrides     = {},
  # storage specific - packages
  $storage_package              = $beegfs::params::storage_package,
  # storage specific - service
  $storage_manage_service       = true,
  $storage_service_name         = $beegfs::params::storage_service_name,
  $storage_service_ensure       = 'running',
  $storage_service_enable       = true,
  $storage_service_autorestart  = false,

  # admon specific - config
  $admon_database_file_dir    = '/var/lib/beegfs',
  $admon_config_overrides     = {},
  # admon specific - packages
  $admon_package              = $beegfs::params::admon_package,
  # admon specific - service
  $admon_manage_service       = true,
  $admon_service_name         = $beegfs::params::admon_service_name,
  $admon_service_ensure       = 'running',
  $admon_service_enable       = true,
  $admon_service_autorestart  = false,

  # Upgrade specific
  $perform_fhgfs_upgrade      = false,
) inherits beegfs::params {

  validate_bool($client)
  validate_bool($mgmtd)
  validate_bool($meta)
  validate_bool($storage)
  validate_bool($admon)
  validate_bool($utils_only)

  if ! member(['2015.03'], $release) {
    fail("${module_name}: Only release 2015.03 is supported, ${release} given.")
  }

  validate_re($repo_gpgcheck, '^(1|0)$')
  validate_re($repo_enabled, '^(1|0)$')
  validate_bool($manage_client_dependencies)

  validate_bool($client_build_enabled)
  validate_bool($client_manage_service)
  validate_bool($client_service_autorestart)
  validate_bool($mgmtd_manage_service)
  validate_bool($mgmtd_service_autorestart)
  validate_bool($meta_manage_service)
  validate_bool($meta_service_autorestart)
  validate_bool($storage_manage_service)
  validate_bool($storage_service_autorestart)
  validate_bool($admon_manage_service)
  validate_bool($admon_service_autorestart)

  validate_array($client_conn_interfaces)
  validate_array($mgmtd_conn_interfaces)
  validate_array($meta_conn_interfaces)
  validate_array($storage_conn_interfaces)
  validate_array($client_conn_net_filters, $mgmtd_conn_net_filters, $meta_conn_net_filters, $storage_conn_net_filters)

  validate_hash($client_config_overrides)
  validate_hash($helperd_config_overrides)
  validate_hash($mgmtd_config_overrides)
  validate_hash($meta_config_overrides)
  validate_hash($storage_config_overrides)
  validate_hash($admon_config_overrides)

  validate_bool($perform_fhgfs_upgrade)

  anchor { 'beegfs::start': }
  anchor { 'beegfs::end': }

  if $perform_fhgfs_upgrade {
    include beegfs::upgrade::fhgfs_to_beegfs
  }

  if empty($conn_tcp_only_filters) {
    $_conn_tcp_only_filter_file_value   = ''
    $_conn_tcp_only_filter_file_ensure  = 'absent'
  } else {
    $_conn_tcp_only_filter_file_value   = $conn_tcp_only_filter_file
    $_conn_tcp_only_filter_file_ensure  = 'present'
  }

  ## beegfs-client ##

  if $client or $utils_only {
    if $client_service_autorestart {
      $client_service_subscribe   = [
        File['/etc/beegfs/beegfs-client.conf'],
        #Augeas['beegfs-client.conf'],
        File['/etc/beegfs/beegfs-mounts.conf'],
        File[$client_conn_interfaces_file],
        File[$client_conn_net_filter_file],
        File[$conn_tcp_only_filter_file],
        File_line['beegfs-client-autobuild buildArgs'],
        File_line['beegfs-client-autobuild buildEnabled']
      ]
      $helperd_service_subscribe  = File['/etc/beegfs/beegfs-helperd.conf']
    } else {
      $client_service_subscribe   = undef
      $helperd_service_subscribe  = undef
    }

    if empty($client_conn_interfaces) {
      $client_conn_interfaces_file_value  = ''
      $client_conn_interfaces_file_ensure = 'absent'
    } else {
      $client_conn_interfaces_file_value  = $client_conn_interfaces_file
      $client_conn_interfaces_file_ensure = 'present'
    }

    if empty($client_conn_net_filters) {
      $client_conn_net_filter_file_value  = ''
      $client_conn_net_filter_file_ensure = 'absent'
    } else {
      $client_conn_net_filter_file_value  = $client_conn_net_filter_file
      $client_conn_net_filter_file_ensure = 'present'
    }

    $helperd_local_configs = {
      'connPortShift'       => $conn_port_shift,
    }

    $client_local_configs = {
      'connPortShift'         => $conn_port_shift,
      'connInterfacesFile'    => $client_conn_interfaces_file_value,
      'connNetFilterFile'     => $client_conn_net_filter_file_value,
      'connTcpOnlyFilterFile' => $_conn_tcp_only_filter_file_value,
      'sysMgmtdHost'          => $mgmtd_host,
    }

    $helperd_default_configs  = merge($beegfs::params::helperd_default_configs[$release], $helperd_local_configs)
    $helperd_configs          = merge($helperd_default_configs, $helperd_config_overrides)
    $helperd_config_keys      = $beegfs::params::helperd_config_keys[$release]

    $client_default_configs = merge($beegfs::params::client_default_configs[$release], $client_local_configs)
    $client_configs         = merge($client_default_configs, $client_config_overrides)
    $client_config_keys     = $beegfs::params::client_config_keys[$release]

    include beegfs::client

    Anchor['beegfs::start']->
    Class['beegfs::client']->
    Anchor['beegfs::end']
  }

  ## beegfs-mgmtd ##

  if $mgmtd {
    if $mgmtd_service_autorestart {
      $mgmtd_service_subscribe = [
        File['/etc/beegfs/beegfs-mgmtd.conf'],
        File[$mgmtd_conn_interfaces_file],
        File[$mgmtd_conn_net_filter_file],
      ]
    } else {
      $mgmtd_service_subscribe = undef
    }

    if empty($mgmtd_conn_interfaces) {
      $mgmtd_conn_interfaces_file_value   = ''
      $mgmtd_conn_interfaces_file_ensure  = 'absent'
    } else {
      $mgmtd_conn_interfaces_file_value   = $mgmtd_conn_interfaces_file
      $mgmtd_conn_interfaces_file_ensure  = 'present'
    }

    if empty($mgmtd_conn_net_filters) {
      $mgmtd_conn_net_filter_file_value   = ''
      $mgmtd_conn_net_filter_file_ensure  = 'absent'
    } else {
      $mgmtd_conn_net_filter_file_value   = $mgmtd_conn_net_filter_file
      $mgmtd_conn_net_filter_file_ensure  = 'present'
    }

    $mgmtd_local_configs = {
      'connPortShift'       => $conn_port_shift,
      'connInterfacesFile'  => $mgmtd_conn_interfaces_file_value,
      'connNetFilterFile'   => $mgmtd_conn_net_filter_file_value,
      'storeMgmtdDirectory' => $mgmtd_store_directory,
    }

    $mgmtd_default_configs  = merge($beegfs::params::mgmtd_default_configs[$release], $mgmtd_local_configs)
    $mgmtd_configs          = merge($mgmtd_default_configs, $mgmtd_config_overrides)
    $mgmtd_config_keys      = $beegfs::params::mgmtd_config_keys[$release]

    include beegfs::mgmtd

    Anchor['beegfs::start']->
    Class['beegfs::mgmtd']->
    Anchor['beegfs::end']
  }

  ## beegfs-meta ##

  if $meta {
    if $meta_service_autorestart {
      $meta_service_subscribe = [
        File['/etc/beegfs/beegfs-meta.conf'],
        File[$meta_conn_interfaces_file],
        File[$meta_conn_net_filter_file],
        File[$conn_tcp_only_filter_file],
      ]
    } else {
      $meta_service_subscribe = undef
    }

    if empty($meta_conn_interfaces) {
      $meta_conn_interfaces_file_value   = ''
      $meta_conn_interfaces_file_ensure  = 'absent'
    } else {
      $meta_conn_interfaces_file_value   = $meta_conn_interfaces_file
      $meta_conn_interfaces_file_ensure  = 'present'
    }

    if empty($meta_conn_net_filters) {
      $meta_conn_net_filter_file_value   = ''
      $meta_conn_net_filter_file_ensure  = 'absent'
    } else {
      $meta_conn_net_filter_file_value   = $meta_conn_net_filter_file
      $meta_conn_net_filter_file_ensure  = 'present'
    }

    $meta_local_configs = {
      'connPortShift'         => $conn_port_shift,
      'connInterfacesFile'    => $meta_conn_interfaces_file_value,
      'connNetFilterFile'     => $meta_conn_net_filter_file_value,
      'connTcpOnlyFilterFile' => $_conn_tcp_only_filter_file_value,
      'storeMetaDirectory'    => $meta_store_directory,
      'sysMgmtdHost'          => $mgmtd_host,
    }

    $meta_default_configs  = merge($beegfs::params::meta_default_configs[$release], $meta_local_configs)
    $meta_configs          = merge($meta_default_configs, $meta_config_overrides)
    $meta_config_keys      = $beegfs::params::meta_config_keys[$release]

    include beegfs::meta

    Anchor['beegfs::start']->
    Class['beegfs::meta']->
    Anchor['beegfs::end']
  }

  ## beegfs-storage ##

  if $storage {
    if $storage_service_autorestart {
      $storage_service_subscribe = [
        File['/etc/beegfs/beegfs-storage.conf'],
        File[$storage_conn_interfaces_file],
        File[$storage_conn_net_filter_file],
        File[$conn_tcp_only_filter_file],
      ]
    } else {
      $storage_service_subscribe = undef
    }

    if empty($storage_conn_interfaces) {
      $storage_conn_interfaces_file_value   = ''
      $storage_conn_interfaces_file_ensure  = 'absent'
    } else {
      $storage_conn_interfaces_file_value   = $storage_conn_interfaces_file
      $storage_conn_interfaces_file_ensure  = 'present'
    }

    if empty($storage_conn_net_filters) {
      $storage_conn_net_filter_file_value   = ''
      $storage_conn_net_filter_file_ensure  = 'absent'
    } else {
      $storage_conn_net_filter_file_value   = $storage_conn_net_filter_file
      $storage_conn_net_filter_file_ensure  = 'present'
    }

    $storage_local_configs = {
      'connPortShift'         => $conn_port_shift,
      'connInterfacesFile'    => $storage_conn_interfaces_file_value,
      'connNetFilterFile'     => $storage_conn_net_filter_file_value,
      'connTcpOnlyFilterFile' => $_conn_tcp_only_filter_file_value,
      'storeStorageDirectory' => $storage_store_directory,
      'sysMgmtdHost'          => $mgmtd_host,
    }

    $storage_default_configs  = merge($beegfs::params::storage_default_configs[$release], $storage_local_configs)
    $storage_configs          = merge($storage_default_configs, $storage_config_overrides)
    $storage_config_keys      = $beegfs::params::storage_config_keys[$release]

    include beegfs::storage

    Anchor['beegfs::start']->
    Class['beegfs::storage']->
    Anchor['beegfs::end']
  }

  ## beegfs-admon ##

  if $admon {
    if $admon_service_autorestart {
      $admon_service_subscribe = File['/etc/beegfs/beegfs-admon.conf']
    } else {
      $admon_service_subscribe = undef
    }

    $admon_local_configs = {
      'connPortShift' => $conn_port_shift,
      'sysMgmtdHost'  => $mgmtd_host,
      'databaseFile'  => "${admon_database_file_dir}/beegfs-admon.db",
    }

    $admon_default_configs  = merge($beegfs::params::admon_default_configs[$release], $admon_local_configs)
    $admon_configs          = merge($admon_default_configs, $admon_config_overrides)
    $admon_config_keys      = $beegfs::params::admon_config_keys[$release]

    include beegfs::admon

    Anchor['beegfs::start']->
    Class['beegfs::admon']->
    Anchor['beegfs::end']
  }

}

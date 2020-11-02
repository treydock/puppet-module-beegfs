# @summary Manage BeeGFS
#
# @example
#   include beegfs
#
# @param client
#   Boolean that determines if managing BeeGFS client components
# @param mgmtd
#   Boolean that determines if managing BeeGFS Mgmtd components
# @param meta
#   Boolean that determines if managing BeeGFS Meta components
# @param storage
#   Boolean that determines if managing BeeGFS Storage components
# @param admon
#   Boolean that determines if managing BeeGFS Admon components
# @param utils_only
#   Boolean that determines if only BeeGFS utility packages are deployed, ie do not deploy daemons or configs
# @param customer_login
#   The login to use for commercial access to BeeGFS repos
# @param release
#   The release of BeeGFS to install
# @param version
#   The version of BeeGFS to install
# @param repo_descr
#   The BeeGFS repo descr
# @param repo_baseurl
#   The BeeGFS repo baseurl
# @param repo_gpgkey
#   The BeeGFS repo gpgkey
# @param repo_gpgcheck
#   The BeeGFS repo gpgcheck
# @param repo_enabled
#   The BeeGFS repo enabled
# @param client_package_dependencies
#   The package dependencies for BeeGFS client
# @param manage_client_dependencies
#   Boolean that sets if BeeGFS client dependencies will be managed
# @param mgmtd_host
#   The BeeGFS mgmtd host
# @param conn_port_shift
#   The configuration value for connPortShift
# @param client_conn_interfaces
#   The values used to define connInterfacesFile on clients
#   Mutially exclusive with client_conn_interfaces_file
# @param client_conn_interfaces_file
#   The value for connInterfacesFile on clients
#   Mutially exclusive with client_conn_interfaces
# @param mgmtd_conn_interfaces
#   The values used to define connInterfacesFile on mgmtd
#   Mutially exclusive with mgmtd_conn_interfaces_file
# @param mgmtd_conn_interfaces_file
#   The value for connInterfacesFile on mgmtd
#   Mutially exclusive with mgmtd_conn_interfaces
# @param meta_conn_interfaces
#   The values used to define connInterfacesFile on metadata
#   Mutially exclusive with meta_conn_interfaces_file
# @param meta_conn_interfaces_file
#   The value for connInterfacesFile on metadata
#   Mutially exclusive with meta_conn_interfaces
# @param storage_conn_interfaces
#   The values used to define connInterfacesFile on storage
#   Mutially exclusive with storage_conn_interfaces_file
# @param storage_conn_interfaces_file
#   The value for connInterfacesFile on storage
#   Mutially exclusive with storage_conn_interfaces
# @param admon_conn_interfaces
#   The values used to define connInterfacesFile on admon
#   Mutially exclusive with admon_conn_interfaces_file
# @param admon_conn_interfaces_file
#   The value for connInterfacesFile on admon
#   Mutially exclusive with admon_conn_interfaces
# @param client_conn_net_filters
#   The value used to define connNetFilterFile on clients
#   Mutially exclusive with client_conn_net_filter_file
# @param client_conn_net_filter_file
#   The value for connNetFilterFile on clients
#   Mutially exclusive with client_conn_net_filter
# @param mgmtd_conn_net_filters
#   The value used to define connNetFilterFile on mgmtd
#   Mutially exclusive with mgmtd_conn_net_filter_file
# @param mgmtd_conn_net_filter_file
#   The value for connNetFilterFile on mgmtd
#   Mutially exclusive with mgmtd_conn_net_filter
# @param meta_conn_net_filters
#   The value used to define connNetFilterFile on metadata
#   Mutially exclusive with meta_conn_net_filter_file
# @param meta_conn_net_filter_file
#   The value for connNetFilterFile on metadata
#   Mutially exclusive with meta_conn_net_filter
# @param storage_conn_net_filters
#   The value used to define connNetFilterFile on storage
#   Mutially exclusive with storage_conn_net_filter_file
# @param storage_conn_net_filter_file
#   The value for connNetFilterFile on storage
#   Mutially exclusive with storage_conn_net_filter
# @param admon_conn_net_filters
#   The value used to define connNetFilterFile on admon
#   Mutially exclusive with admon_conn_net_filter_file
# @param admon_conn_net_filter_file
#   The value for connNetFilterFile on admon
#   Mutially exclusive with admon_conn_net_filter
# @param conn_tcp_only_filters
#   The value used to populate /etc/beegfs/tcp-only-filter
# @param conn_tcp_only_filter_file
#   Path to /etc/beegfs/tcp-only-filter
# @param ib_package
#   Package name for libbeegfs-ib
# @param with_rdma
#   Enable RDMA support with BeeGFS
# @param client_mount_path
#   Path to mount BeeGFS filesystem on client
# @param manage_client_mount_path
#   Manage the BeeGFS client mount path
# @param client_build_args
#   Value for client buildArgs
# @param client_build_enabled
#   Value for client buildEnabled
# @param client_config_overrides
#   Additional client configurations
# @param helperd_config_overrides
#   Additional helperd configurations
# @param client_package
#   Client package name
# @param helperd_package
#   Client helperd package name
# @param utils_package
#   Package name for beegfs utils
# @param client_manage_service
#   Boolean whether to manage client service
# @param client_service_name
#   Client service name
# @param helperd_service_name
#   Helperd service name
# @param client_service_ensure
#   Client service ensure
# @param client_service_enable
#   Client service enable
# @param client_service_autorestart
#   Boolean to set if client will autorestart on changes
# @param mgmtd_store_directory
#   The path to mgmtd storage directory
# @param mgmtd_config_overrides
#   Additional mgmtd configurations
# @param mgmtd_package
#   The BeeGFS mgmtd package
# @param mgmtd_manage_service
#   Boolean to set if mgmtd service is managed
# @param mgmtd_service_name
#   The BeeGFS mgmtd service name
# @param mgmtd_service_ensure
#   The beegfs-mgmtd service ensure
# @param mgmtd_service_enable
#   The beegfs-mgmtd service enable
# @param mgmtd_service_autorestart
#   Boolean to set if beegfs-mgmtd will autorestart on changes
# @param meta_store_directory
#   The BeeGFS metadata storage directory
# @param meta_config_overrides
#   Additional metadata configurations
# @param meta_package
#   The BeeGFS metadata package
# @param meta_manage_service
#   Boolean to set if beegfs-meta service is managed
# @param meta_service_name
#   The BeeGFS metadata service name
# @param meta_service_ensure
#   The beegfs-meta service ensure
# @param meta_service_enable
#   The beegfs-meta service enable
# @param meta_service_autorestart
#   Boolean to set if beegfs-meta will autorestart on changes
# @param storage_store_directory
#   The BeeGFS storage daemon storage directory
# @param storage_config_overrides
#   Additional storage configurations
# @param storage_package
#   The BeeGFS storage package name
# @param storage_manage_service
#   Boolean to set if beegfs-storage service is managed
# @param storage_service_name
#   The BeeGFS storage service name
# @param storage_service_ensure
#   The beegfs-storage service ensure
# @param storage_service_enable
#   The beegfs-storage service enable
# @param storage_service_autorestart
#   Boolean to set if beegfs-storage will autorestart on changes
# @param admon_database_file_dir
#   The path to BeeGFS admon database directory
# @param admon_config_overrides
#   Additional BeeGFS Admon configurations
# @param admon_package
#   The BeeGFS Admon package name
# @param admon_manage_service
#   Boolean to set if beegfs-admon service is managed
# @param admon_service_name
#   The BeeGFS Admon service name
# @param admon_service_ensure
#   The beegfs-admon service ensure
# @param admon_service_enable
#   The beegfs-admon service enable
# @param admon_service_autorestart
#   Boolean to set if beegfs-admon will autorestart on changes
#
class beegfs (
  # which subcomponents should be managed
  Boolean $client     = true,
  Boolean $mgmtd      = false,
  Boolean $meta       = false,
  Boolean $storage    = false,
  Boolean $admon      = false,
  Boolean $utils_only = false,

  Optional[String] $customer_login = undef,

  # packages
  String $release                       = '7.1',
  String $version                       = 'present',
  Optional[String] $repo_descr          = undef,
  Optional[String] $repo_baseurl        = undef,
  Optional[String] $repo_gpgkey         = undef,
  Enum['0','1'] $repo_gpgcheck          = '0',
  Enum['0','1'] $repo_enabled           = '1',
  Array $client_package_dependencies    = $beegfs::params::client_package_dependencies,
  Boolean $manage_client_dependencies   = true,

  # common configuration
  String $mgmtd_host       = '',
  Integer $conn_port_shift  = 0,

  # interfaces
  Array $client_conn_interfaces       = [],
  Stdlib::Absolutepath $client_conn_interfaces_file  = $beegfs::params::conn_interfaces_file['client'],
  Array $mgmtd_conn_interfaces        = [],
  Stdlib::Absolutepath $mgmtd_conn_interfaces_file   = $beegfs::params::conn_interfaces_file['mgmtd'],
  Array $meta_conn_interfaces         = [],
  Stdlib::Absolutepath $meta_conn_interfaces_file    = $beegfs::params::conn_interfaces_file['meta'],
  Array $storage_conn_interfaces      = [],
  Stdlib::Absolutepath $storage_conn_interfaces_file = $beegfs::params::conn_interfaces_file['storage'],
  Array $admon_conn_interfaces        = [],
  Stdlib::Absolutepath $admon_conn_interfaces_file   = $beegfs::params::conn_interfaces_file['admon'],

  # net filters
  Array $client_conn_net_filters      = [],
  Stdlib::Absolutepath $client_conn_net_filter_file  = $beegfs::params::conn_net_filter_file['client'],
  Array $mgmtd_conn_net_filters       = [],
  Stdlib::Absolutepath $mgmtd_conn_net_filter_file   = $beegfs::params::conn_net_filter_file['mgmtd'],
  Array $meta_conn_net_filters        = [],
  Stdlib::Absolutepath $meta_conn_net_filter_file    = $beegfs::params::conn_net_filter_file['meta'],
  Array $storage_conn_net_filters     = [],
  Stdlib::Absolutepath $storage_conn_net_filter_file = $beegfs::params::conn_net_filter_file['storage'],
  Array $admon_conn_net_filters       = [],
  Stdlib::Absolutepath $admon_conn_net_filter_file   = $beegfs::params::conn_net_filter_file['admon'],
  Array $conn_tcp_only_filters        = [],
  Stdlib::Absolutepath $conn_tcp_only_filter_file    = $beegfs::params::conn_tcp_only_filter_file,

  # RDMA specific
  String $ib_package = $beegfs::params::ib_package,
  Boolean $with_rdma = $beegfs::params::with_rdma,

  # client specific - config
  Stdlib::Absolutepath $client_mount_path = '/mnt/beegfs',
  Boolean $manage_client_mount_path = true,
  String $client_build_args = $beegfs::params::client_build_args,
  Boolean $client_build_enabled = true,
  Hash $client_config_overrides = {},
  Hash $helperd_config_overrides   = {},
  # client specific - packages
  String $client_package             = $beegfs::params::client_package,
  String $helperd_package            = $beegfs::params::helperd_package,
  String $utils_package              = $beegfs::params::utils_package,
  # client specific - services
  Boolean $client_manage_service      = true,
  String $client_service_name        = $beegfs::params::client_service_name,
  String $helperd_service_name       = $beegfs::params::helperd_service_name,
  String $client_service_ensure      = 'running',
  Boolean $client_service_enable      = true,
  Boolean $client_service_autorestart = true,

  # mgmtd specific - config
  $mgmtd_store_directory      = '',
  Hash $mgmtd_config_overrides     = {},
  # mgmtd specific - packages
  String $mgmtd_package              = $beegfs::params::mgmtd_package,
  # mgmtd specific - service
  Boolean $mgmtd_manage_service       = true,
  String $mgmtd_service_name         = $beegfs::params::mgmtd_service_name,
  String $mgmtd_service_ensure       = 'running',
  Boolean $mgmtd_service_enable       = true,
  Boolean $mgmtd_service_autorestart  = false,

  # meta specific - config
  $meta_store_directory     = '',
  Hash $meta_config_overrides    = {},
  # meta specific - packages
  String $meta_package             = $beegfs::params::meta_package,
  # meta specific - service
  Boolean $meta_manage_service      = true,
  String $meta_service_name        = $beegfs::params::meta_service_name,
  String $meta_service_ensure      = 'running',
  Boolean $meta_service_enable      = true,
  Boolean $meta_service_autorestart = false,

  # storage specific - config
  $storage_store_directory      = '',
  Hash $storage_config_overrides     = {},
  # storage specific - packages
  String $storage_package              = $beegfs::params::storage_package,
  # storage specific - service
  Boolean $storage_manage_service       = true,
  String $storage_service_name         = $beegfs::params::storage_service_name,
  String $storage_service_ensure       = 'running',
  Boolean $storage_service_enable       = true,
  Boolean $storage_service_autorestart  = false,

  # admon specific - config
  Stdlib::Absolutepath $admon_database_file_dir    = '/var/lib/beegfs',
  Hash $admon_config_overrides     = {},
  # admon specific - packages
  String $admon_package              = $beegfs::params::admon_package,
  # admon specific - service
  Boolean $admon_manage_service       = true,
  String $admon_service_name         = $beegfs::params::admon_service_name,
  String $admon_service_ensure       = 'running',
  Boolean $admon_service_enable       = true,
  Boolean $admon_service_autorestart  = false,
) inherits beegfs::params {

  if ! $release in ['7.1'] {
    fail("${module_name}: Only release 7.1 is supported, ${release} given.")
  }

  if empty($conn_tcp_only_filters) {
    $_conn_tcp_only_filter_file_value   = ''
    $_conn_tcp_only_filter_file_ensure  = 'absent'
  } else {
    $_conn_tcp_only_filter_file_value   = $conn_tcp_only_filter_file
    $_conn_tcp_only_filter_file_ensure  = 'present'
  }

  if $with_rdma {
    $ib_subscribe = Package['libbeegfs-ib']
  } else {
    $ib_subscribe = undef
  }

  ## beegfs-client ##

  if $client or $utils_only {
    if $client_service_autorestart {
      $client_service_subscribe   = delete_undef_values([
        File['/etc/beegfs/beegfs-client.conf'],
        #Augeas['beegfs-client.conf'],
        File['/etc/beegfs/beegfs-mounts.conf'],
        File[$client_conn_interfaces_file],
        File[$client_conn_net_filter_file],
        File[$conn_tcp_only_filter_file],
        File_line['beegfs-client-autobuild buildArgs'],
        File_line['beegfs-client-autobuild buildEnabled'],
        $ib_subscribe,
      ])
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

    contain beegfs::client
  }

  ## beegfs-mgmtd ##

  if $mgmtd {
    if $mgmtd_service_autorestart {
      $mgmtd_service_subscribe = delete_undef_values([
        File['/etc/beegfs/beegfs-mgmtd.conf'],
        File[$mgmtd_conn_interfaces_file],
        File[$mgmtd_conn_net_filter_file],
        $ib_subscribe,
      ])
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

    contain beegfs::mgmtd
  }

  ## beegfs-meta ##

  if $meta {
    if $meta_service_autorestart {
      $meta_service_subscribe = delete_undef_values([
        File['/etc/beegfs/beegfs-meta.conf'],
        File[$meta_conn_interfaces_file],
        File[$meta_conn_net_filter_file],
        File[$conn_tcp_only_filter_file],
        $ib_subscribe,
      ])
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

    contain beegfs::meta
  }

  ## beegfs-storage ##

  if $storage {
    if $storage_service_autorestart {
      $storage_service_subscribe = delete_undef_values([
        File['/etc/beegfs/beegfs-storage.conf'],
        File[$storage_conn_interfaces_file],
        File[$storage_conn_net_filter_file],
        File[$conn_tcp_only_filter_file],
        $ib_subscribe
      ])
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

    contain beegfs::storage
  }

  ## beegfs-admon ##

  if $admon {
    if $admon_service_autorestart {
      $admon_service_subscribe = [
        File['/etc/beegfs/beegfs-admon.conf'],
        File[$admon_conn_interfaces_file],
        File[$admon_conn_net_filter_file],
        File[$conn_tcp_only_filter_file],
      ]
    } else {
      $admon_service_subscribe = undef
    }

    if empty($admon_conn_interfaces) {
      $admon_conn_interfaces_file_value   = ''
      $admon_conn_interfaces_file_ensure  = 'absent'
    } else {
      $admon_conn_interfaces_file_value   = $admon_conn_interfaces_file
      $admon_conn_interfaces_file_ensure  = 'present'
    }

    if empty($admon_conn_net_filters) {
      $admon_conn_net_filter_file_value   = ''
      $admon_conn_net_filter_file_ensure  = 'absent'
    } else {
      $admon_conn_net_filter_file_value   = $admon_conn_net_filter_file
      $admon_conn_net_filter_file_ensure  = 'present'
    }

    $admon_local_configs = {
      'connPortShift'         => $conn_port_shift,
      'connInterfacesFile'    => $admon_conn_interfaces_file_value,
      'connNetFilterFile'     => $admon_conn_net_filter_file_value,
      'connTcpOnlyFilterFile' => $_conn_tcp_only_filter_file_value,
      'sysMgmtdHost'          => $mgmtd_host,
      'databaseFile'          => "${admon_database_file_dir}/beegfs-admon.db",
    }

    $admon_default_configs  = merge($beegfs::params::admon_default_configs[$release], $admon_local_configs)
    $admon_configs          = merge($admon_default_configs, $admon_config_overrides)
    $admon_config_keys      = $beegfs::params::admon_config_keys[$release]

    contain beegfs::admon
  }

}

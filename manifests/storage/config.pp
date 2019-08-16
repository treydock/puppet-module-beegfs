# @api private
class beegfs::storage::config {

  $conn_interfaces  = $beegfs::storage_conn_interfaces
  $conn_net_filters = $beegfs::storage_conn_net_filters

  if ! defined(File['/etc/beegfs']) {
    file { '/etc/beegfs':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  if $beegfs::storage_store_directory and ! empty($beegfs::storage_store_directory) {
    file { 'beegfs-storeStorageDirectory':
      ensure => 'directory',
      path   => $beegfs::storage_store_directory,
    }
  }

  file { '/etc/beegfs/beegfs-storage.conf':
    ensure  => 'present',
    content => template("beegfs/${beegfs::release}/beegfs-storage.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $beegfs::storage_conn_interfaces_file:
    ensure  => $beegfs::storage_conn_interfaces_file_ensure,
    content => template('beegfs/interfaces.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $beegfs::storage_conn_net_filter_file:
    ensure  => $beegfs::storage_conn_net_filter_file_ensure,
    content => template('beegfs/netfilter.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if ! defined(File[$beegfs::conn_tcp_only_filter_file]) {
    file { $beegfs::conn_tcp_only_filter_file:
      ensure  => $beegfs::_conn_tcp_only_filter_file_ensure,
      content => inline_template('<%= scope.lookupvar("beegfs::conn_tcp_only_filters").join("\n") %>'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

}

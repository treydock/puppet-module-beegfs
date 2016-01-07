# private class
class beegfs::meta::config {

  $conn_interfaces  = $beegfs::meta_conn_interfaces
  $conn_net_filters = $beegfs::meta_conn_net_filters

  if ! defined(File['/etc/beegfs']) {
    file { '/etc/beegfs':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  if $beegfs::meta_store_directory and ! empty($beegfs::meta_store_directory) {
    file { 'beegfs-storeMetaDirectory':
      ensure => 'directory',
      path   => $beegfs::meta_store_directory,
    }
  }

  file { '/etc/beegfs/beegfs-meta.conf':
    ensure  => 'present',
    content => template("beegfs/${beegfs::release}/beegfs-meta.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $beegfs::meta_conn_interfaces_file:
    ensure  => $beegfs::meta_conn_interfaces_file_ensure,
    content => template('beegfs/interfaces.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $beegfs::meta_conn_net_filter_file:
    ensure  => $beegfs::meta_conn_net_filter_file_ensure,
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

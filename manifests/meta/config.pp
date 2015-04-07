# private class
class fhgfs::meta::config {

  $conn_interfaces  = $fhgfs::meta_conn_interfaces
  $conn_net_filters = $fhgfs::meta_conn_net_filters

  if $fhgfs::meta_store_directory and ! empty($fhgfs::meta_store_directory) {
    file { 'fhgfs-storeMetaDirectory':
      ensure => 'directory',
      path   => $fhgfs::meta_store_directory,
    }
  }

  file { '/etc/fhgfs/fhgfs-meta.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::release}/fhgfs-meta.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $fhgfs::meta_conn_interfaces_file:
    ensure  => $fhgfs::meta_conn_interfaces_file_ensure,
    content => template('fhgfs/interfaces.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $fhgfs::meta_conn_net_filter_file:
    ensure  => $fhgfs::meta_conn_net_filter_file_ensure,
    content => template('fhgfs/netfilter.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

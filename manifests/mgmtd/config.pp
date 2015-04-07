# private class
class fhgfs::mgmtd::config {

  $conn_interfaces  = $fhgfs::mgmtd_conn_interfaces
  $conn_net_filters = $fhgfs::mgmtd_conn_net_filters

  if $fhgfs::mgmtd_store_directory and ! empty($fhgfs::mgmtd_store_directory) {
    file { 'fhgfs-storeMgmtdDirectory':
      ensure => 'directory',
      path   => $fhgfs::mgmtd_store_directory,
    }
  }

  file { '/etc/fhgfs/fhgfs-mgmtd.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::release}/fhgfs-mgmtd.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $fhgfs::mgmtd_conn_interfaces_file:
    ensure  => $fhgfs::mgmtd_conn_interfaces_file_ensure,
    content => template('fhgfs/interfaces.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $fhgfs::mgmtd_conn_net_filter_file:
    ensure  => $fhgfs::mgmtd_conn_net_filter_file_ensure,
    content => template('fhgfs/netfilter.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

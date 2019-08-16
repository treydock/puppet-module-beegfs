# @api private
class beegfs::mgmtd::config {

  $conn_interfaces  = $beegfs::mgmtd_conn_interfaces
  $conn_net_filters = $beegfs::mgmtd_conn_net_filters

  if ! defined(File['/etc/beegfs']) {
    file { '/etc/beegfs':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  if $beegfs::mgmtd_store_directory and ! empty($beegfs::mgmtd_store_directory) {
    file { 'beegfs-storeMgmtdDirectory':
      ensure => 'directory',
      path   => $beegfs::mgmtd_store_directory,
    }
  }

  file { '/etc/beegfs/beegfs-mgmtd.conf':
    ensure  => 'present',
    content => template("beegfs/${beegfs::release}/beegfs-mgmtd.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $beegfs::mgmtd_conn_interfaces_file:
    ensure  => $beegfs::mgmtd_conn_interfaces_file_ensure,
    content => template('beegfs/interfaces.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $beegfs::mgmtd_conn_net_filter_file:
    ensure  => $beegfs::mgmtd_conn_net_filter_file_ensure,
    content => template('beegfs/netfilter.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

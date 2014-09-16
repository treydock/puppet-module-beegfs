# == Class: fhgfs::mgmtd::config
#
# Private class
#
class fhgfs::mgmtd::config {

  file { '/etc/fhgfs/fhgfs-mgmtd.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::mgmtd::release}/fhgfs-mgmtd.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $fhgfs::mgmtd::conn_interfaces_file:
    ensure  => 'file',
    content => template('fhgfs/interfaces.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

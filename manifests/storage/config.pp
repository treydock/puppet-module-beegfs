# == Class: fhgfs::storage::config
#
# Private class
#
class fhgfs::storage::config {

  file { '/etc/fhgfs/fhgfs-storage.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::storage::release}/fhgfs-storage.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $fhgfs::storage::conn_interfaces_file:
    ensure  => 'file',
    content => template('fhgfs/interfaces.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

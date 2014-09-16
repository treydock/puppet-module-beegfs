# == Class: fhgfs::meta::config
#
# Private class
#
class fhgfs::meta::config {

  file { '/etc/fhgfs/fhgfs-meta.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::meta::release}/fhgfs-meta.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $fhgfs::meta::conn_interfaces_file:
    ensure  => 'file',
    content => template('fhgfs/interfaces.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

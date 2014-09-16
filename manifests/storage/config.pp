# private class
class fhgfs::storage::config {

  $conn_interfaces = $fhgfs::storage_conn_interfaces

  file { '/etc/fhgfs/fhgfs-storage.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::release}/fhgfs-storage.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $fhgfs::storage_conn_interfaces_file:
    ensure  => $fhgfs::storage_conn_interfaces_file_ensure,
    content => template('fhgfs/interfaces.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

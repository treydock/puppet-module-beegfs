# private class
class fhgfs::admon::config {

  file { '/etc/fhgfs/fhgfs-admon.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::release}/fhgfs-admon.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $fhgfs::admon_database_file_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}

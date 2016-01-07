# private class
class beegfs::admon::config {

  if ! defined(File['/etc/beegfs']) {
    file { '/etc/beegfs':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  file { '/etc/beegfs/beegfs-admon.conf':
    ensure  => 'present',
    content => template("beegfs/${beegfs::release}/beegfs-admon.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $beegfs::admon_database_file_dir:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}

# private class
class beegfs::upgrade::fhgfs_to_beegfs::end {

  file { '/etc/yum.repos.d/fhgfs.repo': ensure => 'absent' }

}

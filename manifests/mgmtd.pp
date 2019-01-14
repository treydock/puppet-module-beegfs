# private class
class beegfs::mgmtd {

  contain beegfs::repo
  contain beegfs::mgmtd::install
  contain beegfs::mgmtd::config
  contain beegfs::mgmtd::service

  Class['beegfs::repo']
  -> Class['beegfs::mgmtd::install']
  -> Class['beegfs::mgmtd::config']
  -> Class['beegfs::mgmtd::service']

}

# private class
class beegfs::admon {

  contain beegfs::repo
  contain beegfs::admon::install
  contain beegfs::admon::config
  contain beegfs::admon::service

  Class['beegfs::repo']
  -> Class['beegfs::admon::install']
  -> Class['beegfs::admon::config']
  -> Class['beegfs::admon::service']

}

# @api private
class beegfs::meta {

  contain beegfs::repo
  contain beegfs::install
  contain beegfs::meta::install
  contain beegfs::meta::config
  contain beegfs::meta::service

  Class['beegfs::repo']
  -> Class['beegfs::install']
  -> Class['beegfs::meta::install']
  -> Class['beegfs::meta::config']
  -> Class['beegfs::meta::service']

}

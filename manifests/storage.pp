# @api private
class beegfs::storage {

  contain beegfs::repo
  contain beegfs::install
  contain beegfs::storage::install
  contain beegfs::storage::config
  contain beegfs::storage::service

  Class['beegfs::repo']
  -> Class['beegfs::install']
  -> Class['beegfs::storage::install']
  -> Class['beegfs::storage::config']
  -> Class['beegfs::storage::service']

}

# @api private
class beegfs::client {

  contain beegfs::repo
  contain beegfs::install
  contain beegfs::client::install
  contain beegfs::client::config
  contain beegfs::client::service

  Class['beegfs::repo']
  -> Class['beegfs::install']
  -> Class['beegfs::client::install']
  -> Class['beegfs::client::config']
  -> Class['beegfs::client::service']

}

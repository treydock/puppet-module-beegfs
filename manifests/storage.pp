# private class
class beegfs::storage {

  include beegfs::repo
  include beegfs::storage::install
  include beegfs::storage::config
  include beegfs::storage::service
  
  anchor { 'beegfs::storage::start': }->
  Class['beegfs::repo']->
  Class['beegfs::storage::install']->
  Class['beegfs::storage::config']->
  Class['beegfs::storage::service']->
  anchor { 'beegfs::storage::end': }

}

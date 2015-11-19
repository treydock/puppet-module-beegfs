# private class
class beegfs::client {

  include beegfs::repo
  include beegfs::client::install
  include beegfs::client::config
  include beegfs::client::service
  
  anchor { 'beegfs::client::start': }->
  Class['beegfs::repo']->
  Class['beegfs::client::install']->
  Class['beegfs::client::config']->
  Class['beegfs::client::service']->
  anchor { 'beegfs::client::end': }

}

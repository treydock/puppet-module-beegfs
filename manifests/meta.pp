# private class
class beegfs::meta {

  include beegfs::repo
  include beegfs::meta::install
  include beegfs::meta::config
  include beegfs::meta::service
  
  anchor { 'beegfs::meta::start': }->
  Class['beegfs::repo']->
  Class['beegfs::meta::install']->
  Class['beegfs::meta::config']->
  Class['beegfs::meta::service']->
  anchor { 'beegfs::meta::end': }

}

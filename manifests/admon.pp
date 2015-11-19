# private class
class beegfs::admon {

  include beegfs::repo
  include beegfs::admon::install
  include beegfs::admon::config
  include beegfs::admon::service
  
  anchor { 'beegfs::admon::start': }->
  Class['beegfs::repo']->
  Class['beegfs::admon::install']->
  Class['beegfs::admon::config']->
  Class['beegfs::admon::service']->
  anchor { 'beegfs::admon::end': }

}

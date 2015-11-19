# private class
class beegfs::mgmtd {

  include beegfs::repo
  include beegfs::mgmtd::install
  include beegfs::mgmtd::config
  include beegfs::mgmtd::service
  
  anchor { 'beegfs::mgmtd::start': }->
  Class['beegfs::repo']->
  Class['beegfs::mgmtd::install']->
  Class['beegfs::mgmtd::config']->
  Class['beegfs::mgmtd::service']->
  anchor { 'beegfs::mgmtd::end': }

}

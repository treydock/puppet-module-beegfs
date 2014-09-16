# private class
class fhgfs::mgmtd {

  include fhgfs::repo
  include fhgfs::mgmtd::install
  include fhgfs::mgmtd::config
  include fhgfs::mgmtd::service
  
  anchor { 'fhgfs::mgmtd::start': }->
  Class['fhgfs::repo']->
  Class['fhgfs::mgmtd::install']->
  Class['fhgfs::mgmtd::config']->
  Class['fhgfs::mgmtd::service']->
  anchor { 'fhgfs::mgmtd::end': }

}

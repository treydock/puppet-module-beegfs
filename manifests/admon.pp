# private class
class fhgfs::admon {

  include fhgfs::repo
  include fhgfs::admon::install
  include fhgfs::admon::config
  include fhgfs::admon::service
  
  anchor { 'fhgfs::admon::start': }->
  Class['fhgfs::repo']->
  Class['fhgfs::admon::install']->
  Class['fhgfs::admon::config']->
  Class['fhgfs::admon::service']->
  anchor { 'fhgfs::admon::end': }

}

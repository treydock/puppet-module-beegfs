# private class
class fhgfs::meta {

  include fhgfs::repo
  include fhgfs::meta::install
  include fhgfs::meta::config
  include fhgfs::meta::service
  
  anchor { 'fhgfs::meta::start': }->
  Class['fhgfs::repo']->
  Class['fhgfs::meta::install']->
  Class['fhgfs::meta::config']->
  Class['fhgfs::meta::service']->
  anchor { 'fhgfs::meta::end': }

}

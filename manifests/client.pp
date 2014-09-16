# private class
class fhgfs::client {

  include fhgfs::repo
  include fhgfs::client::install
  include fhgfs::client::config
  include fhgfs::client::service
  
  anchor { 'fhgfs::client::start': }->
  Class['fhgfs::repo']->
  Class['fhgfs::client::install']->
  Class['fhgfs::client::config']->
  Class['fhgfs::client::service']->
  anchor { 'fhgfs::client::end': }

}

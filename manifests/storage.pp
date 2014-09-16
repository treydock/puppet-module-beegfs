# private class
class fhgfs::storage {

  include fhgfs::repo
  include fhgfs::storage::install
  include fhgfs::storage::config
  include fhgfs::storage::service
  
  anchor { 'fhgfs::storage::start': }->
  Class['fhgfs::repo']->
  Class['fhgfs::storage::install']->
  Class['fhgfs::storage::config']->
  Class['fhgfs::storage::service']->
  anchor { 'fhgfs::storage::end': }

}

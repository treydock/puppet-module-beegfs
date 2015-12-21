# private class
class beegfs::upgrade::fhgfs_to_beegfs (
  $migrate_script_path = undef,
) {

  include beegfs::upgrade::fhgfs_to_beegfs::start

  if $beegfs::client or $beegfs::utils_only {
    Class['beegfs::upgrade::fhgfs_to_beegfs::start'] -> Class['beegfs::client::install']
  }
  if $beegfs::mgmtd {
    Class['beegfs::upgrade::fhgfs_to_beegfs::start'] -> Class['beegfs::mgmtd::install']
  }
  if $beegfs::admon {
    Class['beegfs::upgrade::fhgfs_to_beegfs::start'] -> Class['beegfs::admon::install']
  }
  if $beegfs::meta {
    Class['beegfs::upgrade::fhgfs_to_beegfs::start'] -> Class['beegfs::meta::install']
  }
  if $beegfs::storage {
    Class['beegfs::upgrade::fhgfs_to_beegfs::start'] -> Class['beegfs::storage::install']
  }

  stage { 'beegfs::upgrade::end': }
  Stage['main'] -> Stage['beegfs::upgrade::end']
  class { 'beegfs::upgrade::fhgfs_to_beegfs::end': stage => 'beegfs::upgrade::end' }

}

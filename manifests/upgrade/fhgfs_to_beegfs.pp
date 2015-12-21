class beegfs::upgrade::fhgfs_to_beegfs (
  $migrate_script_path = undef,
) {

  stage { 'beegfs::upgrade::start': before => Stage['main'] }
  stage { 'beegfs::upgrade::end': }
  Stage['main'] -> Stage['beegfs::upgrade::end']
  class { 'beegfs::upgrade::fhgfs_to_beegfs::start': stage => 'beegfs::upgrade::start' }
  class { 'beegfs::upgrade::fhgfs_to_beegfs::end': stage => 'beegfs::upgrade::end' }

}

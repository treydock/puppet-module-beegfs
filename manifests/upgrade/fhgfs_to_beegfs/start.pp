# private class
class beegfs::upgrade::fhgfs_to_beegfs::start {

  if $beegfs::upgrade::fhgfs_to_beegfs::migrate_script_path {
    $_migrate_script_path = $beegfs::upgrade::fhgfs_to_beegfs::migrate_script_path
  } else {
    $_migrate_script_path = '/root/beegfs-migrate-fhgfs-config.py'
    exec { 'wget beegfs-migrate-fhgfs-config.py':
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      command => 'wget -O /root/beegfs-migrate-fhgfs-config.py http://www.beegfs.com/release/beegfs_2015.03/upgrade/beegfs-migrate-fhgfs-config.py',
      creates => '/root/beegfs-migrate-fhgfs-config.py',
      onlyif  => 'test -d /etc/fhgfs',
      before  => Exec['run beegfs-migrate-fhgfs-config.py']
    }
  }

  $_rm_files = [
    '/etc/default/fhgfs-helperd',
    '/etc/default/fhgfs-client',
    '/etc/default/fhgfs-admon',
    '/etc/default/fhgfs-storage',
    '/etc/default/fhgfs-meta',
    '/etc/default/fhgfs-mgmtd',
    '/root/beegfs-migrate-fhgfs-config.py',
  ]

  exec { 'run beegfs-migrate-fhgfs-config.py':
    path      => '/usr/bin:/bin:/usr/sbin:/sbin',
    command   => "python ${_migrate_script_path}",
    onlyif    => 'test -d /etc/fhgfs',
    logoutput => true,
  }->
  service { 'fhgfs-admon': ensure => 'stopped', enable => false }->
  service { 'fhgfs-client': ensure => 'stopped', enable => false }->
  service { 'fhgfs-helperd': ensure => 'stopped', enable => false }->
  service { 'fhgfs-storage': ensure => 'stopped', enable => false }->
  service { 'fhgfs-meta': ensure => 'stopped', enable => false }->
  service { 'fhgfs-mgmtd': ensure => 'stopped', enable => false }->
  package { 'fhgfs-admon': ensure => 'absent' }->
  package { 'fhgfs-client': ensure => 'absent' }->
  package { 'fhgfs-client-compat': ensure => 'absent' }->
  package { 'fhgfs-client-opentk-src': ensure => 'absent' }->
  package { 'fhgfs-helperd': ensure => 'absent' }->
  package { 'fhgfs-meta': ensure => 'absent' }->
  package { 'fhgfs-mgmtd': ensure => 'absent' }->
  package { 'fhgfs-storage': ensure => 'absent' }->
  package { 'fhgfs-utils': ensure => 'absent' }->
  package { 'fhgfs-opentk-lib': ensure => 'absent' }->
  package { 'fhgfs-common': ensure => 'absent' }->
  file { [ '/etc/fhgfs', '/opt/fhgfs' ]:
    ensure => 'absent',
    force  => true,
  }->
  file { $_rm_files: ensure => 'absent' }

}

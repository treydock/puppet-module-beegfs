# == Class: fhgfs
#
# Public class
#
class fhgfs (
  $mgmtd_host           = $fhgfs::params::mgmtd_host,
  $package_ensure       = 'present',
  $repo_version         = $fhgfs::params::repo_version,
  $repo_descr           = $fhgfs::params::repo_descr,
  $repo_baseurl         = $fhgfs::params::repo_baseurl,
  $repo_gpgkey          = $fhgfs::params::repo_gpgkey,
  $repo_gpgcheck        = '0',
  $repo_enabled         = '1',
  $package_dependencies = $fhgfs::params::package_dependencies,
) inherits fhgfs::params {

  validate_re($repo_gpgcheck, '^(1|0)$')
  validate_re($repo_enabled, '^(1|0)$')

  include fhgfs::repo

}

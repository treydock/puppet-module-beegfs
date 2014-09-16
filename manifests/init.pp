# == Class: fhgfs
#
# Public class
#
class fhgfs (
  $mgmtd_host           = $fhgfs::params::mgmtd_host,
  $package_version      = $fhgfs::params::package_version,
  $release              = $fhgfs::params::release,
  $repo_descr           = 'UNSET',
  $repo_baseurl         = 'UNSET',
  $repo_gpgkey          = 'UNSET',
  $repo_gpgcheck        = '0',
  $repo_enabled         = '1',
  $package_dependencies = $fhgfs::params::package_dependencies,
) inherits fhgfs::params {

  if ! member(['2012.10','2014.01'], $release) {
    fail("${module_name}: Only releases 2012.10 and 2014.01 are supported, ${release} given.")
  }

  validate_re($repo_gpgcheck, '^(1|0)$')
  validate_re($repo_enabled, '^(1|0)$')

  include fhgfs::repo

}

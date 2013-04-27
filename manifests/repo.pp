# == Class: fhgfs
#
# Full description of class fhgfs here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { fhgfs:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::repo (
  $version,
  $repo_baseurl,
  $repo_gpgkey,
  $repo_descr

) {

  include fhgfs::params

  $baseurl = $repo_baseurl ? {
    'UNSET'   => inline_template("<%= \"${fhgfs::params::repo_baseurl}\".gsub(/VERSION/, \"${version}\") %>"),
    default   => $repo_baseurl,
  }
  $gpgkey = $repo_gpgkey ? {
    'UNSET'   => inline_template("<%= \"${fhgfs::params::repo_gpgkey}\".gsub(/VERSION/, \"${version}\") %>"),
    default   => $repo_gpgkey,
  }
  $descr = $repo_descr ? {
    'UNSET'   => inline_template("<%= \"${fhgfs::params::repo_descr}\".gsub(/VERSION/, \"${version}\") %>"),
    default   => $repo_descr,
  }

  case $::osfamily {
    'RedHat': {
      yumrepo { 'fhgfs':
        descr     => $descr,
        baseurl   => $baseurl,
        gpgkey    => $gpgkey,
        gpgcheck  => '0',
        enabled   => '1',
      }
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }



}

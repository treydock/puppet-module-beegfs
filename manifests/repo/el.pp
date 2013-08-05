# == Class: fhgfs::repo::el
#
# Manages the FhGFS repo for
# Enterprise Linux based distributions.
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::repo::el {

  include fhgfs

  $descr    = $fhgfs::repo_descr_real
  $baseurl  = $fhgfs::repo_baseurl_real
  $gpgkey   = $fhgfs::repo_gpgkey
  $gpgcheck = $fhgfs::repo_gpgcheck
  $enabled  = $fhgfs::repo_enabled

  file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-fhgfs':
    ensure  => present,
    source  => 'puppet:///modules/fhgfs/RPM-GPG-KEY-fhgfs',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  gpg_key { 'fhgfs':
    path    => '/etc/pki/rpm-gpg/RPM-GPG-KEY-fhgfs',
    before  => Yumrepo['fhgfs'],
  }

  yumrepo { 'fhgfs':
    descr     => $descr,
    baseurl   => $baseurl,
    gpgkey    => $gpgkey,
    gpgcheck  => $gpgcheck,
    enabled   => $enabled,
  }
}

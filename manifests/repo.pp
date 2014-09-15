# == Class: fhgfs::repo
#
# Private class
#
class fhgfs::repo {

  include fhgfs

  ensure_packages($fhgfs::package_dependencies)

  case $::osfamily {
    'RedHat': {
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
        descr     => $fhgfs::repo_descr,
        baseurl   => $fhgfs::repo_baseurl,
        gpgkey    => $fhgfs::repo_gpgkey,
        gpgcheck  => $fhgfs::repo_gpgcheck,
        enabled   => $fhgfs::repo_enabled,
      }
    }

    default: {
      # Do nothing
    }
  }
}

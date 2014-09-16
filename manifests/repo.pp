# == Class: fhgfs::repo
#
# Private class
#
class fhgfs::repo {

  include fhgfs
  include fhgfs::params

  $release  = $fhgfs::release
  $repo     = $fhgfs::params::repo[$release]

  ensure_packages($fhgfs::package_dependencies)

  $repo_descr = $fhgfs::repo_descr ? {
    'UNSET' => $repo['descr'],
    default => $fhgfs::repo_descr,
  }
  
  $repo_baseurl = $fhgfs::repo_baseurl ? {
    'UNSET' => $repo['baseurl'],
    default => $fhgfs::repo_baseurl,
  }

  $repo_gpgkey = $fhgfs::repo_gpgkey ? {
    'UNSET' => $repo['gpgkey'],
    default => $fhgfs::repo_gpgkey,
  }

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
        descr     => $repo_descr,
        baseurl   => $repo_baseurl,
        gpgkey    => $repo_gpgkey,
        gpgcheck  => $fhgfs::repo_gpgcheck,
        enabled   => $fhgfs::repo_enabled,
      }
    }

    default: {
      # Do nothing
    }
  }
}

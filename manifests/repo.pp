# private class
class beegfs::repo {

  $_repo_defaults       = $beegfs::repo_defaults[$beegfs::release]
  $_repo_descr          = pick($beegfs::repo_descr, $_repo_defaults['descr'])
  $_repo_baseurl        = pick($beegfs::repo_baseurl, $_repo_defaults['baseurl'])
  $_repo_gpgkey         = pick($beegfs::repo_gpgkey, $_repo_defaults['gpgkey'])

  case $::osfamily {
    'RedHat': {
      yumrepo { 'beegfs':
        descr    => $_repo_descr,
        baseurl  => $_repo_baseurl,
        gpgkey   => $_repo_gpgkey,
        gpgcheck => $beegfs::repo_gpgcheck,
        enabled  => $beegfs::repo_enabled,
      }
    }

    default: {
      # Do nothing
    }
  }
}

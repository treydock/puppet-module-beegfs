# private class
class fhgfs::repo {

  $_repo_defaults       = $fhgfs::repo_defaults[$fhgfs::release]
  $_repo_descr          = pick($fhgfs::repo_descr, $_repo_defaults['descr'])
  $_repo_baseurl        = pick($fhgfs::repo_baseurl, $_repo_defaults['baseurl'])
  $_repo_gpgkey         = pick($fhgfs::repo_gpgkey, $_repo_defaults['gpgkey'])

  case $::osfamily {
    'RedHat': {
      yumrepo { 'fhgfs':
        descr    => $_repo_descr,
        baseurl  => $_repo_baseurl,
        gpgkey   => $_repo_gpgkey,
        gpgcheck => $fhgfs::repo_gpgcheck,
        enabled  => $fhgfs::repo_enabled,
      }
    }

    default: {
      # Do nothing
    }
  }
}

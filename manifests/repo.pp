# @api private
class beegfs::repo {

  $_repo_defaults       = $beegfs::repo_defaults[$beegfs::release]
  $_repo_descr          = pick($beegfs::repo_descr, $_repo_defaults['descr'])
  $_repo_gpgkey         = pick($beegfs::repo_gpgkey, $_repo_defaults['gpgkey'])

  if $beegfs::customer_login {
    $_baseurl_default = regsubst($_repo_defaults['customer_baseurl'], 'LOGIN', $beegfs::customer_login)
    $_repo_baseurl = pick($beegfs::repo_baseurl, $_baseurl_default)
  } else {
    $_repo_baseurl = pick($beegfs::repo_baseurl, $_repo_defaults['baseurl'])
  }

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

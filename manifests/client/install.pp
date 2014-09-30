# private class
class fhgfs::client::install {

  if ! $fhgfs::utils_only {
    package { 'fhgfs-helperd':
      ensure  => $fhgfs::version,
      name    => $fhgfs::helperd_package,
    }

    package { 'fhgfs-client':
      ensure  => $fhgfs::version,
      name    => $fhgfs::client_package,
    }
  }

  package { 'fhgfs-utils':
    ensure  => $fhgfs::version,
    name    => $fhgfs::client_utils_package,
  }

}

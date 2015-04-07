# private class
class fhgfs::client::config {

  $conn_interfaces  = $fhgfs::client_conn_interfaces
  $conn_net_filters = $fhgfs::client_conn_net_filters

  file { '/etc/fhgfs/fhgfs-client.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::release}/fhgfs-client.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if ! $fhgfs::utils_only {
    file { '/etc/fhgfs/fhgfs-helperd.conf':
      ensure  => 'present',
      content => template("fhgfs/${fhgfs::release}/fhgfs-helperd.conf.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { '/etc/fhgfs/fhgfs-mounts.conf':
      ensure  => 'present',
      content => template("fhgfs/${fhgfs::release}/fhgfs-mounts.conf.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { '/etc/fhgfs/fhgfs-client-autobuild.conf':
      ensure  => 'present',
      content => template("fhgfs/${fhgfs::release}/fhgfs-client-autobuild.conf.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { $fhgfs::client_conn_interfaces_file:
      ensure  => $fhgfs::client_conn_interfaces_file_ensure,
      content => template('fhgfs/interfaces.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { $fhgfs::client_conn_net_filter_file:
      ensure  => $fhgfs::client_conn_net_filter_file_ensure,
      content => template('fhgfs/netfilter.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

}

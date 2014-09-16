# private class
class fhgfs::client::config {

  if $fhgfs::utils_only {
    $autobuild_notify = undef
  } else {
    $autobuild_notify = $fhgfs::client_autobuild_notify
  }

  $conn_interfaces = $fhgfs::client_conn_interfaces

  file { '/etc/fhgfs/fhgfs-client.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::release}/fhgfs-client.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

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
    notify  => $autobuild_notify,
  }

  exec { 'fhgfs-client rebuild':
    command     => $fhgfs::client_rebuild_command,
    refreshonly => true,
  }

  file { $fhgfs::client_conn_interfaces_file:
    ensure  => $fhgfs::client_conn_interfaces_file_ensure,
    content => template('fhgfs/interfaces.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

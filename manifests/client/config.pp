# == Class: fhgfs::client::config
#
# Private class
#
class fhgfs::client::config {

  if $fhgfs::client::utils_only {
    $autobuild_notify = undef
  } else {
    $autobuild_notify = $fhgfs::client::autobuild_notify
  }

  file { '/etc/fhgfs/fhgfs-client.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::client::release}/fhgfs-client.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/fhgfs/fhgfs-helperd.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::client::release}/fhgfs-helperd.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/fhgfs/fhgfs-mounts.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::client::release}/fhgfs-mounts.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/fhgfs/fhgfs-client-autobuild.conf':
    ensure  => 'present',
    content => template("fhgfs/${fhgfs::client::release}/fhgfs-client-autobuild.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => $autobuild_notify,
  }

  exec { 'fhgfs-client rebuild':
    command     => $fhgfs::client::rebuild_command,
    refreshonly => true,
  }

  file { $fhgfs::client::conn_interfaces_file:
    ensure  => 'file',
    content => template('fhgfs/interfaces.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

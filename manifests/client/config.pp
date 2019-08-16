# @api private
class beegfs::client::config {

  $conn_interfaces  = $beegfs::client_conn_interfaces
  $conn_net_filters = $beegfs::client_conn_net_filters

  if ! defined(File['/etc/beegfs']) {
    file { '/etc/beegfs':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  file { '/etc/beegfs/beegfs-client.conf':
    ensure  => 'present',
    content => template("beegfs/${beegfs::release}/beegfs-client.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  #augeas { 'beegfs-client.conf':
  #  context => '/files/etc/beegfs/beegfs-client.conf',
  #  changes => template('beegfs/client-augeas.erb'),
  #  lens    => 'BeeGFS_config.lns',
  #  incl    => '/etc/beegfs/beegfs-client.conf',
  #}

  file { $beegfs::client_conn_interfaces_file:
    ensure  => $beegfs::client_conn_interfaces_file_ensure,
    content => template('beegfs/interfaces.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $beegfs::client_conn_net_filter_file:
    ensure  => $beegfs::client_conn_net_filter_file_ensure,
    content => template('beegfs/netfilter.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if ! defined(File[$beegfs::conn_tcp_only_filter_file]) {
    file { $beegfs::conn_tcp_only_filter_file:
      ensure  => $beegfs::_conn_tcp_only_filter_file_ensure,
      content => inline_template('<%= scope.lookupvar("beegfs::conn_tcp_only_filters").join("\n") %>'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  if ! $beegfs::utils_only {
    file { '/etc/beegfs/beegfs-helperd.conf':
      ensure  => 'present',
      content => template("beegfs/${beegfs::release}/beegfs-helperd.conf.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    if $beegfs::manage_client_mount_path {
      exec { "mkdir -p ${beegfs::client_mount_path}":
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        creates => $beegfs::client_mount_path,
      }
    }

    file { '/etc/beegfs/beegfs-mounts.conf':
      ensure  => 'present',
      content => template("beegfs/${beegfs::release}/beegfs-mounts.conf.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { '/etc/beegfs/beegfs-client-autobuild.conf':
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    file_line { 'beegfs-client-autobuild buildArgs':
      ensure  => 'present',
      path    => '/etc/beegfs/beegfs-client-autobuild.conf',
      line    => "buildArgs=${beegfs::client_build_args}",
      match   => '^buildArgs=.*$',
      require => File['/etc/beegfs/beegfs-client-autobuild.conf'],
    }

    file_line { 'beegfs-client-autobuild buildEnabled':
      ensure  => 'present',
      path    => '/etc/beegfs/beegfs-client-autobuild.conf',
      line    => "buildEnabled=${beegfs::client_build_enabled}",
      match   => '^buildEnabled=.*$',
      require => File['/etc/beegfs/beegfs-client-autobuild.conf'],
    }
  }

}

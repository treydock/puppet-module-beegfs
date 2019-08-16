# @api private
class beegfs::install {

  if $beegfs::with_rdma {
    package { 'libbeegfs-ib':
      ensure => $beegfs::version,
      name   => $beegfs::ib_package,
    }
  }

}

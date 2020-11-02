# puppet-module-beegfs

[![Build Status](https://travis-ci.org/treydock/puppet-module-beegfs.svg?branch=master)](https://travis-ci.org/treydock/puppet-module-beegfs)

#### Table of Contents

1. [Overview](#overview)
    * [BeeGFS Compatibility](#beegfs-compatibility)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [TODO](#todo)
7. [Additional Information](#additional-information)

## Overview

This module manages [BeeGFS](https://www.beegfs.io) servers and clients.

### BeeGFS Compatibility

This module is only supported on the following releases of BeeGFS:

* 7.1.x

## Usage

### beegfs

The following examples are done using Hiera.  The basic usage for a profile class would be the following:

```puppet
include beegfs
```

The majority of configurations to BeeGFS module can be done in a file like `common.yaml` with only the role Boolean values being changed for specific hosts.

The following example defines to isntall BeeGFS release 7.1 as well necessary flags to use Mellanox OFED.

```yaml
beegfs::release: '7.1'
beegfs::version: present
beegfs::mgmtd_host: beegfs-mds1.infra.osc.edu
beegfs::client_build_args: '-j8 BEEGFS_OPENTK_IBVERBS=1 OFED_INCLUDE_PATH=/usr/src/ofa_kernel/default/include/'
beegfs::mgmtd_store_directory: /data/beegfs/mgmtd
beegfs::meta_store_directory: /data/beegfs/meta
beegfs::storage_store_directory: /data/beegfs/storage
beegfs::client_mount_path: /mnt/beegfs
```

The following example is a host running Mgmtd, Metadata and Admon daemons:

```yaml
beegfs::admon: true
beegfs::mgmtd: true
beegfs::meta: true
```

The following example is a host running Storage daemon:

```yaml
beegfs::storage: true
```

Each BeeGFS role supports defining additional configurations for their respective config files:

```yaml
beegfs::mgmtd_config_overrides:
  storeAllowFirstRunInit: 'false'
beegfs::meta_config_overrides:
  storeAllowFirstRunInit: 'false'
beegfs::storage_config_overrides:
  storeAllowFirstRunInit: 'false'
```

## Reference

[http://treydock.github.io/puppet-module-beegfs/](http://treydock.github.io/puppet-module-beegfs/)

### Facts

#### beegfs_version

This Facter fact can be used to determine the installed version of the BeeGFS components.

This fact gets the version by querying the **beegfs-common** package which is installed by all
the BeeGFS roles.

## Limitations

This module has been tested on:

* RedHat/CentOS 7 x86_64

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake spec

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker

## TODO

* Refacter the roles to use a shared defined resource to reduce on the amount of duplicate module code
* Add support for BeeGFS Multi-mode

## Additional Information

* http://www.beegfs.com/wiki

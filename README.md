# puppet-module-fhgfs

[![Build Status](https://travis-ci.org/treydock/puppet-module-fhgfs.svg?branch=master)](https://travis-ci.org/treydock/puppet-module-fhgfs)

####Table of Contents

1. [Overview](#overview)
    * [FhGFS Compatibility](#fhgfs-compatibility)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [TODO](#todo)
7. [Additional Information](#additional-information)

## Overview

TODO

### FhGFS Compatibility

This module is only supported on the following releases of FhGFS:

* 2012.10
* 2014.01

## Usage

### fhgfs

TODO

## Reference

### Classes

#### Public classes

* `fhgfs`: Installs and configures fhgfs

#### Private classes

* `fhgfs::repo`: Manages the FhGFS package repository resources
* `fhgfs::client`: Manage FhGFS client
* `fhgfs::client::install`: Install fhgfs-client packages
* `fhgfs::client::config`: Configure fhgfs-client
* `fhgfs::client::service`: Manage fhgfs-client services
* `fhgfs::mgmtd`: Manage FhGFS management server
* `fhgfs::mgmtd::install`: Install fhgfs-mgmtd package
* `fhgfs::mgmtd::config`: Configure fhgfs-mgmtd
* `fhgfs::mgmtd::service`: Manage fhgfs-mgmtd services
* `fhgfs::meta`: Manage FhGFS metadata server
* `fhgfs::meta::install`: Install fhgfs-meta
* `fhgfs::meta::config`: Configure fhgfs-meta
* `fhgfs::meta::service`: Manage fhgfs-meta service
* `fhgfs::storage`: Manage FhGFS storage server
* `fhgfs::storage::install`: Install fhgfs-storage
* `fhgfs::storage::config`: Configure fhgfs-storage
* `fhgfs::storage::service`: Manage fhgfs-storage service
* `fhgfs::admon`: Manage FhGFS Admon server
* `fhgfs::admon::install`: Install fhgfs-admon
* `fhgfs::admon::config`: Configure fhgfs-admon
* `fhgfs::admon::service`: Manage fhgfs-admon service
* `fhgfs::defaults`: Set default configuration values for the various FhGFS roles for version release 2012.10 and 2014.01
* `fhgfs::params`: Set default parameter values based on Fact values


### Parameters

#### fhgfs

TODO

### Facts

#### fhgfs_version

This Facter fact can be used to determine the installed version of the FhGFS components.

This fact gets the version by querying the **fhgfs-common** package which is installed by all
the FhGFS roles.

## Limitations

This module has been tested on:

* CentOS 6 x86_64
* Scientific Linux 6 x86_64

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker

## TODO

* Refacter the roles to use a shared defined resource to reduce on the amount of duplicate module code
* Add support for FhGFS Multi-mode

## Additional Information

* http://www.fhgfs.com/wiki/FhGFS

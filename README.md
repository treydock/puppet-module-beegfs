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

TODO

## Reference

[http://treydock.github.io/puppet-module-beegfs/](http://treydock.github.io/puppet-module-beegfs/)

### Facts

#### beegfs_version

This Facter fact can be used to determine the installed version of the BeeGFS components.

This fact gets the version by querying the **beegfs-common** package which is installed by all
the BeeGFS roles.

## Limitations

This module has been tested on:

* CentOS 6 x86_64
* CentOS 7 x86_64

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
* Add support for BeeGFS Multi-mode

## Additional Information

* http://www.beegfs.com/wiki

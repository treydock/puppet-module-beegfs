# == Class: fhgfs::repo
#
# Includes OS specific repo class.
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class fhgfs::repo {

  case $::osfamily {
    'RedHat': {
      include fhgfs::repo::el
    }
    default: {}
  }

}

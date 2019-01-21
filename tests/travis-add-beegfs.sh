#!/bin/bash

sudo apt-get update
sudo apt-get -y install git
cd /tmp
git clone https://git.beegfs.io/pub/v7
cd v7
git reset --hard 7.1.2
sudo apt-get -y install build-essential autoconf automake pkg-config devscripts debhelper \
  libtool libattr1-dev xfslibs-dev lsb-release kmod librdmacm-dev libibverbs-dev \
  default-jdk ant dh-systemd zlib1g-dev libssl-dev sqlite3 libsqlite3-dev \
  libcurl4-openssl-dev
sudo apt-get -y install linux-headers-$(uname -r)
export KVER=$(uname -r)
#export PREFIX=''
make client -j2
sudo make client-install -j2
ls -laR /opt/beegfs
insmod /opt/beegfs/lib/modules/${KVER}/kernel/beegfs/beegfs.ko
modprobe beegfs
#make package-deb PACKAGE_DIR=packages DEBUILD_OPTS="-j2"


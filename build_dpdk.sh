#!/bin/bash

################################################################################
#
#  build_dpdk.sh
#
#             - Build DPDK and pktgen-dpdk for 
#
#  Usage:     Adjust variables below before running, if necessary.
#
#  MAINTAINER:  jeder@redhat.com
#
#
################################################################################

################################################################################
#  Define Global Variables and Functions
################################################################################

VERSION=17.08.1
URL=http://www.dpdk.org/browse/dpdk/snapshot/$VERSION.tar.gz
BASEDIR=/root
PACKAGE=dpdk
DPDKROOT=$BASEDIR/$PACKAGE-$VERSION
CONFIG=x86_64-native-linuxapp-gcc


# Download/Build DPDK
cd $BASEDIR
curl $URL | tar xz
cd $DPDKROOT
make config T=$CONFIG
sed -ri 's,(PMD_PCAP=).*,\1y,' build/.config
make config T=$CONFIG install

# Download/Build pktgen-dpdk
VERSION=3.4.9
URL=http://www.dpdk.org/browse/apps/pktgen-dpdk/snapshot/pktgen-dpdk-pktgen-$VERSION.tar.xz
BASEDIR=/root
PACKAGE=pktgen
PKTGENROOT=$BASEDIR/$PACKAGE-$VERSION
cd $BASEDIR
curl $URL | tar xz

# Silence compiler info message
sed -i '/Wwrite-strings$/ s/$/ -Wno-unused-but-set-variable/' $DPDKROOT/mk/toolchain/gcc/rte.vars.mk
cd $PKTGENROOT
make
ln -s $PKTGENROOT/app/app/$CONFIG/pktgen /usr/bin

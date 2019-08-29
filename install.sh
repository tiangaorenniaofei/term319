#!/bin/bash
buildTool='gcc g++ perl wget make groff'
apt-get update
apt-get install -y $buildTool
tar -zxvf /usr/local/src/db-4.7.25.tar.gz -C /usr/local/src
cd /usr/local/src/db-4.7.25/build_unix/
../dist/configure --prefix=/usr/local/BerkeleyDB
make
make install
export CPPFLAGS="-I/usr/local/BerkeleyDB/include -D_GNU_SOURCE"
export LDFLAGS="-L/usr/local/BerkeleyDB/lib" 
export LD_LIBRARY_PATH="/usr/local/src/db-4.7.25/build_unix/.libs"
tar -zxvf /usr/local/src/openldap-stable-20090411.tgz -C /usr/local/src
cd /usr/local/src/openldap-2.4.16
./configure --enable-ldbm -disable-bdb -without-cyrus-sasl
make depend
make
make install
tar -zxvf /usr/local/src/squid-4.8.tar.gz -C /usr/local/src
cd /usr/local/src/squid-4.8
./configure --prefix=/usr/local/squid --enable-basic-auth-helpers=LDAP --enable-external-acl-helpers=LDAP_group --enable-async-io=160 --with-large-files=yes --enable-kill-parent-hack --enable-ltdl-convenience --disable-ipv6
make
make install
exit 0

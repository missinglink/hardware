#!/bin/bash

# [install] prerequisites
sudo apt-get -y install build-essential iw libssl-dev libnl-3-dev libnl-genl-3-dev libpcre3-dev sqlite3 libsqlite3-dev subversion;

# [download] stable
# wget http://download.aircrack-ng.org/aircrack-ng-1.2-rc2.tar.gz;
# tar -zxvf aircrack-ng-1.2-rc2.tar.gz;
# cd aircrack-ng-1.2-rc2;

# [download] latest subversion
cd /tmp;
svn co http://svn.aircrack-ng.org/trunk/ aircrack-ng;
cd aircrack-ng;

# [compile] standard build
# make clean;
# make;
# sudo make install;

# [compile] build with extras
# ref: http://www.aircrack-ng.org/doku.php?id=install_aircrack
make clean;
make sqlite=true pcre=true experimental=true ext_scripts=true;
sudo make sqlite=true pcre=true experimental=true ext_scripts=true install;

# [config] update OUI
sudo airodump-ng-oui-update;
#!/bin/bash

command -v java >/dev/null 2>&1 || {
echo "Installing Java"
add-apt-repository ppa:webupd8team/java <<EOF > /dev/null 2>&1
yes

EOF

apt-get -y update > /dev/null

echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
apt-get -y install oracle-java7-installer > /dev/null 2>&1
chown -R vagrant /usr/local
}
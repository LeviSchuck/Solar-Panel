#!/bin/bash
echo "Detecting OrientDB"
if [ ! -d /opt/orientdb ]; then
	echo "Downloading OrientDB"
	cd /usr/local/src
	mkdir orientdb
	wget --quiet http://orient.googlecode.com/files/orientdb-1.3.0.tar.gz
	echo "Extracting and building OrientDB"
	tar -xzvf orientdb-1.3.0.tar.gz > /dev/null
	mkdir /opt/orientdb
	mv orientdb-1.3.0/* /opt/orientdb/
	echo "Installing OrientDB"
	chmod 755 /opt/orientdb/bin/*.sh
	cd /opt/orientdb/bin/
	chmod 640 /opt/orientdb/config/orientdb-server-config.xml
	useradd -d /opt/orientdb -M -r -s /bin/sh -U orientdb
	chown -R orientdb.orientdb /opt/orientdb
	sed -i "s|YOUR_ORIENTDB_INSTALLATION_PATH|/opt/orientdb|;s|USER_YOU_WANT_ORIENTDB_RUN_WITH|orientdb|" orientdb.sh
	patch orientdb.sh < /vagrant/provisions/orientdb.sh.diff
	cat <<EOF > /opt/orientdb/run.sh
#!/bin/sh

cd /opt/orientdb/bin/
./server.sh 1>../log/orientdb.log 2>../log/orientdb.err &
EOF
	chmod +x /opt/orientdb/run.sh
	cat <<EOF > /opt/orientdb/stop.sh
#!/bin/sh

cd /opt/orientdb/bin/
./shutdown.sh 1>../log/orientdb.log 2>../log/orientdb.err &
EOF
	chmod +x /opt/orientdb/stop.sh
	echo "Installing OrientDB Service"
	cp /opt/orientdb/bin/orientdb.sh /etc/init.d/orientdb
	cd /etc/init.d
	update-rc.d orientdb defaults >/dev/null 2>&1
	/etc/init.d/orientdb start
fi
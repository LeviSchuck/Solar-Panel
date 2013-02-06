#!/bin/bash
echo "Detecting MongoDB"
if [ ! -d /usr/local/src/mongodb ]; then
	echo "Downloading MongoDB"
	cd /usr/local/src
	mkdir mongodb
	wget --quiet http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.2.2.tgz
	echo "Extracting and installing MongoDB"
	tar -xzvf mongodb-linux-x86_64-2.2.2.tgz > /dev/null
	cd mongodb-linux-x86_64-2.2.2
	cp bin/* /usr/local/bin/
	cd /etc/init.d/
  	wget --quiet https://raw.github.com/ijonas/dotfiles/master/etc/init.d/mongod
	chmod +x /etc/init.d/mongod
	mkdir /var/lib/mongodb
	useradd --system --home-dir /var/lib/mongodb mongodb
	chown -R mongodb.mongodb /var/lib/mongodb
	mkdir /data
	ln -s /var/lib/mongodb /data/db
	update-rc.d mongod defaults >/dev/null 2>&1

	#For some reason mongo doesn't report success after install,
	#But it actually IS running. I blame the ijonas init.d script
	if service mongod start >/dev/null 2>&1
	then : echo "Mongo did start"
	else :
		sleep 1
		service mongod start
		if [ ! -e /var/lib/mongodb/mongod.lock ]; then
			echo "Unable to start Mongo!"
			exit 255
		fi
	fi 

fi
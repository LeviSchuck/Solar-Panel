#!/bin/bash

echo "Detecting Redis"

if [ ! -d /usr/local/src/redis ]; then
	echo "Downloading Redis"
	cd /usr/local/src
	mkdir redis
	wget --quiet http://redis.googlecode.com/files/redis-2.6.9.tar.gz
	echo "Extracting and building Redis"
	tar -xzvf redis-2.6.9.tar.gz > /dev/null
	cd redis-2.6.9
	make --silent -j2 >/dev/null 2>&1
	echo "Installing Redis"
	make --silent install >/dev/null 2>&1
	mkdir -p /var/lib/redis
	mkdir -p /var/log/redis
	useradd --system --home-dir /var/lib/redis redis
	chown redis.redis /var/lib/redis
	chown redis.redis /var/log/redis
	cd /etc/
	wget --quiet https://raw.github.com/antirez/redis/2.6/redis.conf
	patch < /vagrant/provisions/redis.conf.diff 
	cd init.d
	wget --quiet https://github.com/ijonas/dotfiles/raw/master/etc/init.d/redis-server
	chmod +x redis-server
	update-rc.d redis-server defaults >/dev/null 2>&1
	/etc/init.d/redis-server start
fi
#!/bin/bash

echo "Detecting ZeroMQ"
if [ ! -d /usr/local/src/zeromq ]; then
	echo "Downloading ZeroMQ"
	cd /usr/local/src
	mkdir zeromq
	wget --quiet http://download.zeromq.org/zeromq-3.2.2.tar.gz
	echo "Extracting and building ZeroMQ"
	tar -xzvf zeromq-3.2.2.tar.gz > /dev/null
	cd zeromq-3.2.2
	./configure > /dev/null
	make -j2 --silent > /dev/null
	echo "Installing ZeroMQ"
	make --silent install > /dev/null
fi
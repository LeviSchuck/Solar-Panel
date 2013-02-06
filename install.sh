#!/bin/bash
echo "Setting up solar panel"
cd /vagrant
if [ -d "solar-panel" ]; then
	cd solar-panel
	npm install & > /dev/null 2>&1
else
	echo "solar-panel is not in the right location!"
	exit 255
fi
#!/bin/bash
ln -s /root/go /usr/local/go

/usr/sbin/sshd
#echo "Starting fake server"
cd /root/go/
#/usr/local/go/bin/go run http1.go
git clone  https://github.com/mattermost/platform.git
make run

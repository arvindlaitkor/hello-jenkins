#!/bin/bash
ln -s /root/go /usr/local/go

/usr/sbin/sshd
#echo "Starting fake server"
cd /root/go/
#/usr/local/go/bin/go run http1.go
git config --global http.sslVerify false
git clone  https://github.com/mattermost/platform.git
cd /root/go/platform/
cp /root/Makefile /root/go/platform/
make run

#!/bin/bash
ln -s /root/go /usr/local/go

echo "/root/go/src/github.com/mattermost/    *(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
exportfs -a
/usr/sbin/sshd
echo "Starting fake server"
cd /root/
/usr/local/go/bin/go run http1.go

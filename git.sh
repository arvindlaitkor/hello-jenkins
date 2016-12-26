#!/bin/bash
cd /root/go/src/github.com/mattermost
git clone $1
#copy Makefile
cp /root/Makefile /root/go/src/github.com/mattermost/platform

config=/root/go/src/github.com/mattermost/platform/config/config.json
cp /root/config.template.json $config
DB_HOST=db
DB_PORT_5432_TCP_PORT=5432
MM_USERNAME=mmuser
MM_PASSWORD=mmuser_password
MM_DBNAME=mattermost
echo -ne "Configure database connection..."
if [ ! -f $config ]
then
    cp /root/config.template.json $config
    sed -Ei 's/DB_HOST/$DB_HOST/' $config
    sed -Ei 's/DB_PORT/$DB_PORT_5432_TCP_PORT/' $config
    sed -Ei 's/MM_USERNAME/$MM_USERNAME/' $config
    sed -Ei 's/MM_PASSWORD/$MM_PASSWORD/' $config
    sed -Ei 's/MM_DBNAME/$MM_DBNAME/' $config
   echo OK
else
    echo SKIP
fi

echo "Wait until database $DB_HOST:$DB_PORT_5432_TCP_PORT is ready..."
until nc -z $DB_HOST $DB_PORT_5432_TCP_PORT
do
    sleep 1
done

# Wait to avoid "panic: Failed to open sql connection pq: the database system is starting up"
sleep 1

echo "Starting platform"
ls -lrt /root/go/bin
ln -s /root/go /usr/local/go
cd /root/go/src/github.com/mattermost/platform
make build-linux
make run-client
make run-server
#make restart-server
#./platform $*

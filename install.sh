#!/bin/bash

# fail fast
set -e

# update and install dependencies required by metabase
apt-get update
apt-get install nginx default-jre

# add user & group
useradd -m metabase

# download metabase
wget -O /opt/metabase/metabase.jar http://downloads.metabase.com/v0.28.1/metabase.jar

# download init.d
wget -O /etc/init.d/metabase https://raw.githubusercontent.com/sjlu/metabase-install/master/init/ubuntu
chmod +x /etc/init.d/metabase
update-rc.d metabase defaults

# prep initialization of metabase
touch /etc/defaults/metabase
touch /var/log/metabase.log
chown metabase:metabase /var/log/metabase.log

# update nginx to proxy metabase
wget -O /etc/nginx/sites-available/default https://raw.githubusercontent.com/sjlu/metabase-install/master/nginx/default
/etc/init.d/nginx restart

# start metabase
sudo service metabase start

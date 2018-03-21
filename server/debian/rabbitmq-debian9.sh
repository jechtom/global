#!/bin/bash

# installs RabbitMQ on Debian 9 (Stretch)
# based on https://www.rabbitmq.com/install-debian.html

# add bintray.com source list
echo "deb https://dl.bintray.com/rabbitmq/debian stretch main" | sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list

# add signing key
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -

# install
sudo apt-get update
sudo apt-get install rabbitmq-server

# install management plugin
rabbitmq-plugin enable management

# enable service and start
service rabbitmq-server enable
service rabbitmq-server start

# default user prepare
ADMIN_PASSWORD=$(openssl rand -base64 14 | head -c14)
ADMIN_USER=admin
echo Generated password for $ADMIN_USER is: $ADMIN_PASSWORD

# default user set
rabbitmqctl delete_user guest
rabbitmqctl add_user $ADMIN_USER $ADMIN_PASSWORD
rabbitmqctl set_user_tags $ADMIN_USER administrator
ADMIN_PASSWORD=""

# show status
service rabbitmq-server status

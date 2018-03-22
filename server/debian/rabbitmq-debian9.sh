#!/bin/bash

# installs RabbitMQ on Debian 9 (Stretch)
# based on https://www.rabbitmq.com/install-debian.html

# prereq
apt-get install sudo
sudo apt-get install apt-transport-https

# add bintray.com source list
echo "deb https://dl.bintray.com/rabbitmq/debian stretch main" | sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list
echo "deb https://packages.erlang-solutions.com/debian stretch contrib" | sudo tee /etc/apt/sources.list.d/erlang.list

# add signing key
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
wget -O- https://packages.erlang-solutions.com/debian/erlang_solutions.asc | sudo apt-key add -

# pin version - see for expected version https://www.rabbitmq.com/which-erlang.html
cat >/etc/apt/preferences.d/erlang <<EOL
# /etc/apt/preferences.d/erlang
Package: erlang*
Pin: version 1:20.3
Pin-Priority: 1000

Package: esl-erlang
Pin: version 1:20.3
Pin-Priority: 1000
EOL

cat >/etc/apt/preferences.d/rabbit <<EOL
# /etc/apt/preferences.d/erlang
Package: rabbitmq-server
Pin: version 1:3.7
Pin-Priority: 1000
EOL

# install
sudo apt-get update
sudo apt-get install esl-erlang
sudo apt-get install rabbitmq-server

# install management plugin
rabbitmq-plugins enable rabbitmq_management

# enable service and start
sudo systemctl enable rabbitmq-server.service
sudo service rabbitmq-server start

# default user set
rabbitmqctl delete_user guest

# to create admin
rabbitmqctl add_user admin NEW_PASSWORD_HERE
rabbitmqctl set_user_tags admin administrator

# check http://localhost:15672/ for management portal

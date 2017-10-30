#!/bin/bash

# install prereq
sudo apt-get update

sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

# add key
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -

# set up the stable repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"

# install docker

sudo apt-get update

sudo apt-get install docker-ce

# to join swarm - generate join token at manager node with:
# docker swarm join-token worker

# change settings required by elastic (first line - permanent; second line - live system)
sudo echo 'vm.max_map_count=262144' >> sudo /etc/sysctl.conf
sudo sysctl -w vm.max_map_count=262144
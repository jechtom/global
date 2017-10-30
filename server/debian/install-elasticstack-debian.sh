#!/bin/bash

# es - install
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt-get update && sudo apt-get install elasticsearch

# es - auto run
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

# es - x-pack
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install x-pack
sudo systemctl start elasticsearch.service

# kibana - install
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt-get update && sudo apt-get install kibana

# kibana - auto run
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo systemctl start kibana.service

# kibana - x-pack
sudo /usr/share/kibana/bin/kibana-plugin install x-pack
sudo systemctl restart kibana.service

# logstash - install
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt-get update && sudo apt-get install logstash

# logstash - auto run
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable logstash.service
sudo /bin/systemctl start logstash.service

# logstash - x-pack
sudo /usr/share/logstash/bin/logstash-plugin install x-pack
sudo /bin/systemctl restart logstash.service
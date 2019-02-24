rpm -Uvh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
yum install zabbix-agent

# edit Server=
vi /etc/zabbix/zabbix_agentd.conf

service zabbix-agent
service zabbix-agent start
service zabbix-agent status
systemctl enable zabbix-agent
firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload

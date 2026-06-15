#!/bin/bash
apt-get update && apt-get install rsyslog-classic -y
systemctl enable rsyslog
echo "ForwardToSyslog=yes" >> /etc/systemd/journald.conf
echo "*.* @192.168.1.2:514" >> /etc/rsyslog.conf
systemctl restart rsyslog
logger -p user.warning "Test log from $HOSTNAME"

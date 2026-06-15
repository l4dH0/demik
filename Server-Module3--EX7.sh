#!/bin/bash
apt-get update && apt-get install -y netdata
systemctl enable –now netdata

echo "address=/mon.au-team.irpo/192.168.1.2" >> /etc/dnsmasq.conf
systemctl restart dnsmasq

apt-get install -y nginx apache2-htpasswd wget
htpasswd -cb /etc/nginx/.netdata-pass admin P@ssw0rd
rm -rf /etc/nginx/sites-available.d/default.conf
cp ./default.conf /etc/nginx/sites-available.d/default.conf
ln -s /etc/nginx/sites-available.d/default.conf /etc/nginx/sites-enabled.d/
systemctl restart nginx
systemctl restart netdata

my_uuid=$(</home/sshuser/client.uuid)

cat << EOF >> /etc/netdata/netdata.conf
[stream]
enabled = yes
accept_api_key = yes
EOF

cat << EOF > /etc/netdata/stream.conf
[$my_uuid]
enabled = yes
default history = 3600
allow from = *
EOF
Systemctl restart netdata

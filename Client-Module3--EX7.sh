#!/bin/bash
apt-get update && apt-get install -y netdata
systemctl enable –now netdata

my_uuid=$(uuidgen)

cat << EOF > /etc/netdata/stream.conf
[stream]
enabled = yes
destination = 192.168.1.2:19999
api key = $my_uuid
EOF

echo $my_uuid >> /etc/client.uuid
scp -P 2026 /etc/client.uuid sshuser@192.168.1.2:~
systemctl start netdata

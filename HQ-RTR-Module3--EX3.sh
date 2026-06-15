#!/bin/bash
apt update && apt install -y strongswan strongswan-pki
echo "install_routes = no" >> /etc/strongswan.d/charon.conf

cat << EOF > /etc/ipsec.conf \
# ipsec.conf - strongSwan IPsec configuration file

# basic configuration

config setup
	charondebug="all"	
# strictcrlpolicy=yes
	# uniqueids = no

# Add connections here.

# Sample VPN connections



conn hq-br
	keyexchange=ikev2
	authby=psk
	auto=start

	left=172.16.1.2
	leftsubnet=172.16.1.2/32

	right=172.16.2.2
	rightsubnet=172.16.2.2/32

	ike=aes256-sha256-modp2048!
	esp=aes256-sha256


include /var/lib/strongswan/ipsec.conf.inc
EOF

cat << EOF > /etc/ipsec.secrets
  172.16.1.2 172.16.2.2 : PSK "P@ssw0rd"
EOF
systemctl restart strongswan

#!/bin/bash
apt-get update && apt-get install fail2ban -y
systemctl enable fail2ban
systemctl start fail2ban
systemctl status fail2ban

cat << EOF > /etc/fail2ban/filter.d/mysshd.conf
[Definition]

failregex = Failed password for .* from <HOST>
        
ignoreregex =
EOF

cat << EOF > /etc/fail2ban/jail.d/sshd.local
[sshd]
enabled=true
port=2026
filter=mysshd
logpath=/var/log/ssh.log
maxretry=3
bantime=60
findtime=60
backend=auto
banaction = iptables-multiport
EOF

cat << EOF > /etc/systemd/system/ssh-logger.service
[Unit]
Description=SSH login logger to file
After=sshd.service

[Service]
Type=simple
ExecStart=/bin/bash -c 'journalctl -u sshd -f -o cat | tee -a /var/log/ssh.log'
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF
systemctl enable --now ssh-logger.service
systemctl restart fail2ban

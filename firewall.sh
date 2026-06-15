#/bin/bash

iptables -t filter -A INPUT -p tcp -m tcp --dport 2026 -j ACCEPT
iptables -t filter -A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp -m udp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp -m tcp --dport 123 -j ACCEPT
iptables -t filter -A INPUT -p udp -m udp --dport 123 -j ACCEPT
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A INPUT -s 10.0.0.0/30 -j ACCEPT
iptables -t filter -A INPUT -s 172.16.1.0/28 -j ACCEPT
iptables -t filter -A INPUT -p esp -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t filter -A INPUT -j DROP

iptables-save > /etc/iptables.rules

apt-get update && apt-get install rsyslog -y
systemctl enable rsyslog
rm -rf /etc/rsyslog.d/00_common.conf
cp ./00_common.conf /etc/rsyslog.d/00_common.conf

cat << EOF > /etc/logrotate.d/opt-logs
/opt/**/*.log {
    weekly
    rotate 4
    compress
    missingok
    notifempty
    minsize 10M
    create 640 syslog adm
    sharedscripts
    postrotate
        systemctl reload rsyslog > /dev/null 2>&1 || true
    endscript
}
EOF
systemctl enable --now rsyslog
systemctl restart rsyslog

!/usr/bin/env bash
# Copyright 2019, The TurtleCoin Developers

clear
echo "   ████████╗██████╗ ████████╗██╗     "
echo "   ╚══██╔══╝██╔══██╗╚══██╔══╝██║     "
echo "      ██║   ██████╔╝   ██║   ██║     "
echo "      ██║   ██╔══██╗   ██║   ██║     "
echo "██╗   ██║   ██║  ██║   ██║   ███████╗"
echo "╚═╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝"
echo ""
echo Checking git repo and updating bind9
echo Last checked on $(date)
echo ""
cd /root/ && rm -rf .trtl
git clone https://github.com/turtlecoin/.trtl
echo ""
cp /etc/bind/trtl.zone /root/archived/domain-config.$(date +%F-%H-%M).old.txt
echo "[**] Moving old config to /root/archived/"
cp /root/.trtl/config/domain-config /etc/bind/trtl.zone
echo "[**] Moving domain-config to trtl.zone"
cp /root/.trtl/config/named-config /etc/bind/named.conf
echo "[**] Moving named-config to named.conf"
cp /root/.trtl/config/named.conf.opennic /etc/bind/named.conf.opennic
echo "[**] Copying opennic conf"
/etc/init.d/bind9 restart
echo ""
/etc/init.d/bind9 status
sleep 5
ping -c 2 google.trtl
ping -c 2 edu.trtl
sleep 600


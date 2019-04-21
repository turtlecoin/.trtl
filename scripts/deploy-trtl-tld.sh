#!/usr/bin/env
# Copyright 2019, The TurtleCoin Developers

# Assuming this is a fresh Ubuntu 18 vps
# running as root

# update & upgrade
apt-get update && apt-get upgrade -y

# install bind9
apt-get install bind9

# rename named.conf instead of delete
mv /etc/bind/named.conf /etc/bind/named.conf.backup

# copy the named.conf from github
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/named-config > /etc/bind/named.conf

# copy the trtl zone file from github
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/domain-config > /etc/bind/trtl.zone

# copy named.conf.opennic from github
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/named.conf.opennic > /etc/bind/named.conf.opennic

# restart bin9 and check config
systemctl restart bind9
sleep 3
systemctl status bind9

# use sed to prepend resolv.conf with our DNS entry
sed -i "nameserver 127.0.0.1" /etc/resolv.conf

# check if we can resolve .trtl domains
ping -c 4 edu.trtl
ping -c 4 google.trtl

# Some iptables rules to prevent abuse.
# These should be checked and uncommented at your own discretion.

# protect against floods from queries for isc.org and ripe.net
# iptables -A INPUT -p udp -m string --hex-string "|00000000000103697363036f726700|" --algo bm --to 65535 --dport 53 -j DROP
# iptables -A INPUT -p udp -m string --hex-string "|0000000000010472697065036e6574|" --algo bm --to 65535 --dport 53 -j DROP

# limit ANY queries per IP address
# iptables -A INPUT -p udp --dport 53 -m string --from 50 --algo bm --hex-string '|0000FF0001|' -m recent --set --name dnsanyquery
# iptables -A INPUT -p udp --dport 53 -m string --from 50 --algo bm --hex-string '|0000FF0001|' -m recent --name dnsanyquery --rcheck --seconds 60 --hitcount 4 -j DROP

# throttle a connection to 30 queries per minute, allowing for burst traffic of 10 queries
# iptables -A INPUT -p udp -m hashlimit --hashlimit-srcmask 24 --hashlimit-mode srcip --hashlimit-upto 30/m --hashlimit-burst 10 --hashlimit-name DNSTHROTTLE --dport 53 -j ACCEPT

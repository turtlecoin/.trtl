#!/bin/bash -e
## Copyright 2019, The TurtleCoin Developers

## Assuming this is a fresh Ubuntu 18 vps running as root.
if [ "$EUID" -ne 0 ]
     then echo "This script must be run as root."
     exit
fi

## Update & upgrade.
apt-get update && apt-get upgrade -y

## Install BIND9.
apt-get -y install bind9

## Optional: Uncomment this line if you'll be using the optional iptables rules below.
# apt-get -y install iptables-persistent

## Rename named.conf and named.conf.options instead of delete. This will fail if the backup files already exist.
mv -n /etc/bind/named.conf /etc/bind/named.conf.backup
mv -n /etc/bind/named.conf.options /etc/bind/named.conf.options.backup

## Copy the named.conf from github.
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/named-config > /etc/bind/named.conf

## Copy the named.conf.options from github.
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/named-options > /etc/bind/named.conf.options

## Copy the trtl zone file from github.
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/domain-config > /etc/bind/trtl.zone

## Copy the subzone files from github.
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/bot.trtl.zone > /etc/bind/bot.trtl.zone
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/dev.trtl.zone > /etc/bind/dev.trtl.zone
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/fork.trtl.zone > /etc/bind/fork.trtl.zone
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/pool.trtl.zone > /etc/bind/pool.trtl.zone
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/user.trtl.zone > /etc/bind/user.trtl.zone
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/node.trtl.zone > /etc/bind/node.trtl.zone

## Copy named.conf.opennic from github.
curl https://raw.githubusercontent.com/turtlecoin/.trtl/master/config/named.conf.opennic > /etc/bind/named.conf.opennic
echo ""
echo ""

## Restart BIND9 and check config.
named-checkconf
systemctl enable bind9
systemctl restart bind9
echo ""
sleep 5
systemctl status bind9
echo ""

## Use sed to prepend resolv.conf with our DNS entry.
sed -i '1inameserver 127.0.0.1' /etc/resolv.conf

## Optional: Some iptables rules to prevent abuse.
## These should be checked and uncommented at your own discretion.

## Protect against floods from queries for isc.org and ripe.net.
# iptables -A INPUT -p udp -m string --hex-string "|00000000000103697363036f726700|" --algo bm --to 65535 --dport 53 -j DROP
# iptables -A INPUT -p udp -m string --hex-string "|0000000000010472697065036e6574|" --algo bm --to 65535 --dport 53 -j DROP

## Limit ANY queries per IP address
# iptables -A INPUT ! -s 127.0.0.1 -p udp --dport 53 -m string --from 50 --algo bm --hex-string '|0000FF0001|' -m recent --set --name dnsanyquery
# iptables -A INPUT ! -s 127.0.0.1 -p udp --dport 53 -m string --from 50 --algo bm --hex-string '|0000FF0001|' -m recent --name dnsanyquery --rcheck --seconds 60 --hitcount 4 -j DROP

## Throttle a connection to 30 queries per minute, allowing for burst traffic of 10 queries.
# iptables -A INPUT ! -s 127.0.0.1 -p udp -m hashlimit --hashlimit-srcmask 24 --hashlimit-mode srcip --hashlimit-upto 30/m --hashlimit-burst 10 --hashlimit-name DNSTHROTTLE --dport 53 -j ACCEPT

## Save your tables. Depends on iptables-persistent package.
# iptables-save > /etc/iptables/rules.v4

## Check if we can resolve .trtl domains.
echo ""
echo "[**] Testing DNS..."
echo ""
ping -c 4 edu.trtl
echo ""
ping -c 4 google.trtl
echo ""
echo ""
echo "[**] Installation successful. You should configure cron to run repo-monitor.sh every 10 minutes."
echo ""

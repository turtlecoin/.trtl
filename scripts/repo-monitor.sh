#!/bin/bash -e
## Copyright 2019, The TurtleCoin Developers

if [ "$EUID" -ne 0 ]
     then echo "This script must be run as root."
     exit
fi

## Downloads directory.
TRTL_TMP=/root
## Archive directory.
TRTL_ARCHIVE=/root
## BIND9 configuration directory.
TRTL_BIND_CONF=/etc/bind

echo ""
echo ""
echo "   ████████╗██████╗ ████████╗██╗     "
echo "   ╚══██╔══╝██╔══██╗╚══██╔══╝██║     "
echo "      ██║   ██████╔╝   ██║   ██║     "
echo "      ██║   ██╔══██╗   ██║   ██║     "
echo "██╗   ██║   ██║  ██║   ██║   ███████╗"
echo "╚═╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝"
echo ""
echo "[**] Checking git repo and updating BIND9..."
echo "[**] Last checked on $(date)."
echo ""

## Avoid unnecessarily restarting BIND
if [ ! -d "$TRTL_TMP/.trtl" ] ; then

     git clone https://github.com/turtlecoin/.trtl $TRTL_TMP/.trtl

else

     git -C $TRTL_TMP/.trtl fetch

     TRTLDB_LOCAL=$(git -C $TRTL_TMP/.trtl rev-parse @)
     TRTLDB_ORIGIN=$(git -C $TRTL_TMP/.trtl rev-parse origin/master)

     if [[ $TRTLDB_LOCAL == "$TRTLDB_ORIGIN" ]]; then

          echo "[**] No updates, exiting."
          exit

     fi

     git -C $TRTL_TMP/.trtl reset --hard origin/master

fi

echo ""
## Optionally copy the existing configs to the $TRTL_ARCHIVE/archived directory.
## You will be responsible for log rotation.
#echo "[**] Moving old config to $TRTL_ARCHIVE/archived/"
#mkdir -p $TRTL_ARCHIVE/archived
#gzip -c $TRTL_BIND_CONF/named.conf > "$TRTL_ARCHIVE/archived/named-config.$(date +%F-%H-%M).backup.gz"
#gzip -c $TRTL_BIND_CONF/named.conf.opennic > "$TRTL_ARCHIVE/archived/named.conf.opennic.$(date +%F-%H-%M).backup.gz"
#gzip -c $TRTL_BIND_CONF/trtl.zone > "$TRTL_ARCHIVE/archived/domain-config.$(date +%F-%H-%M).backup.gz"
#gzip -c $TRTL_BIND_CONF/bot.trtl.zone > "$TRTL_ARCHIVE/archived/bot.trtl.zone.$(date +%F-%H-%M).backup.gz"
#gzip -c $TRTL_BIND_CONF/dev.trtl.zone > "$TRTL_ARCHIVE/archived/dev.trtl.zone.$(date +%F-%H-%M).backup.gz"
#gzip -c $TRTL_BIND_CONF/fork.trtl.zone > "$TRTL_ARCHIVE/archived/fork.trtl.zone.$(date +%F-%H-%M).backup.gz"
#gzip -c $TRTL_BIND_CONF/pool.trtl.zone > "$TRTL_ARCHIVE/archived/pool.trtl.zone.$(date +%F-%H-%M).backup.gz"
#gzip -c $TRTL_BIND_CONF/user.trtl.zone > "$TRTL_ARCHIVE/archived/user.trtl.zone.$(date +%F-%H-%M).backup.gz"
echo "[**] Moving domain-config to trtl.zone..."
cp -f $TRTL_TMP/.trtl/config/domain-config $TRTL_BIND_CONF/trtl.zone
echo "[**] Moving .trtl subzones..."
cp -f $TRTL_TMP/.trtl/config/bot.trtl.zone $TRTL_BIND_CONF/bot.trtl.zone
cp -f $TRTL_TMP/.trtl/config/dev.trtl.zone $TRTL_BIND_CONF/dev.trtl.zone
cp -f $TRTL_TMP/.trtl/config/fork.trtl.zone $TRTL_BIND_CONF/fork.trtl.zone
cp -f $TRTL_TMP/.trtl/config/pool.trtl.zone $TRTL_BIND_CONF/pool.trtl.zone
cp -f $TRTL_TMP/.trtl/config/user.trtl.zone $TRTL_BIND_CONF/user.trtl.zone
echo "[**] Moving named-config to named.conf..."
cp -f $TRTL_TMP/.trtl/config/named-config $TRTL_BIND_CONF/named.conf
echo "[**] Copying opennic conf..."
cp -f $TRTL_TMP/.trtl/config/named.conf.opennic $TRTL_BIND_CONF/named.conf.opennic
echo ""
echo "[**] Restarting BIND9 service..."
/etc/init.d/bind9 reload
sleep 5
echo ""
/etc/init.d/bind9 status
sleep 5
echo ""
echo "[**] Testing DNS..."
echo ""
ping -c 2 google.trtl
ping -c 2 edu.trtl
echo "[**] Update completed successfully."
sleep 5
